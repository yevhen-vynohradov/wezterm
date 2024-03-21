---@class WezTerm
local wezterm = require("wezterm") ---@class WezTerm
local fun = require("utils.fun") ---@class Fun
local icons = require("utils.icons") ---@class Icons
local StatusBar = require("utils.layout") ---@class Layout

local strwidth = fun.strwidth

local M = {}
--       local active_workspace = window:active_workspace()

local normal_mode_text =  " ".. icons.Mode.normal .." NORMAL "
local copy_mode_text =    " ".. icons.Mode.copy   .." COPY "
local search_mode_text =  " ".. icons.Mode.search .." SEARCH "
local window_mode_text =  " ".. icons.Mode.window .." WINDOW "
local font_mode_text =    " ".. icons.Mode.font .." FONT "
local lock_mode_text =    " ".. icons.Mode.lock .." LOCK "


M.setup = function()
   wezterm.on("update-status", function(window, pane)
      local theme = require("colors")[fun.get_scheme()]
      local modes = {
        normal_mode = { text = normal_mode_text,  bg = theme.ansi[5] },
        copy_mode   = { text = copy_mode_text,    bg = theme.brights[3] },
        search_mode = { text = search_mode_text,  bg = theme.brights[4] },
        window_mode = { text = window_mode_text,  bg = theme.ansi[6] },
        font_mode   = { text = font_mode_text,    bg = theme.indexed[16] or theme.ansi[8] },
        lock_mode   = { text = lock_mode_text,    bg = theme.ansi[8] },
      }
    
      local bg = theme.ansi[5]
      local mode_indicator_width = 0
    
      -- {{{1 LEFT STATUS
      local LeftStatus = StatusBar:new() ---@class Layout
      local name = window:active_key_table()

      if not name then
        name = 'normal_mode'
      end

      if name and modes[name] then
        local txt = modes[name].text or ""
        mode_indicator_width, bg = strwidth(txt), modes[name].bg
        LeftStatus:push(bg, theme.background, txt, { "Bold" })
      end
    
      window:set_left_status(wezterm.format(LeftStatus))
      -- }}}
    
      -- {{{1 RIGHT STATUS
      local RightStatus = StatusBar:new() ---@class Layout
    
      bg = wezterm.color.parse(bg)
      local colors = { bg:darken(0.15), bg, bg:lighten(0.15), bg:lighten(0.25) }

      local battary = '-'
      for _, b in ipairs(wezterm.battery_info()) do
        local level = fun.toint(fun.mround(b.state_of_charge * 100, 10))
        local ico = icons.Battery[b.state][tostring(level)]

        battary = ("%s %i%%"):format(
          ico,
          tonumber(math.floor(b.state_of_charge * 100 + 0.5))
        )
      end

      local datetime = wezterm.strftime "%a %b %-d %H:%M"
      local cwd, hostname = fun.get_cwd_hostname(pane, true)
    
      --~ {{{2 Calculate the used width by the tabs
      local MuxWindow = window:mux_window()
      local tab_bar_width = 0
      for _, MuxTab in ipairs(MuxWindow:tabs()) do
        -- tab_bar_width = tab_bar_width + strwidth(MuxTab:panes()[1]:get_title()) + 2
        tab_bar_width = tab_bar_width + string.len(MuxTab:panes()[1]:get_title()) + 2
        wezterm.log_info('LOG: ' .. tab_bar_width)
      end
    
      local Config = MuxWindow:gui_window():effective_config() ---@class Config
      local has_button = Config.show_new_tab_button_in_tab_bar
      local new_tab_button = has_button and Config.tab_bar_style.new_tab or ""
      tab_bar_width = tab_bar_width + mode_indicator_width + strwidth(new_tab_button)
      --~ }}}
    
      local usable_width = pane:get_dimensions().cols - tab_bar_width - 4 ---padding
      local fancy_bg = Config.window_frame.active_titlebar_bg
      local last_fg = Config.use_fancy_tab_bar and fancy_bg or theme.tab_bar.background

      ---push each cell and the cells separator
      for i, cell in ipairs({ cwd, hostname, datetime, battary }) do
        local cell_bg = colors[i]
        local cell_fg = i == 1 and last_fg or colors[i - 1]
        local sep = icons.Separators.StatusBar.right
    
        ---add each cell separator
        RightStatus:push(cell_fg, cell_bg, sep)
    
        usable_width = usable_width - strwidth(cell) - strwidth(sep)
    
        ---add cell or empty string
        cell = usable_width <= 0 and " " or " " .. cell .. " "
        RightStatus:push(colors[i], theme.tab_bar.background, cell, { "Bold" })
      end
    
      window:set_right_status(wezterm.format(RightStatus))
      -- }}}
    end)
end

return M

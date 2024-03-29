---@class WezTerm
local wezterm = require("wezterm")
local fun = require("utils.fun") ---@class Fun
local icons = require("utils.icons") ---@class Icons
local themes = require("colors")
local StatusBar = require("utils.layout") ---@class Layout
local custom_colors = require("utils.custom_colors")

local strwidth = fun.strwidth

local normal_mode_text = " " .. icons.Mode.normal .. " NORMAL "
local copy_mode_text = " " .. icons.Mode.copy .. " COPY "
local search_mode_text = " " .. icons.Mode.search .. " SEARCH "
local window_mode_text = " " .. icons.Mode.window .. " WINDOW "
local font_mode_text = " " .. icons.Mode.font .. " FONT "
local lock_mode_text = " " .. icons.Mode.lock .. " LOCK "

local l_sep = icons.Separators.StatusBar.left
local r_sep = icons.Separators.StatusBar.right

local M = {}

M.setup = function()
  wezterm.on("update-status", function(window, pane)
    local MuxWindow = window:mux_window()
    ---@class Config
    local Config = MuxWindow:gui_window():effective_config()
    local theme = themes[fun.get_scheme()]
    local theme_bg = theme.ansi[5]
    local bg = wezterm.color.parse(theme_bg)
    local colors = { bg:darken(0.15), bg, bg:lighten(0.15), bg:lighten(0.25) }
    local has_button = Config.show_new_tab_button_in_tab_bar
    local fancy_bg = Config.window_frame.active_titlebar_bg
    local last_fg = Config.use_fancy_tab_bar and fancy_bg or theme.tab_bar.background
    local wrkspc_cell = " " .. window:active_workspace() .. " "
    local mode_name = window:active_key_table() or 'normal_mode'
    local battary = '-'
    local datetime = wezterm.strftime("%a %b %-d %H:%M")
    local cwd, hostname = fun.get_cwd_hostname(pane, true)
    local modeNameCell = ''


    local modes = {
      normal_mode = { text = normal_mode_text, bg = theme.ansi[5] },
      copy_mode   = { text = copy_mode_text, bg = theme.brights[3] },
      search_mode = { text = search_mode_text, bg = theme.brights[4] },
      window_mode = { text = window_mode_text, bg = theme.ansi[6] },
      font_mode   = { text = font_mode_text, bg = theme.indexed[16] or theme.ansi[8] },
      lock_mode   = { text = lock_mode_text, bg = theme.ansi[8] },
    }

    local mode_indicator_width = 0
    local wrkspc_indicator_width = 0
    local tab_bar_width = 0
    local new_tab_button = 0


    local LeftStatus = StatusBar:new() ---@class Layout
    local RightStatus = StatusBar:new() ---@class Layout

    --~ {{{2 Calculate the used width by the tabs
    for _, MuxTab in ipairs(MuxWindow:tabs()) do
      -- tab_bar_width = tab_bar_width + strwidth(MuxTab:panes()[1]:get_title()) + 2
      tab_bar_width = tab_bar_width + string.len(MuxTab:panes()[1]:get_title()) + 2
    end

    new_tab_button = strwidth(has_button and Config.tab_bar_style.new_tab or "")
    wrkspc_indicator_width = strwidth(wrkspc_cell .. l_sep)
    if mode_name and modes[mode_name] then
      modeNameCell = modes[mode_name].text or ""
    end
    mode_indicator_width = strwidth(modeNameCell)
    theme_bg = modes[mode_name].bg
    tab_bar_width = wrkspc_indicator_width + tab_bar_width + mode_indicator_width + new_tab_button
    local usable_width = pane:get_dimensions().cols - tab_bar_width - 4 ---padding

    -- }}}
    for _, b in ipairs(wezterm.battery_info()) do
      local lvl = fun.toint(fun.mround(b.state_of_charge * 100, 10))
      local ico = icons.Battery[b.state][tostring(lvl)]

      battary = ("%s %i%%"):format(
        ico,
        tonumber(math.floor(b.state_of_charge * 100 + 0.5))
      )
    end

    ---push each cell and the cells separator
    for i, cell in ipairs({ cwd, hostname, datetime, battary }) do
      local cell_bg = colors[i]
      local cell_fg = i == 1 and last_fg or colors[i - 1]

      ---add each cell separator
      RightStatus:push(cell_fg, cell_bg, r_sep)

      usable_width = usable_width - strwidth(cell) - strwidth(r_sep)

      ---add cell or empty string
      cell = usable_width <= 0 and " " or " " .. cell .. " "
      RightStatus:push(colors[i], theme.tab_bar.background, cell, { "Bold" })
    end

    LeftStatus:push(custom_colors.window_border_color, theme.brights[3], wrkspc_cell, { "Bold" })
    LeftStatus:push(modes[mode_name].bg, custom_colors.window_border_color, l_sep)
    LeftStatus:push(theme_bg, theme.background, modeNameCell, { "Bold" })

    window:set_right_status(wezterm.format(RightStatus))
    window:set_left_status(wezterm.format(LeftStatus))
  end)
end

return M

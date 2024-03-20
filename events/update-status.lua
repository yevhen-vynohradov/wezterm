---@class WezTerm
local wezterm = require("wezterm") ---@class WezTerm
local fun = require("utils.fun") ---@class Fun
local icons = require("utils.icons") ---@class Icons
local StatusBar = require("utils.layout") ---@class Layout

local strwidth = fun.strwidth

-- luacheck: push ignore 561

-- luacheck: pop

-- vim: fdm=marker fdl=1

-- local wezterm = require('wezterm')
-- local nf = wezterm.nerdfonts
-- local umath = require('utils.math')
local M = {}

-- local SEPARATOR_CHAR = nf.oct_dash .. ' '

-- local discharging_icons = {
--    nf.md_battery_10,
--    nf.md_battery_20,
--    nf.md_battery_30,
--    nf.md_battery_40,
--    nf.md_battery_50,
--    nf.md_battery_60,
--    nf.md_battery_70,
--    nf.md_battery_80,
--    nf.md_battery_90,
--    nf.md_battery,
-- }
-- local charging_icons = {
--    nf.md_battery_charging_10,
--    nf.md_battery_charging_20,
--    nf.md_battery_charging_30,
--    nf.md_battery_charging_40,
--    nf.md_battery_charging_50,
--    nf.md_battery_charging_60,
--    nf.md_battery_charging_70,
--    nf.md_battery_charging_80,
--    nf.md_battery_charging_90,
--    nf.md_battery_charging,
-- }

-- local colors = {
--    date_fg = '#fab387',
--    date_bg = 'rgba(0, 0, 0, 0.4)',
--    battery_fg = '#f9e2af',
--    battery_bg = 'rgba(0, 0, 0, 0.4)',
--    separator_fg = '#74c7ec',
--    separator_bg = 'rgba(0, 0, 0, 0.4)',
-- }

-- local __cells__ = {} -- wezterm FormatItems (ref: https://wezfurlong.org/wezterm/config/lua/wezterm/format.html)

-- ---@param text string
-- ---@param icon string
-- ---@param fg string
-- ---@param bg string
-- ---@param separate boolean
-- local _push = function(text, icon, fg, bg, separate)
--    table.insert(__cells__, { Foreground = { Color = fg } })
--    table.insert(__cells__, { Background = { Color = bg } })
--    table.insert(__cells__, { Attribute = { Intensity = 'Bold' } })
--    table.insert(__cells__, { Text = icon .. ' ' .. text .. ' ' })

--    if separate then
--       table.insert(__cells__, { Foreground = { Color = colors.separator_fg } })
--       table.insert(__cells__, { Background = { Color = colors.separator_bg } })
--       table.insert(__cells__, { Text = SEPARATOR_CHAR })
--    end
-- end

-- local _set_date = function()
--    local date = wezterm.strftime(' %a %H:%M')
--    _push(date, nf.fa_calendar, colors.date_fg, colors.date_bg, true)
-- end

-- local _set_battery = function()
--    -- ref: https://wezfurlong.org/wezterm/config/lua/wezterm/battery_info.html

--    local charge = ''
--    local icon = ''

--    for _, b in ipairs(wezterm.battery_info()) do
--       local idx = umath.clamp(umath.round(b.state_of_charge * 10), 1, 10)
--       charge = string.format('%.0f%%', b.state_of_charge * 100)

--       if b.state == 'Charging' then
--          icon = charging_icons[idx]
--       else
--          icon = discharging_icons[idx]
--       end
--    end

--    _push(charge, icon, colors.battery_fg, colors.battery_bg, false)
-- end

-- wezterm.on('update-right-status', function(window, _pane)
--    __cells__ = {}
--    _set_date()
--    _set_battery()

--    window:set_right_status(wezterm.format(__cells__))

--    function get_left_cells()
--       -- Color palette for the backgrounds of each cell
--       local colors = {
--          "#3c1361",
--          "#52307c",
--          "#663a82",
--          "#7c5295",
--          "#b491c8",
--       }
--       -- Foreground color for the text across the fade
--       local text_fg = "#c0c0c0"

--       local elements = {}
--       local num_cells = 0
--       local cell_no = num_cells + 1
--       -- The filled in variant of the > symbol
--       local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider
--       local active_workspace = window:active_workspace()
--       table.insert(elements, { Foreground = { Color = text_fg } })
--       table.insert(elements, { Background = { Color = '#5002f7' } })
--       table.insert(elements, { Text = "  " .. active_workspace .. "  " })
--       table.insert(elements, { Background = { Color = "#1a1b26" } })
--       table.insert(elements, { Foreground = { Color = '#5002f7' } })
--       table.insert(elements, { Text = SOLID_RIGHT_ARROW })
--       table.insert(elements, { Background = { Color = "#1a1b26" } })
--       table.insert(elements, { Foreground = { Color = colors[cell_no + 0] } })
--       table.insert(elements, { Text = "     " })
--       return elements
--    end

--    local left_cells = get_left_cells()
--    window:set_left_status(wezterm.format(left_cells))
-- end)


M.setup = function()
   wezterm.on("update-status", function(window, pane)
      local theme = require("colors")[fun.get_scheme()]
      local modes = {
        copy_mode = { text = " 󰆏 COPY ", bg = theme.brights[3] },
        search_mode = { text = " 󰍉 SEARCH ", bg = theme.brights[4] },
        window_mode = { text = " 󱂬 WINDOW ", bg = theme.ansi[6] },
        font_mode = { text = " 󰛖 FONT ", bg = theme.indexed[16] or theme.ansi[8] },
        lock_mode = { text = "  LOCK ", bg = theme.ansi[8] },
      }
    
      local bg = theme.ansi[5]
      local mode_indicator_width = 0
    
      -- {{{1 LEFT STATUS
      local LeftStatus = StatusBar:new() ---@class Layout
      local name = window:active_key_table()
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
    
      local battery = wezterm.battery_info()[1]
      battery.lvl = fun.toint(fun.mround(battery.state_of_charge * 100, 10))
      battery.ico = icons.Battery[battery.state][tostring(battery.lvl)]
      battery.full = ("%s %i%%"):format(
        battery.ico,
        tonumber(math.floor(battery.state_of_charge * 100 + 0.5))
      )
    
      local datetime = wezterm.strftime "%a %b %-d %H:%M"
      local cwd, hostname = fun.get_cwd_hostname(pane, true)
    
      --~ {{{2 Calculate the used width by the tabs
      local MuxWindow = window:mux_window()
      local tab_bar_width = 0
      for _, MuxTab in ipairs(MuxWindow:tabs()) do
        -- tab_bar_width = tab_bar_width + strwidth(MuxTab:panes()[1]:get_title()) + 2
        tab_bar_width = tab_bar_width + string.len(MuxTab:panes()[1]:get_title()) + 2
        wezterm.log_info(tab_bar_width)
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
      for i, cell in ipairs { cwd, hostname, datetime, battery.full } do
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

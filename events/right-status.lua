local wezterm = require('wezterm')
local nf = wezterm.nerdfonts
local umath = require('utils.math')
local M = {}

local SEPARATOR_CHAR = nf.oct_dash .. ' '

local discharging_icons = {
   nf.md_battery_10,
   nf.md_battery_20,
   nf.md_battery_30,
   nf.md_battery_40,
   nf.md_battery_50,
   nf.md_battery_60,
   nf.md_battery_70,
   nf.md_battery_80,
   nf.md_battery_90,
   nf.md_battery,
}
local charging_icons = {
   nf.md_battery_charging_10,
   nf.md_battery_charging_20,
   nf.md_battery_charging_30,
   nf.md_battery_charging_40,
   nf.md_battery_charging_50,
   nf.md_battery_charging_60,
   nf.md_battery_charging_70,
   nf.md_battery_charging_80,
   nf.md_battery_charging_90,
   nf.md_battery_charging,
}

local colors = {
   date_fg = '#fab387',
   date_bg = 'rgba(0, 0, 0, 0.4)',
   battery_fg = '#f9e2af',
   battery_bg = 'rgba(0, 0, 0, 0.4)',
   separator_fg = '#74c7ec',
   separator_bg = 'rgba(0, 0, 0, 0.4)',
}

local __cells__ = {} -- wezterm FormatItems (ref: https://wezfurlong.org/wezterm/config/lua/wezterm/format.html)

---@param text string
---@param icon string
---@param fg string
---@param bg string
---@param separate boolean
local _push = function(text, icon, fg, bg, separate)
   table.insert(__cells__, { Foreground = { Color = fg } })
   table.insert(__cells__, { Background = { Color = bg } })
   table.insert(__cells__, { Attribute = { Intensity = 'Bold' } })
   table.insert(__cells__, { Text = icon .. ' ' .. text .. ' ' })

   if separate then
      table.insert(__cells__, { Foreground = { Color = colors.separator_fg } })
      table.insert(__cells__, { Background = { Color = colors.separator_bg } })
      table.insert(__cells__, { Text = SEPARATOR_CHAR })
   end
end

local _set_date = function()
   local date = wezterm.strftime(' %a %H:%M')
   _push(date, nf.fa_calendar, colors.date_fg, colors.date_bg, true)
end

local _set_battery = function()
   -- ref: https://wezfurlong.org/wezterm/config/lua/wezterm/battery_info.html

   local charge = ''
   local icon = ''

   for _, b in ipairs(wezterm.battery_info()) do
      local idx = umath.clamp(umath.round(b.state_of_charge * 10), 1, 10)
      charge = string.format('%.0f%%', b.state_of_charge * 100)

      if b.state == 'Charging' then
         icon = charging_icons[idx]
      else
         icon = discharging_icons[idx]
      end
   end

   _push(charge, icon, colors.battery_fg, colors.battery_bg, false)
end

M.setup = function()
   wezterm.on('update-right-status', function(window, _pane)
      __cells__ = {}
      _set_date()
      _set_battery()

      window:set_right_status(wezterm.format(__cells__))

      function get_left_cells()
         -- Color palette for the backgrounds of each cell
         local colors = {
            "#3c1361",
            "#52307c",
            "#663a82",
            "#7c5295",
            "#b491c8",
         }
         -- Foreground color for the text across the fade
         local text_fg = "#c0c0c0"

         local elements = {}
         local num_cells = 0
         local cell_no = num_cells + 1
         -- The filled in variant of the > symbol
         local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider
         local active_workspace = window:active_workspace()
         table.insert(elements, { Foreground = { Color = text_fg } })
         table.insert(elements, { Background = { Color = '#5002f7' } })
         table.insert(elements, { Text = "  " .. active_workspace .. "  " })
         table.insert(elements, { Background = { Color = "#1a1b26" } })
         table.insert(elements, { Foreground = { Color = '#5002f7' } })
         table.insert(elements, { Text = SOLID_RIGHT_ARROW })
         table.insert(elements, { Background = { Color = "#1a1b26" } })
         table.insert(elements, { Foreground = { Color = colors[cell_no + 0] } })
         table.insert(elements, { Text = "     " })
         return elements
      end

      local left_cells = get_left_cells()
      window:set_left_status(wezterm.format(left_cells))
   end)
end

return M

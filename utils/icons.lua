---Nerd fonts aggregated by type/class/etc.
---@class Icons
local M = {}

---@class WezTerm
local wezterm = require "wezterm"
local nf = wezterm.nerdfonts

---@class SeparatorsIcons: StatusBarIcons, TabBarIcons
M.Separators = {
  ---@class StatusBarIcons: string, string
  ---@field left  string ``
  ---@field right string ``
  StatusBar = {
    left = nf.pl_left_hard_divider,
    right = nf.pl_right_hard_divider,
  },

  ---@class TabBarIcons: string, string, string
  ---@field leftmost string `▐`
  ---@field left     string ``
  ---@field right    string ``
  TabBar = {
    leftmost = "▐",
    left = nf.ple_upper_right_triangle,
    right = nf.ple_lower_left_triangle,
  },

  FullBlock = "█",
}

M.Vim = nf.dev_vim

M.Pwsh = nf.md_powershell

M.Bash = nf.md_bash

M.Git = nf.md_git

---@class BatteryIcons: table, table
---@field charging table Icons for charging battery in increments of 10
---@field normal   table Icons for non-charging battery in increments of 10
M.Battery = {
  Charging = {
    ["00"] = nf.md_battery_alert,
    ["10"] = nf.md_battery_charging_10,
    ["20"] = nf.md_battery_charging_20,
    ["30"] = nf.md_battery_charging_30,
    ["40"] = nf.md_battery_charging_40,
    ["50"] = nf.md_battery_charging_50,
    ["60"] = nf.md_battery_charging_60,
    ["70"] = nf.md_battery_charging_70,
    ["80"] = nf.md_battery_charging_80,
    ["90"] = nf.md_battery_charging_90,
    ["100"] = nf.md_battery_charging_100,
  },

  Discharging = {
    ["00"] = nf.md_battery_outline,
    ["10"] = nf.md_battery_10,
    ["20"] = nf.md_battery_20,
    ["30"] = nf.md_battery_30,
    ["40"] = nf.md_battery_40,
    ["50"] = nf.md_battery_50,
    ["60"] = nf.md_battery_60,
    ["70"] = nf.md_battery_70,
    ["80"] = nf.md_battery_80,
    ["90"] = nf.md_battery_90,
    ["100"] = nf.md_battery,
  },
  Full = {
    ["100"] = nf.md_battery,
  },
}

M.Admin = nf.md_lightning_bolt

M.UnseenNotification = nf.oct_star

M.Numbers = {
  nf.md_numeric_1,
  nf.md_numeric_2,
  nf.md_numeric_3,
  nf.md_numeric_4,
  nf.md_numeric_5,
  nf.md_numeric_6,
  nf.md_numeric_7,
  nf.md_numeric_8,
  nf.md_numeric_9,
  nf.md_numeric_10,
}

M.Mode = {
  normal = nf.md_keyboard,
  copy = nf.md_content_copy,
  search = nf.md_magnify,
  window = nf.md_dock_window,
  font = nf.md_format_font,
  lock = nf.fa_lock,
}

return M
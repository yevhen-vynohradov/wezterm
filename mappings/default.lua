local wezterm = require('wezterm')
local act = wezterm.action
local fun = require "utils.fun" ---@class Fun

---@class Config
local Config = {}

Config.disable_default_key_bindings = true
Config.leader = { key = "\\", mods = "ALT", timeout_milliseconds = 1000 }

local windowTitleCallback = function(win, pane)
  local overrides = win:get_config_overrides() or {}
  if overrides.window_decorations == 'RESIZE' then
    overrides.window_decorations = "TITLE | RESIZE"
  else
    overrides.window_decorations = "RESIZE"
  end
  -- will emit `window-config-reloaded` event
  win:set_config_overrides(overrides)
end


local keys = {
  ["<C-Tab>"] = act.ActivateTabRelative(1),
  ["<C-S-Tab>"] = act.ActivateTabRelative(-1),
  ["<M-CR>"] = act.ToggleFullScreen,
  ["<C-S-c>"] = act.CopyTo "Clipboard",
  ["<C-S-v>"] = act.PasteFrom "Clipboard",
  ["<C-S-f>"] = act.Search "CurrentSelectionOrEmptyString",
  ["<C-S-k>"] = act.ClearScrollback "ScrollbackOnly",
  ["<C-S-l>"] = act.ShowDebugOverlay,
  ["<C-S-n>"] = act.SpawnWindow,
  ["<C-S-p>"] = act.ActivateCommandPalette,
  ["<C-S-r>"] = act.ReloadConfiguration,
  ["<C-S-t>"] = act.SpawnTab "CurrentPaneDomain",
  ["<C-S-u>"] = act.CharSelect {
    copy_on_select = true,
    copy_to = "ClipboardAndPrimarySelection",
  },
  ["<C-S-w>"] = act.CloseCurrentTab { confirm = true },
  ["<C-S-z>"] = act.TogglePaneZoomState,
  ["<PageUp>"] = act.ScrollByPage(-1),
  ["<PageDown>"] = act.ScrollByPage(1),
  ["<C-S-Insert>"] = act.PasteFrom "PrimarySelection",
  ["<C-Insert>"] = act.CopyTo "PrimarySelection",
  ["<C-S-Space>"] = act.QuickSelect,

  ---quick split and nav
  ['<C-S-">'] = act.SplitHorizontal { domain = "CurrentPaneDomain" },
  ["<C-S-%>"] = act.SplitVertical { domain = "CurrentPaneDomain" },
  ["<C-M-h>"] = act.ActivatePaneDirection "Left",
  ["<C-M-j>"] = act.ActivatePaneDirection "Down",
  ["<C-M-k>"] = act.ActivatePaneDirection "Up",
  ["<C-M-l>"] = act.ActivatePaneDirection "Right",

  ---key tables
  ["<leader>w"] = act.ActivateKeyTable { name = "window_mode", one_shot = false },
  ["<leader>f"] = act.ActivateKeyTable { name = "font_mode", one_shot = false },
  ["<leader>c"] = act.ActivateCopyMode,
  ["<leader>s"] = act.Search "CurrentSelectionOrEmptyString",

  --turn on the header
  ["<leader>b"] = wezterm.action_callback(windowTitleCallback),
}

for i = 1, 10 do
  keys["<S-F" .. i .. ">"] = act.ActivateTab(i - 1)
end

Config.keys = {}
for lhs, rhs in pairs(keys) do
  fun.map(lhs, rhs, Config.keys)
end

return Config

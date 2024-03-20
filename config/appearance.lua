local wezterm = require('wezterm')
local tools = require('utils.fun')
local colors = require('colors')


-- local colors = require('colors.custom')


---@class Config
local Config = {}

local scheme = tools.get_scheme()
local theme = colors[scheme]

Config.color_schemes = colors
Config.color_scheme = scheme

Config.background = {
  {
    source = { File = wezterm.GLOBAL.background },
  },
  {
    source = { Color = theme.background },
    width = "100%",
    height = "100%",
    opacity = 0.96,
  },
}

Config.bold_brightens_ansi_colors = "BrightAndBold"

---char select and command palette
Config.char_select_bg_color = theme.brights[6]
Config.char_select_fg_color = theme.background
Config.char_select_font_size = 12

Config.command_palette_bg_color = theme.brights[6]
Config.command_palette_fg_color = theme.background
Config.command_palette_font_size = 14
Config.command_palette_rows = 20

-- scrollbar
Config.enable_scroll_bar = false

---cursor
Config.cursor_blink_ease_in = "EaseIn"
Config.cursor_blink_ease_out = "EaseOut"
Config.cursor_blink_rate = 500
Config.default_cursor_style = "BlinkingBar"
Config.cursor_thickness = 1
Config.force_reverse_video_cursor = true

Config.hide_mouse_cursor_when_typing = true

---text blink
Config.text_blink_ease_in = "EaseIn"
Config.text_blink_ease_out = "EaseOut"
Config.text_blink_rapid_ease_in = "Linear"
Config.text_blink_rapid_ease_out = "Linear"
Config.text_blink_rate = 500
Config.text_blink_rate_rapid = 250

---visual bell
Config.audible_bell = "SystemBeep"
Config.visual_bell = {
  fade_in_function = "EaseOut",
  fade_in_duration_ms = 200,
  fade_out_function = "EaseIn",
  fade_out_duration_ms = 200,
}

---window appearance
Config.window_padding = { left = 2, right = 2, top = 2, bottom = 1 }
Config.window_decorations = "RESIZE"
Config.integrated_title_button_alignment = "Right"
Config.integrated_title_button_style = "Windows"
Config.integrated_title_buttons = { "Hide", "Maximize", "Close" }
Config.win32_system_backdrop = "Acrylic"

Config.window_frame = {
  border_left_width = '0.3cell',
  border_right_width = '0.3cell',
  border_bottom_height = '0.125cell',
  border_top_height = '0.125cell',
  border_left_color = '#5002f7',
  border_right_color = '#5002f7',
  border_bottom_color = '#5002f7',
  border_top_color = '#5002f7',
}

Config.inactive_pane_hsb = {
  saturation = 0.9,
  brightness = 0.65,
}

---exit behavior
Config.clean_exit_codes = { 130 }
Config.exit_behavior = "CloseOnCleanExit"
Config.exit_behavior_messaging = "Verbose"
Config.skip_close_confirmation_for_processes_named = {
  "bash",
  "sh",
  "zsh",
  "fish",
  "tmux",
  "nu",
  "cmd.exe",
  "pwsh.exe",
  "powershell.exe",
}
Config.window_close_confirmation = "AlwaysPrompt"

---new tab button
Config.tab_bar_style = {}
for _, tab_button in ipairs { "new_tab", "new_tab_hover" } do
  Config.tab_bar_style[tab_button] = require("wezterm").format {
    { Text = require("utils.icons").Separators.TabBar.right },
    { Text = " + " },
    { Text = require("utils.icons").Separators.TabBar.left },
  }
end

return Config

local wezterm = require('wezterm')
local gpu_adapters = require('utils.gpu_adapter')
local colors = require('colors.custom')

return {
   animation_fps = 60,
   max_fps = 60,
   front_end = 'WebGpu',
   webgpu_power_preference = 'HighPerformance',
   webgpu_preferred_adapter = gpu_adapters:pick(),

   -- color scheme
   colors = colors,

   -- background
   background = {
      {
         source = { File = wezterm.GLOBAL.background },
      },
      {
         source = { Color = colors.background },
         height = '100%',
         width = '100%',
         opacity = 0.96,
      },
   },

   -- scrollbar
   enable_scroll_bar = false,

   -- cursor
   default_cursor_style = "BlinkingBar",
   cursor_blink_ease_in = "Constant",
   cursor_blink_ease_out = "Constant",
   launch_menu = {},

   -- tab bar
   enable_tab_bar = true,
   hide_tab_bar_if_only_one_tab = false,
   use_fancy_tab_bar = false,
   tab_max_width = 55,
   show_tab_index_in_tab_bar = false,
   switch_to_last_active_tab_when_closing_tab = true,
   tab_bar_at_bottom = true,

   -- window
   window_padding = {
      left = 3,
      right = 3,
      top = 3,
      bottom = 3,
   },
   window_close_confirmation = 'NeverPrompt',
   window_frame = {
      border_left_width = '0.3cell',
      border_right_width = '0.3cell',
      border_bottom_height = '0.125cell',
      border_top_height = '0.125cell',
      border_left_color = '#5002f7',
      border_right_color = '#5002f7',
      border_bottom_color = '#5002f7',
      border_top_color = '#5002f7',
   },
   inactive_pane_hsb = {
      saturation = 0.9,
      brightness = 0.65,
   },
   window_decorations = 'RESIZE',
   win32_system_backdrop = "Acrylic",
}

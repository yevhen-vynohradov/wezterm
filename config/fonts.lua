local wezterm = require('wezterm')
local platform = require('utils.platform')

local font = 'Comic Code Ligatures'
local font_size = platform().is_mac and 14 or 12

return {
   font = wezterm.font(font),
   font_size = font_size,
   line_height = 1.2,
   harfbuzz_features = { "zero", "cv05", "cv02", "ss05", "ss04" },
   --ref: https://wezfurlong.org/wezterm/config/lua/config/freetype_pcf_long_family_names.html#why-doesnt-wezterm-use-the-distro-freetype-or-match-its-configuration
   freetype_load_target = 'Normal', ---@type 'Normal'|'Light'|'Mono'|'HorizontalLcd'
   freetype_render_target = 'Normal', ---@type 'Normal'|'Light'|'Mono'|'HorizontalLcd'
}

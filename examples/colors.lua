local wezterm = require 'wezterm'

local module = {}

local color_default_fg_light = wezterm.color.parse("#cacaca") -- 💩
local color_default_fg_dark = wezterm.color.parse("#303030")

module.VERIDIAN = {
    bg = wezterm.color.parse("#4D8060"),
    fg = color_default_fg_light
  }
  module.PAYNE = {
    bg = wezterm.color.parse("#385F71"),
    fg = color_default_fg_light
  }
  module.INDIGO = {
    bg = wezterm.color.parse("#7C77B9"),
    fg = color_default_fg_light
  }
  module.CAROLINA = {
    bg = wezterm.color.parse("#8FBFE0"),
    fg = color_default_fg_dark
  }
  module.FLAME = {
    bg = wezterm.color.parse("#D36135"),
    fg = color_default_fg_dark
  }
  module.JET = {
    bg = wezterm.color.parse("#282B28"),
    fg = color_default_fg_light
  }
  module.TAUPE = {
    bg = wezterm.color.parse("#785964"),
    fg = color_default_fg_light
  }
  module.ECRU = {
    bg = wezterm.color.parse("#C6AE82"),
    fg = color_default_fg_dark
  }
  module.VIOLET = {
    bg = wezterm.color.parse("#685F74"),
    fg = color_default_fg_light
  }
  module.VERDIGRIS = {
    bg = wezterm.color.parse("#28AFB0"),
    fg = color_default_fg_light
  }


return module
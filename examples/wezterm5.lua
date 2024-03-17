local wezterm = require 'wezterm'
local c = wezterm.config_builder()
local color = (function()
  local COLOR = require('colors')

  local coolors = {
    COLOR.VERIDIAN,
    COLOR.PAYNE,
    COLOR.INDIGO,
    COLOR.CAROLINA,
    COLOR.FLAME,
    COLOR.JET,
    COLOR.TAUPE,
    COLOR.ECRU,
    COLOR.VIOLET,
    COLOR.VERDIGRIS
  }

  return coolors[math.random(#coolors)]
end)()

local color_primary = color

local title_color_bg = color_primary.bg
local title_color_fg = color_primary.fg

local color_off = title_color_bg:lighten(0.4)
local color_on = color_off:lighten(0.4)

-- wezterm.on('update-right-status', function(window)
--   local bat = 'W'
--   local b = wezterm.battery_info()[1]
--   bat = wezterm.format {
--     { Foreground = {
--       Color =
--           b.state_of_charge > 0.2 and color_on or color_off,
--     } },
--     { Text = '▉' },
--     { Foreground = {
--       Color =
--           b.state_of_charge > 0.4 and color_on or color_off,
--     } },
--     { Text = '▉' },
--     { Foreground = {
--       Color =
--           b.state_of_charge > 0.6 and color_on or color_off,
--     } },
--     { Text = '▉' },
--     { Foreground = {
--       Color =
--           b.state_of_charge > 0.8 and color_on or color_off,
--     } },
--     { Text = '▉' },
--     { Background = {
--       Color =
--           b.state_of_charge > 0.98 and color_on or color_off,
--     } },
--     { Foreground = {
--       Color =
--           b.state == "Charging"
--           and color_on:lighten(0.3):complement()
--           or
--           (b.state_of_charge < 0.2 and wezterm.GLOBAL.count % 2 == 0)
--           and color_on:lighten(0.1):complement()
--           or color_off:darken(0.1)
--     } },
--     { Text = ' ⚡ ' },
--   }

--   local time = wezterm.strftime '%-l:%M %P'

--   local bg1 = title_color_bg:lighten(0.1)
--   local bg2 = title_color_bg:lighten(0.2)

--   window:set_right_status(
--     -- wezterm.format({
--     --   { Background = { Color = title_color_bg } },
--     --   { Foreground = { Color = bg1 } },
--     --   { Text = 'TEST' },

--     --   { Background = { Color = title_color_bg:lighten(0.1) } },
--     --   { Foreground = { Color = title_color_fg } },
--     --   { Text = ' ' .. window:active_workspace() .. ' ' },

--     --   { Foreground = { Color = bg1 } },
--     --   { Background = { Color = bg2 } },
--     --   { Text = 'WRKSPC' },

--     --   { Background = { Color = title_color_bg:lighten(0.4) } },
--     --   { Foreground = { Color = title_color_fg } },
--     --   { Text = ' ' .. time .. ' ' .. bat }
--     -- })
--     wezterm.format({
--       { Background = { Color = title_color_bg } },
--       { Foreground = { Color = bg1 } },
--       { Text = 'TEST' },

--       { Background = { Color = title_color_bg:lighten(0.1) } },
--       { Foreground = { Color = title_color_fg } },
--       { Text = ' ' .. window:active_workspace() .. ' ' },

--       { Foreground = { Color = bg1 } },
--       { Background = { Color = bg2 } },
--       { Text = 'WRKSPC' },

--       { Background = { Color = title_color_bg:lighten(0.4) } },
--       { Foreground = { Color = title_color_fg } },
--       { Text = ' ' .. time .. ' ' .. bat }
--     })
--   )
-- end)

wezterm.on("update-right-status", function(window, pane)
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
	function get_right_cells()
		local cells = {}
		local cwd_uri = pane:get_current_working_dir()
		if cwd_uri then
			local cwd = ""
			local hostname = ""

			if type(cwd_uri) == "userdata" then
				-- Running on a newer version of wezterm and we have
				-- a URL object here, making this simple!

				cwd = cwd_uri.file_path
				hostname = cwd_uri.host or wezterm.hostname()
			else
				-- an older version of wezterm, 20230712-072601-f4abf8fd or earlier,
				-- which doesn't have the Url object
				cwd_uri = cwd_uri:sub(8)
				local slash = cwd_uri:find("/")
				if slash then
					hostname = cwd_uri:sub(1, slash - 1)
					-- and extract the cwd from the uri, decoding %-encoding
					cwd = cwd_uri:sub(slash):gsub("%%(%x%x)", function(hex)
						return string.char(tonumber(hex, 16))
					end)
				end
			end
			-- Remove the domain name portion of the hostname
			local dot = hostname:find("[.]")
			if dot then
				hostname = hostname:sub(1, dot - 1)
			end
			if hostname == "" then
				hostname = wezterm.hostname()
			end
			table.insert(cells, cwd)
			table.insert(cells, hostname)
		end

		-- I like my date/time in this style: "Wed Mar 3 08:14"
		local date = wezterm.strftime("%d-%m-%y %H:%M")
		table.insert(cells, date)

		-- An entry for each battery (typically 0 or 1 battery)
		for _, b in ipairs(wezterm.battery_info()) do
			table.insert(cells, string.format("%.0f%%", b.state_of_charge * 100))
		end

		-- The powerline < symbol
		local LEFT_ARROW = utf8.char(0xe0b3)

		-- The filled in variant of the < symbol
		local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider
		-- The elements to be formatted
		local elements = {}

		-- How many cells have been formatted
		local num_cells = 0

		-- Translate a cell into elements
		function push_right(text, is_first, is_last)
			local cell_no = num_cells + 1

			if is_first then
				table.insert(elements, { Foreground = { Color = colors[cell_no] } })
				table.insert(elements, { Text = SOLID_LEFT_ARROW })
			end

			table.insert(elements, { Foreground = { Color = text_fg } })
			table.insert(elements, { Background = { Color = colors[cell_no] } })
			table.insert(elements, { Text = " " .. text .. " " })
			if not is_last then
				table.insert(elements, { Foreground = { Color = colors[cell_no + 1] } })
				table.insert(elements, { Text = SOLID_LEFT_ARROW })
			end
			num_cells = num_cells + 1
		end

		while #cells > 0 do
			local cell = table.remove(cells, 1)
			push_right(cell, num_cells == 0, #cells == 0)
		end
		return elements
	end

	local right_cells = get_right_cells()
	window:set_right_status(wezterm.format(right_cells))
	
  function get_left_cells()
		local elements = {}
		local num_cells = 0
		local cell_no = num_cells + 1
		-- The filled in variant of the > symbol
		local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider
		local active_workspace = window:active_workspace()
		table.insert(elements, { Foreground = { Color = text_fg } })
		table.insert(elements, { Background = { Color = colors[cell_no] } })
		table.insert(elements, { Text = "  " .. active_workspace .. "  " })
		table.insert(elements, { Background = { Color = "#1a1b26" } })
		table.insert(elements, { Foreground = { Color = colors[cell_no + 0] } })
		table.insert(elements, { Text = SOLID_RIGHT_ARROW })
		table.insert(elements, { Background = { Color = "#1a1b26" } })
		table.insert(elements, { Foreground = { Color = colors[cell_no + 0] } })
		table.insert(elements, { Text = "     " })
		return elements
	end
	local left_cells = get_left_cells()
	window:set_left_status(wezterm.format(left_cells))
end)

wezterm.on('gui-startup', function(cmd)
  local mux = wezterm.mux

  local padSize = 80
  local screenWidth = 3440
  local screenHeight = 1440

  local tab, pane, window = mux.spawn_window(cmd or {
    workspace = 'main',
  })

  local icons = {
    '🌞',
    '🍧',
    '🫠',
    '🏞️',
    '📑',
    '🪁',
    '🧠',
    '🦥',
    '🦉',
    '📀',
    '🌮',
    '🍜',
    '🧋',
    '🥝',
    '🍊',
  }

  tab:set_title(' TAB:' .. icons[math.random(#icons)] .. ' T ')

  if window ~= nil then
    window:gui_window():set_position(padSize, padSize)
    window:gui_window():set_inner_size(screenWidth - (padSize * 2), screenHeight - (padSize * 2) - 48)
  end
end)

local TAB_EDGE_LEFT = wezterm.nerdfonts.ple_left_half_circle_thick
local TAB_EDGE_RIGHT = wezterm.nerdfonts.ple_right_half_circle_thick

local function tab_title(tab_info)
  local title = tab_info.tab_title

  if title and #title > 0 then return title end

  return tab_info.active_pane.title:gsub("%.exe", "")
end

wezterm.on(
  'format-tab-title',
  function(tab, _, _, _, hover, max_width)
    local edge_background = title_color_bg
    local background = title_color_bg:lighten(0.05)
    local foreground = title_color_fg

    if tab.is_active then
      background = background:lighten(0.1)
      foreground = foreground:lighten(0.1)
    elseif hover then
      background = background:lighten(0.2)
      foreground = foreground:lighten(0.2)
    end

    local edge_foreground = background

    local title = tab_title(tab)

    -- ensure that the titles fit in the available space,
    -- and that we have room for the edges.
    title = wezterm.truncate_right(title, max_width - 2)

    return {
      { Background = { Color = edge_background } },
      { Foreground = { Color = edge_foreground } },
      { Text = TAB_EDGE_LEFT },
      { Background = { Color = background } },
      { Foreground = { Color = foreground } },
      { Text = title },
      { Background = { Color = edge_background } },
      { Foreground = { Color = edge_foreground } },
      { Text = TAB_EDGE_RIGHT },
    }
  end
)


c.colors = {
  tab_bar = {
    active_tab = {
      bg_color = title_color_bg:lighten(0.03),
      fg_color = title_color_fg:lighten(0.8),
      intensity = "Bold",
    },
    inactive_tab = {
      bg_color = title_color_bg:lighten(0.01),
      fg_color = title_color_fg,
      intensity = "Half",
    },
    inactive_tab_edge = title_color_bg
  },
  split = title_color_bg:lighten(0.3):desaturate(0.5)
}
c.window_background_opacity = 0.6
c.window_frame = {
  active_titlebar_bg = title_color_bg,
  inactive_titlebar_bg = title_color_bg,
  font_size = 10.0,
}

c.window_decorations = 'RESIZE'
c.win32_system_backdrop = "Acrylic"
c.show_tab_index_in_tab_bar = false
c.show_new_tab_button_in_tab_bar = false
c.keys = {
  {
    key = 'Enter',
    mods = 'ALT|SHIFT',
    ---@diagnostic disable-next-line: unused-local
    action = wezterm.action_callback(function(win, pane)
      local overrides = win:get_config_overrides() or {}
      if overrides.window_decorations == 'RESIZE' then
        overrides.window_decorations = "TITLE | RESIZE"
      else
        overrides.window_decorations = "RESIZE"
      end
      -- will emit `window-config-reloaded` event
      win:set_config_overrides(overrides)
    end),
  },
}


return c

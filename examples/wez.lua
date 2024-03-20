-- Pull in the wezterm API
local wezterm = require("wezterm")
local mux = wezterm.mux
local act = wezterm.action
-- This table will hold the configuration.
local config = {}
-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
	--  ╭──────────────────────────────────────────────────────────╮
	--  │ If Win11 show wsl2 shell                                 │
	--  ╰──────────────────────────────────────────────────────────╯
	if wezterm.target_triple == "x86_64-pc-windows-msvc" then
		-- We are running on Windows;
		local wsl_domains = wezterm.default_wsl_domains()

		for idx, dom in ipairs(wsl_domains) do
			if dom.name == "WSL:Ubuntu" then
				dom.default_prog = { "zsh", "-l" }
			end
		end
		config.wsl_domains = wsl_domains
		config.default_domain = "WSL:Ubuntu"
	end
end
--  ╭──────────────────────────────────────────────────────────╮
--  │ Keymappings                                              │
--  ╰──────────────────────────────────────────────────────────╯
config.keys = {
	-- Window management
	{ mods = "CMD", key = ".", action = act.MoveTabRelative(1) },
	{ mods = "CMD", key = ",", action = act.MoveTabRelative(-1) },
	{ mods = "CMD|SHIFT", key = "1", action = act.ActivateTab(0) },
	{ mods = "CMD|SHIFT", key = "2", action = act.ActivateTab(1) },
	{ mods = "CMD|SHIFT", key = "3", action = act.ActivateTab(2) },
	{ mods = "CMD|SHIFT", key = "4", action = act.ActivateTab(3) },
	{ mods = "CMD|SHIFT", key = "5", action = act.ActivateTab(4) },
	{ mods = "CMD|SHIFT", key = "6", action = act.ActivateTab(5) },
	{ mods = "CMD|SHIFT", key = "7", action = act.ActivateTab(6) },
	{ mods = "CMD|SHIFT", key = "8", action = act.ActivateTab(7) },
	{ mods = "CMD|SHIFT", key = "9", action = act.ActivateTab(8) },
	{ mods = "CMD|SHIFT", key = "0", action = act.ActivateTab(9) },
	-- Tab management
	{ mods = "CMD", key = "j", action = act.ActivateTabRelative(-1) },
	{ mods = "CMD", key = "k", action = act.ActivateTabRelative(1) },
	-- Panes
	{ mods = "CMD|SHIFT", key = "h", action = act.SplitHorizontal({ args = {} }) },
	{ mods = "CMD|SHIFT", key = "v", action = act.SplitVertical({ args = {} }) },
	{ mods = "CMD", key = "a", action = act.ActivatePaneDirection("Left") },
	{ mods = "CMD", key = "d", action = act.ActivatePaneDirection("Right") },
	{ mods = "CMD|SHIFT", key = "k", action = act.ActivatePaneDirection("Up") },
	{ mods = "CMD|SHIFT", key = "j", action = act.ActivatePaneDirection("Down") },
	{ mods = "CMD", key = "e", action = act.CloseCurrentPane({ confirm = true }) },
	{ mods = "CMD", key = "r", action = act.RotatePanes("Clockwise") },
	-- Copy Mode
	{ mods = "CMD", key = "x", action = act.ActivateCopyMode },
	-- Toggle Zoom Mode (Full Screen)
	{ mods = "CMD", key = "f", action = act.TogglePaneZoomState },
	-- Launcher
	{
		mods = "CMD",
		key = "Backspace",
		action = act.ShowLauncherArgs({
			flags = "FUZZY|WORKSPACES|LAUNCH_MENU_ITEMS",
		}),
	},
	-- Rename tab
	{
		mods = "CMD|SHIFT",
		key = "T",
		action = act.PromptInputLine({
			description = "Enter new name for tab",
			action = wezterm.action_callback(function(window, _pane, line)
				-- line will be `nil` if they hit escape without entering anything
				-- An empty string if they just hit enter
				-- Or the actual line of text they wrote
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
	-- Rename workspace
	{
		mods = "CMD|SHIFT",
		key = "W",
		action = act.PromptInputLine({
			description = "Enter new name for workspace",
			action = wezterm.action_callback(function(window, pane, line)
				-- line will be `nil` if they hit escape without entering anything
				-- An empty string if they just hit enter
				-- Or the actual line of text they wrote
				if line then
					wezterm.mux.rename_workspace(wezterm.mux.get_active_workspace(), line)
				end
			end),
		}),
	},
}

--  ╭──────────────────────────────────────────────────────────╮
--  │ Config options                                           │
--  ╰──────────────────────────────────────────────────────────╯
config.enable_kitty_keyboard = true
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}
config.color_scheme = "Cobalt2"
config.font = wezterm.font_with_fallback({
	"Comic Code Ligatures",
	{ family = "Symbols Nerd Font Mono", scale = 0.8 },
})
config.harfbuzz_features = { "zero", "cv05", "cv02", "ss05", "ss04" }
config.font_size = 16.0
config.window_background_opacity = 0.90
config.text_background_opacity = 1
config.inactive_pane_hsb = {
	saturation = 0.3,
	brightness = 0.3,
}
config.line_height = 1.3
-- cursor
config.default_cursor_style = "BlinkingBar"
config.animation_fps = 1
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"
config.launch_menu = {}
-- window
-- config.window_decorations = "INTEGRATED_BUTTONS"
config.enable_scroll_bar = false
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = false
config.show_tabs_in_tab_bar = true
config.show_new_tab_button_in_tab_bar = false
config.window_frame = {
	font = wezterm.font({ family = "Roboto", weight = "Bold" }),
	font_size = 12.0,
	active_titlebar_bg = "#3c1361",
	inactive_titlebar_bg = "#3c1361",
}
config.tab_bar_at_bottom = true
config.tab_max_width = 32
config.colors = {
	tab_bar = {
		background = "#1a1b26",
		active_tab = {
			bg_color = "#755E87",
			fg_color = "#c0caf5",
			intensity = "Normal",
			underline = "None",
			italic = false,
			strikethrough = false,
		},
		inactive_tab = {
			bg_color = "#1a1b26",
			fg_color = "#6b7089",
			intensity = "Normal",
			underline = "None",
			italic = false,
			strikethrough = false,
		},
		inactive_tab_hover = {
			bg_color = "#1f2335",
			fg_color = "#6b7089",
			intensity = "Normal",
			underline = "None",
			italic = false,
			strikethrough = false,
		},
		new_tab = {
			bg_color = "#1a1b26",
			fg_color = "#6b7089",
			intensity = "Normal",
			underline = "None",
			italic = false,
			strikethrough = false,
		},
		new_tab_hover = {
			bg_color = "#1f2335",
			fg_color = "#6b7089",
			intensity = "Normal",
			underline = "None",
			italic = false,
			strikethrough = false,
		},
	},
}
--  ╭──────────────────────────────────────────────────────────╮
--  │ Multiplexer                                              │
--  ╰──────────────────────────────────────────────────────────╯
wezterm.on("gui-startup", function(cmd)
	-- allow `wezterm start -- something` to affect what we spawn
	-- in our initial window
	local args = {}
	if cmd then
		args = cmd.args
	end
	local project_dir = wezterm.home_dir .. "/Projects/blanket"
	--  ╭──────────────────────────────────────────────────────────╮
	--  │ Spawns default session                                   │
	--  ╰──────────────────────────────────────────────────────────╯
	local default_tab, default_pane, default_window = mux.spawn_window({
		workspace = "default",
	})
	--  ╭──────────────────────────────────────────────────────────╮
	--  │ Spawns "Blanket"                                         │
	--  ╰──────────────────────────────────────────────────────────╯
	-- right split
	local blanket_tab, blanket_pane, blanket_window = mux.spawn_window({
		workspace = "blanket",
		cwd = project_dir,
		args = args,
	})
	-- mux.rename_workspace(wezterm.mux.get_active_workspace(), "nvim")
	blanket_pane:send_text("fnm use && npm start -- --reset-cache\n")
	-- left split
	local top_split = blanket_pane:split({
		direction = "Left",
		size = 0.95,
		cwd = project_dir,
	})
	top_split:send_text("nvim\n")
	--  ╭──────────────────────────────────────────────────────────╮
	--  │   second tab                                             │
	--  ╰──────────────────────────────────────────────────────────╯
	-- left split
	local nvim_tab, nvim_pane = blanket_window:spawn_tab({})
	nvim_pane:send_text("wezterm cli send-text 'npm run ios && clear' && clear\n")
	
	-- right split
	local right_split = nvim_pane:split({
		direction = "Right",
		size = 0.5,
		cwd = project_dir,
	})
	right_split:send_text("wezterm cli send-text 'npm run android && exit' && clear\n")
	nvim_pane:activate()
	-- I want to startup in the default workspace
	mux.set_active_workspace("default")
end)
--  ╭──────────────────────────────────────────────────────────╮
--  │ Neovim Zen Mode Integration                              │
--  ╰──────────────────────────────────────────────────────────╯
wezterm.on("user-var-changed", function(window, pane, name, value)
	local overrides = window:get_config_overrides() or {}
	if name == "ZEN_MODE" then
		local incremental = value:find("+")
		local number_value = tonumber(value)
		if incremental ~= nil then
			while number_value > 0 do
				window:perform_action(wezterm.action.IncreaseFontSize, pane)
				number_value = number_value - 1
			end
			overrides.enable_tab_bar = false
		elseif number_value < 0 then
			window:perform_action(wezterm.action.ResetFontSize, pane)
			overrides.font_size = nil
			overrides.enable_tab_bar = true
		else
			overrides.font_size = number_value
			overrides.enable_tab_bar = false
		end
	end
	window:set_config_overrides(overrides)
end)
--  ╭──────────────────────────────────────────────────────────╮
--  │ Tabbar                                                   │
--  ╰──────────────────────────────────────────────────────────╯
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
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	-- The filled in variant of the < symbol
	-- local SOLID_LEFT_ARROW = "" -- wezterm.nerdfonts.pl_right_hard_divider
	local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_left_half_circle_thick
	-- The filled in variant of the > symbol
	local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_right_half_circle_thick
	-- This function returns the suggested title for a tab.
	-- It prefers the title that was set via `tab:set_title()`
	-- or `wezterm cli set-tab-title`, but falls back to the
	-- title of the active pane in that tab.
	function tab_title(tab_info)
		local title = tab_info.tab_title
		local index = tab_info.tab_index
		-- if the tab title is explicitly set, take that
		if title and #title > 0 then
			return index + 1 .. ":" .. title
		end
		-- Otherwise, use the title from the active pane
		-- in that tab
		return index + 1 .. ":" .. tab_info.active_pane.title
	end
	local edge_background = "#1a1b26"
	local background = "#1b1032"
	local foreground = "#808080"
	if tab.is_active then
		background = "#b491c8"
		foreground = "#202020"
	elseif hover then
		background = "#3b3052"
		foreground = "#909090"
	end
	local edge_foreground = background
	local title = tab_title(tab)
	-- ensure that the titles fit in the available space,
	-- and that we have room for the edges.
	title = wezterm.truncate_right(title, max_width - 2)
	return {
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_LEFT_ARROW },
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = title },
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_RIGHT_ARROW },
	}
end)
-- and finally, return the configuration to wezterm
-- it has to be at the end of file
return config

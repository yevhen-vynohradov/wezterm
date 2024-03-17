-- Dump any object to string
local function dump(o)
    if type(o) == 'table' then
      local s = '{ '
      for k, v in pairs(o) do
        if type(k) ~= 'number' then
          k = '"' .. k .. '"'
        end
        s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
      end
      return s .. '} '
    else
      return tostring(o)
    end
  end
  
  -- table union: a += b
  local function table_union(a, b)
    if type(a) ~= 'table' or type(b) ~= 'table' then
      error("Illegal argument: a or b are not a 'table' type")
    end
    for k, v in pairs(b) do
      if a[k] ~= nil then
        error(string.format("Duplicate keys detected:\nkey=%q, exist value=%q", dump(k), dump(a[k])))
        return
      end
      a[k] = v
    end
  end
  
  -- Define Config class
  Config = { inner = {} }
  
  function Config:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    self.inner = {}
    return o
  end
  
  function Config:add(t)
    table_union(self.inner, t)
    return self
  end
  
  ------------------------------------------------------
  --               Wezterm configuration
  ------------------------------------------------------
  
  local wzt = require('wezterm')
  local act = wzt.action
  local gui = wzt.gui
  
  wzt.on('gui-startup', function(cmd)
    local tab, pane, window = wzt.mux.spawn_window(cmd or {})
    window:gui_window():set_inner_size(1300, 800)
    window:gui_window():set_position(400, 100)
    -- pane:split { size = 0.5 }  -- split 2 pane
  end)
  
  local tab_title = function(tab_info)
    local title = tab_info.tab_title
    if title and #title > 0 then
      return title
    end
    return tab_info.active_pane.title
  end
  
  wzt.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
    -- Not sure if it will slow down the performance, at least so far it's good
    -- Is there a better way to get the tab or window cols ?
    local mux_window = wzt.mux.get_window(tab.window_id)
    local mux_tab = mux_window:active_tab()
    local mux_tab_cols = mux_tab:get_size().cols
  
    -- Calculate active/inactive tab cols
    -- In general, active tab cols > inactive tab cols
    local tab_count = #tabs
    local inactive_tab_cols = math.floor(mux_tab_cols / tab_count)
    local active_tab_cols = mux_tab_cols - (tab_count - 1) * inactive_tab_cols
  
    local title = tab_title(tab)
    title = ' ' .. title .. ' '
    local title_cols = wzt.column_width(title)
  
    -- Divide into 3 areas and center the title
    if tab.is_active then
      local icon = ' ' .. '⦿'
  
      local rest_cols = math.max(active_tab_cols - title_cols, 0)
      local right_cols = math.ceil(rest_cols / 2)
      local left_cols = rest_cols - right_cols
      return {
        -- left
        { Foreground = { Color = 'Fuchsia' } },
        { Text = wzt.pad_right(icon, left_cols) },
        -- center
        { Foreground = { Color = '#46BDFF' } },
        { Attribute = { Italic = true } },
        { Text = title },
        -- right
        { Text = wzt.pad_right('', right_cols) },
      }
    else
      local icon = ' '
  
      local rest_cols = math.max(inactive_tab_cols - title_cols, 0)
      local right_cols = math.ceil(rest_cols / 2)
      local left_cols = rest_cols - right_cols
      return {
        -- left
        { Text = wzt.pad_right(icon, left_cols) },
        -- center
        { Text = title },
        -- right
        { Text = wzt.pad_right('', right_cols) },
      }
    end
  end)
  
  --------------------------------------- 启动项
  local launch_menu = {
    default_prog = { 'pwsh' },
    launch_menu = {
      { label = '🟢 NuShell',            args = { 'nu' } },
      { label = '🟣 PowerShell Core',    args = { 'pwsh' } },
      { label = '🔵 Windows PowerShell', args = { 'powershell' } },
    },
  }
  
  --------------------------------------- 外观
  -- local gpu_prefer = nil
  -- for _, gpu in ipairs(gui.enumerate_gpus()) do
  --   if gpu.backend == 'Vulkan' and gpu.device_type == 'DiscreteGpu' then
  --     gpu_prefer = gpu
  --     break
  --   end
  -- end
  
  local appearance = {
    front_end = 'WebGpu',
    -- webgpu_preferred_adapter = gpu_prefer,
    animation_fps = 240,
    max_fps = 240,
  
    color_scheme_dirs = { './colors' },
    color_scheme = "retrowave",
  
    font = wzt.font { family = 'Comic Code Ligatures' },
    font_size = 12.0,
  
    -- default_cursor_style = 'BlinkingBar',
    -- cursor_blink_rate = 333,
  
    window_frame = {
      border_left_width = '0.25cell',
      border_right_width = '0.25cell',
      border_bottom_height = '0.125cell',
      border_top_height = '0.125cell',
      border_left_color = '#0063B1',
      border_right_color = '#0063B1',
      border_bottom_color = '#0063B1',
      border_top_color = '#0063B1',
    },
    window_decorations = 'RESIZE',
    text_background_opacity = 0.3,
    window_background_opacity = 0.618,
    win32_system_backdrop = 'Acrylic',
    -- window_background_opacity = 1,
    -- win32_system_backdrop = 'Tabbed',
    inactive_pane_hsb = { saturation = 1.0, brightness = 0.5 },
    window_padding = { left = 0, right = 0, top = 0, bottom = 0 },

    use_fancy_tab_bar = false,
    show_new_tab_button_in_tab_bar = false,
    tab_bar_at_bottom = true,
    enable_scroll_bar = false,
    hide_tab_bar_if_only_one_tab = false,
    tab_max_width = 9999,
  
    colors = {
      tab_bar = {
        background = '#070825',
        --   active_tab = {
        --     bg_color = '#2b2042',
        --     fg_color = '#FFFFFF',
        --     -- Specify whether you want "Half", "Normal" or "Bold" intensity for the
        --     intensity = 'Normal',
        --     -- Specify whether you want "None", "Single" or "Double" underline for
        --     underline = 'None',
        --     -- Specify whether you want the text to be italic (true) or not (false)
        --     italic = true,
        --     -- Specify whether you want the text to be rendered with strikethrough (true)
        --     strikethrough = false,
        --   },
        -- inactive_tab = {
        -- },
        -- inactive_tab_hover = {
        -- },
      },
    },
  }
  
  --------------------------------------- 快捷键
  -- copy_mode
  local copy_mode = gui.default_key_tables().copy_mode
  table.insert(copy_mode,
    { key = 'h', mods = 'SHIFT', action = act.CopyMode 'MoveToStartOfLineContent' }
  )
  table.insert(copy_mode,
    { key = 'l', mods = 'SHIFT', action = act.CopyMode 'MoveToEndOfLineContent' }
  )
  table.insert(copy_mode,
    {
      key = 'y',
      mods = 'NONE',
      action = act.Multiple { act.CopyTo 'PrimarySelection', act.ClearSelection, act.CopyMode 'ClearSelectionMode' },
    }
  )
  -- search_mode
  local search_mode = gui.default_key_tables().search_mode
  table.insert(search_mode, { key = 'c', mods = 'CTRL', action = act.CopyMode 'Close' })
  
  -- copy_mode <=> search_mode
  table.insert(copy_mode,
    { key = 'i', mods = 'NONE', action = act.Search { CaseInSensitiveString = '' }, }
  )
  table.insert(search_mode, { key = 'Enter', mods = 'SHIFT', action = act.ActivateCopyMode })
  
  local key_binding = {
    key_tables = {
      copy_mode = copy_mode,
      search_mode = search_mode,
    },
    keys = {
      { key = '0',   mods = 'CTRL',         action = act.ActivateCommandPalette },
      -- show debug overlay
      { key = 'F12', mods = 'NONE',         action = act.ShowDebugOverlay },
      { key = 'L',   mods = 'CTRL',         action = act.DisableDefaultAssignment },
      -- close tab
      { key = 'w',   mods = 'CTRL | SHIFT', action = act.CloseCurrentPane { confirm = false } },
      -- toggle window decorations
      {
        key = 'Enter',
        mods = 'ALT|SHIFT',
        ---@diagnostic disable-next-line: unused-local
        action = wzt.action_callback(function(win, pane)
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
      -- Pane zoom
      { key = ';',          mods = 'CTRL',       action = act.TogglePaneZoomState },
      -- Pane split
      { key = '=',          mods = 'ALT',        action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
      { key = '-',          mods = 'ALT',        action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
      -- Pane activate
      { key = 'LeftArrow',  mods = 'ALT',        action = act.ActivatePaneDirection 'Left' },
      { key = 'RightArrow', mods = 'ALT',        action = act.ActivatePaneDirection 'Right' },
      { key = 'UpArrow',    mods = 'ALT',        action = act.ActivatePaneDirection 'Up' },
      { key = 'DownArrow',  mods = 'ALT',        action = act.ActivatePaneDirection 'Down' },
      -- Pane resize
      { key = 'LeftArrow',  mods = 'ALT|SHIFT',  action = act.AdjustPaneSize { 'Left', 1 } },
      { key = 'RightArrow', mods = 'ALT|SHIFT',  action = act.AdjustPaneSize { 'Right', 1 } },
      { key = 'UpArrow',    mods = 'ALT|SHIFT',  action = act.AdjustPaneSize { 'Up', 1 } },
      { key = 'DownArrow',  mods = 'ALT|SHIFT',  action = act.AdjustPaneSize { 'Down', 1 } },
      -- Scroll
      { key = 'Home',       mods = 'SHIFT|CTRL', action = act.ScrollToTop },
      { key = 'End',        mods = 'SHIFT|CTRL', action = act.ScrollToBottom },
      { key = 'PageUp',     mods = 'SHIFT|CTRL', action = act.ScrollByPage(-1) },
      { key = 'PageDown',   mods = 'SHIFT|CTRL', action = act.ScrollByPage(1) },
      { key = 'UpArrow',    mods = 'SHIFT|CTRL', action = act.ScrollByLine(-1) },
      { key = 'DownArrow',  mods = 'SHIFT|CTRL', action = act.ScrollByLine(1) },
      { key = 'LeftArrow',  mods = 'SHIFT|CTRL', action = act.ScrollToPrompt(-1) },
      { key = 'RightArrow', mods = 'SHIFT|CTRL', action = act.ScrollToPrompt(1) },
      -- QuickSelect
      { key = 'f',          mods = 'SHIFT|CTRL', action = act.QuickSelect },
      -- Show
      { key = '7',          mods = 'CTRL',       action = act.ShowLauncherArgs { title = '🔭 Tabs', flags = 'FUZZY|TABS' } },
      {
        key = '8',
        mods = 'CTRL',
        action = act.ShowLauncherArgs { title = '🔭 快捷键/命令', flags = 'FUZZY|KEY_ASSIGNMENTS|COMMANDS' }
      },
      {
        key = '9',
        mods = 'CTRL',
        action = act.ShowLauncherArgs { title = '🔭 启动项/域/工作区', flags =
        'LAUNCH_MENU_ITEMS|DOMAINS|WORKSPACES' }
      },
    }
  }
  
  return Config:new()
      :add(launch_menu)
      :add(appearance)
      :add(key_binding)
      .inner
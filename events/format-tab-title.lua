local wezterm = require("wezterm") ---@class WezTerm
local fun = require("utils.fun") ---@class Fun
local icons = require("utils.icons") ---@class Icons
local tabicons = icons.Separators.TabBar ---@class TabBarIcons

-- Inspired by https://github.com/wez/wezterm/discussions/628#discussioncomment-1874614

local GLYPH_SEMI_CIRCLE_LEFT = ' '
-- local GLYPH_SEMI_CIRCLE_LEFT = utf8.char(0xe0b6)
local GLYPH_SEMI_CIRCLE_RIGHT = ' '
-- local GLYPH_SEMI_CIRCLE_RIGHT = utf8.char(0xe0b4)
local GLYPH_CIRCLE = ''
-- local GLYPH_CIRCLE = utf8.char(0xf111)
local GLYPH_ADMIN = '󰞀'
-- local GLYPH_ADMIN = utf8.char(0xf0780)

local M = {}

local __cells__ = {}

local colors = {
  default = {
    bg = '#45475a',
    fg = '#1c1b19',
  },
  is_active = {
    bg = '#7FB4CA',
    fg = '#11111b',
  },

  hover = {
    bg = '#587d8c',
    fg = '#1c1b19',
  },
}

local _set_process_name = function(s)
  local a = string.gsub(s, '(.*[/\\])(.*)', '%2')
  return a:gsub('%.exe$', '')
end

local _set_title = function(process_name, base_title, max_width, inset)
  local title
  inset = inset or 6

  if process_name:len() > 0 then
    title = process_name .. ' ~ ' .. base_title
  else
    title = base_title
  end

  if title:len() > max_width - inset then
    local diff = title:len() - max_width + inset
    title = wezterm.truncate_right(title, title:len() - diff)
  end

  return title
end

local _check_if_admin = function(p)
  if p:match('^Administrator: ') then
    return true
  end
  return false
end

---@param fg string
---@param bg string
---@param attribute table
---@param text string
local _push = function(bg, fg, attribute, text)
  table.insert(__cells__, { Background = { Color = bg } })
  table.insert(__cells__, { Foreground = { Color = fg } })
  table.insert(__cells__, { Attribute = attribute })
  table.insert(__cells__, { Text = text })
end


local function basename(s)
  return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

local SOLID_LEFT_ARROW = utf8.char(0xe0ba)
local SOLID_LEFT_MOST = utf8.char(0x2588)
local SOLID_RIGHT_ARROW = utf8.char(0xe0bc)

local ADMIN_ICON = utf8.char(0xf49c)

local CMD_ICON = utf8.char(0xe62a)
local NU_ICON = utf8.char(0xe7a8)
local PS_ICON = utf8.char(0xe70f)
local ELV_ICON = utf8.char(0xfc6f)
local WSL_ICON = utf8.char(0xf033d)
local YORI_ICON = utf8.char(0xf1d4)
local NYA_ICON = utf8.char(0xf61a)

local VIM_ICON = utf8.char(0xe62b)
local PAGER_ICON = utf8.char(0xf718)
local FUZZY_ICON = utf8.char(0xf0b0)
local HOURGLASS_ICON = utf8.char(0xf252)
local SUNGLASS_ICON = utf8.char(0xf9df)

local PYTHON_ICON = utf8.char(0xf820)
local NODE_ICON = utf8.char(0xf0399)
local DENO_ICON = utf8.char(0xe628)
local LAMBDA_ICON = utf8.char(0xfb26)

local SUP_IDX = { "¹", "²", "³", "⁴", "⁵", "⁶", "⁷", "⁸", "⁹", "¹⁰",
  "¹¹", "¹²", "¹³", "¹⁴", "¹⁵", "¹⁶", "¹⁷", "¹⁸", "¹⁹", "²⁰" }
local SUB_IDX = { "₁", "₂", "₃", "₄", "₅", "₆", "₇", "₈", "₉", "₁₀",
  "₁₁", "₁₂", "₁₃", "₁₄", "₁₅", "₁₆", "₁₇", "₁₈", "₁₉", "₂₀" }

M.setup = function()
  
  --  wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  --     local edge_background = "#121212"
  --     local background = "#4E4E4E"
  --     local foreground = "#1C1B19"
  --     local dim_foreground = "#3A3A3A"

  --     if tab.is_active then
  --       background = "#FBB829"
  --       foreground = "#1C1B19"
  --     elseif hover then
  --       background = "#FF8700"
  --       foreground = "#1C1B19"
  --     end

  --     local edge_foreground = background
  --     local process_name = tab.active_pane.foreground_process_name
  --     local pane_title = tab.active_pane.title
  --     local exec_name = basename(process_name):gsub("%.exe$", "")
  --     local title_with_icon

  --     if exec_name == "nu" then
  --       title_with_icon = NU_ICON .. " NuShell"
  --     elseif exec_name == "pwsh" then
  --       title_with_icon = PS_ICON .. " PS"
  --     elseif exec_name == "cmd" then
  --       title_with_icon = CMD_ICON .. " CMD"
  --     elseif exec_name == "elvish" then
  --       title_with_icon = ELV_ICON .. " Elvish"
  --     elseif exec_name == "wsl" or exec_name == "wslhost" then
  --       title_with_icon = WSL_ICON .. " WSL"
  --     elseif exec_name == "nyagos" then
  --       title_with_icon = NYA_ICON .. " " .. pane_title:gsub(".*: (.+) %- .+", "%1")
  --     elseif exec_name == "yori" then
  --       title_with_icon = YORI_ICON .. " " .. pane_title:gsub(" %- Yori", "")
  --     elseif exec_name == "nvim" then
  --       title_with_icon = VIM_ICON .. pane_title:gsub("^(%S+)%s+(%d+/%d+) %- nvim", " %2 %1")
  --     elseif exec_name == "bat" or exec_name == "less" or exec_name == "moar" then
  --       title_with_icon = PAGER_ICON .. " " .. exec_name:upper()
  --     elseif exec_name == "fzf" or exec_name == "hs" or exec_name == "peco" then
  --       title_with_icon = FUZZY_ICON .. " " .. exec_name:upper()
  --     elseif exec_name == "btm" or exec_name == "ntop" then
  --       title_with_icon = SUNGLASS_ICON .. " " .. exec_name:upper()
  --     elseif exec_name == "python" or exec_name == "hiss" then
  --       title_with_icon = PYTHON_ICON .. " " .. exec_name
  --     elseif exec_name == "node" then
  --       title_with_icon = NODE_ICON .. " " .. exec_name:upper()
  --     elseif exec_name == "deno" then
  --       title_with_icon = DENO_ICON .. " " .. exec_name:upper()
  --     elseif exec_name == "bb" or exec_name == "cmd-clj" or exec_name == "janet" or exec_name == "hy" then
  --       title_with_icon = LAMBDA_ICON .. " " .. exec_name:gsub("bb", "Babashka"):gsub("cmd%-clj", "Clojure")
  --     else
  --       title_with_icon = HOURGLASS_ICON .. " " .. exec_name
  --     end
  --     if pane_title:match("^Administrator: ") then
  --       title_with_icon = title_with_icon .. " " .. ADMIN_ICON
  --     end
  --     local left_arrow = SOLID_LEFT_ARROW
  --     if tab.tab_index == 0 then
  --       left_arrow = SOLID_LEFT_MOST
  --     end
  --     local id = SUB_IDX[tab.tab_index+1]
  --     local pid = SUP_IDX[tab.active_pane.pane_index+1]
  --     local title = " " .. wezterm.truncate_right(title_with_icon, max_width-6) .. " "

  --     return {
  --       {Attribute={Intensity="Bold"}},
  --       {Background={Color=edge_background}},
  --       {Foreground={Color=edge_foreground}},
  --       {Text=left_arrow},
  --       {Background={Color=background}},
  --       {Foreground={Color=foreground}},
  --       {Text=id},
  --       {Text=title},
  --       {Foreground={Color=dim_foreground}},
  --       {Text=pid},
  --       {Background={Color=edge_background}},
  --       {Foreground={Color=edge_foreground}},
  --       {Text=SOLID_RIGHT_ARROW},
  --       {Attribute={Intensity="Normal"}},
  --     }
  --   end)

  wezterm.on("format-tab-title", function(tab, _, _, config, hover, max_width)
    if config.use_fancy_tab_bar or not config.enable_tab_bar then
      return
    end

    local theme = require("colors")[fun.get_scheme()]
    local bg = theme.tab_bar.background
    local fg

    local TabTitle = require("utils.layout"):new() ---@class Layout

    local pane, tab_idx = tab.active_pane, tab.tab_index
    local attributes = {}

    ---set colors based on states
    if tab.is_active then
      fg = theme.ansi[5]
      attributes = { "Bold" }
    elseif hover then
      fg = theme.selection_bg
    else
      fg = theme.brights[1]
    end

    ---Check if any pane has unseen output
    local unseen_output = false
    for _, p in ipairs(tab.panes) do
      if p.has_unseen_output then
        unseen_output = true
        break
      end
    end

    ---get pane title, remove any `.exe` from the title, swap `Administrator` for the desired
    ---icon, swap `pwsh` and `bash` for their icons
    local title = fun
        .basename(pane.title)
        :gsub("%.exe%s?$", "")
        :gsub("^Administrator: %w+", icons.Admin)
        :gsub("pwsh", icons.Pwsh)
        :gsub("bash", icons.Bash)
        :gsub("Copy mode: ", "")

    local proc = pane.foreground_process_name
    if proc:find "nvim" then
      proc = proc:sub(proc:find "nvim")
    end
    local is_truncation_needed = true
    ---HACK: running nvim somehow causes the tab title to become cmd. (don't use cmd
    ---      so it's safe for me)
    if proc == "nvim" or title == "cmd" then
      ---full title truncation is not necessary since the dir name will be truncated
      is_truncation_needed = false
      local cwd = fun.basename(pane.current_working_dir.file_path)

      ---instead of truncating the whole title, truncate to length the cwd to ensure that the
      ---right parenthesis always closes.
      if max_width == config.tab_max_width then
        cwd = wezterm.truncate_right(cwd, max_width - 14) .. "..."
      end

      title = ("%s ( %s)"):format(icons.Vim, cwd)
    end
    title = title:gsub(fun.basename(fun.home), "󰋜 ")

    ---truncate the tab title when it overflows the maximum available space, then concatenate
    ---some dots to indicate the occurred truncation
    if is_truncation_needed and max_width == config.tab_max_width then
      title = wezterm.truncate_right(title, max_width - 8) .. "..."
    end

    ---add the either the leftmost element or the normal left separator. This is done to
    ---esure a bit of space from the left margin.
    TabTitle:push(bg, fg, tab_idx == 0 and tabicons.leftmost or tabicons.left, attributes)

    ---add the tab number. can be substituted by the `has_unseen_output` notification
    TabTitle:push(
      fg,
      bg,
      (unseen_output and icons.UnseenNotification or icons.Numbers[tab_idx + 1] or "")
      .. " ",
      attributes
    )

    ---the formatted tab title
    TabTitle:push(fg, bg, title, attributes)

    ---the right tab bar separator
    TabTitle:push(bg, fg, icons.Separators.FullBlock .. tabicons.right, attributes)

    return TabTitle
  end)
end

return M

---@class WezTerm
local wezterm = require('wezterm')
local tools = require("utils.fun") ---@class UtilityFunctions

local M = {}

M.setup = function()
    wezterm.on("format-window-title", function(tab, pane, tabs, _, _)
        local zoomed = ""
        if tab.active_pane.is_zoomed then
            zoomed = "[Z] "
        end

        local index = ""
        if #tabs > 1 then
            index = ("[%d/%d] "):format(tab.tab_index + 1, #tabs)
        end

        ---tab title
        local title = tools.basename(pane.title):gsub("%.exe%s?$", "")

        local proc = pane.foreground_process_name
        if proc:find "nvim" then
            proc = proc:sub(proc:find "nvim")
        end
        if proc == "nvim" or title == "cmd" then
            local cwd, _ = tools.basename(pane.current_working_dir.file_path)
            title = ("Neovim (dir: %s)"):format(cwd)
        end

        return zoomed .. index .. title
    end)
end

return M

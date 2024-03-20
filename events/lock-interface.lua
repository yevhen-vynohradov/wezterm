---@class WezTerm
local wezterm = require('wezterm')

local M = {}

M.setup = function()
    wezterm.on("lock-interface", function(window, pane)
        local overrides = window:get_config_overrides() or {}
        if not overrides.leader then
            -- replace it with an "impossible" leader that will never be pressed
            overrides.leader = { key = "\\", mods = "CTRL|ALT|SUPER" }
            wezterm.log_warn("[leader] clear")
        else
            -- restore to the main leader
            overrides.leader = nil
            wezterm.log_warn("[leader] set")
        end
        window:set_config_overrides(overrides)
    end)

end

return M
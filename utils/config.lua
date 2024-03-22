---@class WezTerm
local wezterm = require('wezterm')

---@class Config
---@field options table
local Config = {}

---Initialize Config
---@return Config
function Config:init()
   self.config = {}

   if wezterm.config_builder then
      self.config = wezterm.config_builder()
      self.config:set_strict_mode(true)
   end

   self = setmetatable(self.config, { __index = Config })

   return self
end

---Adds a module to the wezterm configuration
---@param new_options string|table table of wezterm configuration options
---@return Config self modified wezterm configuration table
---
---```lua
----- Example usage in wezterm.lua
---local Config = require "config"
---return Config:init():append("<module.name>").options
---```
function Config:append(new_options)
   if type(new_options) == "string" then
      new_options = require(new_options)
   end

   for k, v in pairs(new_options) do
      if self.config[k] ~= nil then
         wezterm.log_warn(
            'Duplicate config option detected: ',
            { old = self.config[k], new = new_options[k] }
         )
      else   
         self.config[k] = v
      end
   end

   return self
end

return Config

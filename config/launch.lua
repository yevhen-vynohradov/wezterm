local platform = require('utils.platform')()

---@class Config
local Config = {}

Config.default_prog = {}
Config.launch_menu = {}

if platform.is_win then
   Config.default_prog = { 'zsh', '-l' }
   Config.default_domain = 'WSL:Ubuntu'
   Config.launch_menu = {
      { label = '🟢 NuShell',            args = { 'nu' } },
      { label = '🟣 PowerShell Core',    args = { 'pwsh' } },
      { label = '🔵 Windows PowerShell', args = { 'powershell' } },
   }
elseif platform.is_mac then
   Config.default_prog = { 'zsh', '-l' }
   Config.launch_menu = {
      { label = 'Bash',    args = { 'bash' } },
      { label = 'Zsh',     args = { 'zsh' } },
   }
elseif platform.is_linux then
   Config.default_prog = { 'fish' }
   Config.launch_menu = {
      { label = 'Bash', args = { 'bash' } },
      { label = 'Fish', args = { 'fish' } },
      { label = 'Zsh',  args = { 'zsh' } },
   }
end

return Config

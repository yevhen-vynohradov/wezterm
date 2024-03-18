local platform = require('utils.platform')()

local options = {
   default_prog = {},
   launch_menu = {},
}

if platform.is_win then
   options.default_prog = { 'zsh', '-l' }
   options.default_domain = 'WSL:Ubuntu'
   options.launch_menu = {
      { label = '🟢 NuShell',            args = { 'nu' } },
      { label = '🟣 PowerShell Core',    args = { 'pwsh' } },
      { label = '🔵 Windows PowerShell', args = { 'powershell' } },
   }
elseif platform.is_mac then
   options.default_prog = { 'zsh', '-l' }
   options.launch_menu = {
      { label = 'Bash',    args = { 'bash' } },
      { label = 'Zsh',     args = { 'zsh' } },
   }
elseif platform.is_linux then
   options.default_prog = { 'fish' }
   options.launch_menu = {
      { label = 'Bash', args = { 'bash' } },
      { label = 'Fish', args = { 'fish' } },
      { label = 'Zsh',  args = { 'zsh' } },
   }
end

return options

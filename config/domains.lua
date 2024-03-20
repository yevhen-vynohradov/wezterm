---@class Config
local Config = {}

-- ref: https://wezfurlong.org/wezterm/config/lua/SshDomain.html
Config.ssh_domains = {}

-- ref: https://wezfurlong.org/wezterm/multiplexing.html#unix-domains
Config.unix_domains = {}

-- ref: https://wezfurlong.org/wezterm/config/lua/WslDomain.html
Config.wsl_domains = {
   {
      name = 'WSL:Ubuntu',
      distribution = 'Ubuntu',
      username = 'yevhen',
      default_cwd = '/home/yevhen',
      default_prog = { 'zsh' },
   },
}

return Config

local Config = require('utils.config')

require('utils.backdrops'):set_files():random()

require('events.gui-startup').setup()
require('events.lock-interface').setup()
require('events.new-tab-button-click').setup()
require('events.format-window-title').setup()
require('events.format-tab-title').setup()
require('events.update-status').setup()

return Config:init()
   :append('config')
   :append('mappings')

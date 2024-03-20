local tool = require("utils.fun")

return tool.tbl_merge(
  (require "config.appearance"),
  (require "config.domains"),
  (require "config.fonts"),
  (require "config.gpu"),
  (require "config.general"),
  (require "config.tab-bar"),
  (require "config.launch")
)

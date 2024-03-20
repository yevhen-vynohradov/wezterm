local tool = require("utils.fun")

return tool.tbl_merge(
  (require "mappings.default"),
  (require "mappings.modes")
)

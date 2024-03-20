local gpu_adapters = require('utils.gpu_adapter')

---@class Config
local Config = {}

   Config.front_end = 'WebGpu'
   Config.webgpu_force_fallback_adapter = false
   Config.webgpu_power_preference = 'HighPerformance'
   Config.webgpu_preferred_adapter = gpu_adapters:pick()

return Config
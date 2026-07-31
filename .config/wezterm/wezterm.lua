local wezterm = require("wezterm")
-- local sessionizer = require("lua.sessionizer")
local config = wezterm.config_builder()

-- appearance
config.font = wezterm.font("Maple Mono NF CN")
config.font_size = 13
config.color_scheme = "dank-theme"
-- config.window_background_opacity = 0.9
config.window_padding = {
  left = 5,
  right = 5,
  top = 10,
  bottom = 5,
}

config.max_fps = 165
config.animation_fps = 165
config.front_end = "WebGpu"
config.prefer_egl = true

config.enable_tab_bar = false
config.window_decorations = "NONE"
config.window_close_confirmation = "NeverPrompt"
config.automatically_reload_config = true
config.audible_bell = "Disabled"
config.adjust_window_size_when_changing_font_size = false

return config

-- Ghost's keybinds (Hyprland 0.55+ Lua)
-- Migrated from hyprlang conf + DMS defaults
--
-- Conflict resolutions vs lua defaults:
--   SUPER+T       → wezterm        (was ghostty)
--   SUPER+P       → zathura        (was cycleProfile — removed)
--   SUPER+SHIFT+L → systemctl suspend (was window.move(r); HJKL window-move
--                   removed since it was commented out in conf)
--   Float toggle  → SUPER+SHIFT+T  (was SUPER+ALT+space in conf, new lua key)

-- === Application Launchers ===
hl.bind("SUPER + T", hl.dsp.exec_cmd("wezterm"))
hl.bind("SUPER + A", hl.dsp.exec_cmd("wezterm -e herdr"))
hl.bind("SUPER + C", hl.dsp.exec_cmd("code"))
hl.bind("SUPER + E", hl.dsp.exec_cmd("nemo"))
hl.bind("SUPER + W", hl.dsp.exec_cmd("helium"))
hl.bind("SUPER + CTRL + W", hl.dsp.exec_cmd("helium --incognito"))
hl.bind("SUPER + P", hl.dsp.exec_cmd("zathura"))
hl.bind("SUPER + ALT + E", hl.dsp.exec_cmd("thunar"))
hl.bind("SUPER + ALT + O", hl.dsp.exec_cmd("obsidian"))
hl.bind("SUPER + ALT + S", hl.dsp.exec_cmd("onlyoffice"))
hl.bind("SUPER + CTRL + Escape", hl.dsp.exec_cmd("missioncenter"))
hl.bind("SUPER + CTRL + V", hl.dsp.exec_cmd("pavucontrol"))

-- === DMS Shell ===
hl.bind("SUPER + space", hl.dsp.exec_cmd("dms ipc call spotlight toggle"))
hl.bind("ALT + space", hl.dsp.exec_cmd("dms ipc call spotlight-bar toggle"))
hl.bind("SUPER + V", hl.dsp.exec_cmd("dms ipc call clipboard toggle"))
hl.bind("SUPER + M", hl.dsp.exec_cmd("dms ipc call processlist focusOrToggle"))
hl.bind("SUPER + comma", hl.dsp.exec_cmd("dms ipc call settings focusOrToggle"))
hl.bind("SUPER + N", hl.dsp.exec_cmd("dms ipc call notifications toggle"))
hl.bind("SUPER + SHIFT + N", hl.dsp.exec_cmd("dms ipc call notepad toggle"))
hl.bind("SUPER + Y", hl.dsp.exec_cmd("dms ipc call dankdash wallpaper"))
hl.bind("SUPER + TAB", hl.dsp.exec_cmd("dms ipc call hypr toggleOverview"))
hl.bind("SUPER + O", hl.dsp.exec_cmd("dms ipc call hypr toggleOverview"))
hl.bind("SUPER + X", hl.dsp.exec_cmd("dms ipc call powermenu toggle"))
hl.bind("SUPER + SHIFT + W", hl.dsp.exec_cmd("dms ipc call window-rules toggle"))
hl.bind("SUPER + SHIFT + Slash", hl.dsp.exec_cmd("dms ipc call keybinds toggle hyprland"))
-- hl.bind("CTRL + SHIFT + R", hl.dsp.exec_cmd("dms ipc call workspace-rename open"))

-- === Security ===
hl.bind("SUPER + ALT + L", hl.dsp.exec_cmd("dms ipc call lock lock"))
hl.bind("SUPER + SHIFT + E", hl.dsp.exit())
hl.bind("CTRL + ALT + Delete", hl.dsp.exec_cmd("dms ipc call processlist focusOrToggle"))

-- === System Controls ===
hl.bind("SUPER + SHIFT + L", hl.dsp.exec_cmd("systemctl suspend"))
hl.bind("SUPER + SHIFT + M", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("SUPER + SHIFT + C", hl.dsp.exec_cmd("hyprpicker -a"))
hl.bind("SUPER + SHIFT + P", hl.dsp.dpms({ action = "toggle" }))

-- === ASUS / ROG Controls ===
hl.bind("XF86KbdBrightnessDown", hl.dsp.exec_cmd("asusctl leds prev"))
hl.bind("XF86KbdBrightnessUp", hl.dsp.exec_cmd("asusctl leds next"))
hl.bind("XF86Launch1", hl.dsp.exec_cmd("rog-control-center"))
hl.bind("XF86Launch3", hl.dsp.exec_cmd("asusctl aura effect --next-mode"))

-- === Audio Controls ===
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("dms ipc call audio increment 5"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("dms ipc call audio decrement 5"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("dms ipc call audio mute"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("dms ipc call audio micmute"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("dms ipc call mpris playPause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("dms ipc call mpris playPause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("dms ipc call mpris previous"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("dms ipc call mpris next"), { locked = true })
hl.bind("CTRL + XF86AudioRaiseVolume", hl.dsp.exec_cmd("dms ipc call mpris increment 5"), { locked = true, repeating = true })
hl.bind("CTRL + XF86AudioLowerVolume", hl.dsp.exec_cmd("dms ipc call mpris decrement 5"), { locked = true, repeating = true })

-- === Brightness Controls ===
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd([[dms ipc call brightness increment 5 ""]]), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd([[dms ipc call brightness decrement 5 ""]]), { locked = true, repeating = true })

-- === Screenshots ===
hl.bind("Print", hl.dsp.exec_cmd("dms screenshot"))
hl.bind("CTRL + Print", hl.dsp.exec_cmd("dms screenshot full"))
hl.bind("ALT + Print", hl.dsp.exec_cmd("dms screenshot window"))
hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd("dms screenshot"))

-- === Window Management ===
hl.bind("SUPER + Q", hl.dsp.window.close())
hl.bind("SUPER + F", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
hl.bind("SUPER + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind("SUPER + ALT + space", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + R", hl.dsp.layout("togglesplit"))
hl.bind("SUPER + CTRL + F", hl.dsp.window.fullscreen({ mode = "maximized", action = "set" }))

-- === Focus Navigation ===
hl.bind("SUPER + left", hl.dsp.focus({ direction = "l" }))
hl.bind("SUPER + down", hl.dsp.focus({ direction = "d" }))
hl.bind("SUPER + up", hl.dsp.focus({ direction = "u" }))
hl.bind("SUPER + right", hl.dsp.focus({ direction = "r" }))
hl.bind("SUPER + H", hl.dsp.focus({ direction = "l" }))
hl.bind("SUPER + J", hl.dsp.focus({ direction = "d" }))
hl.bind("SUPER + K", hl.dsp.focus({ direction = "u" }))
hl.bind("SUPER + L", hl.dsp.focus({ direction = "r" }))

-- === Window Movement (arrows only; HJKL removed — conflicts with suspend on SHIFT+L) ===
hl.bind("SUPER + SHIFT + left", hl.dsp.window.move({ direction = "l" }))
hl.bind("SUPER + SHIFT + down", hl.dsp.window.move({ direction = "d" }))
hl.bind("SUPER + SHIFT + up", hl.dsp.window.move({ direction = "u" }))
hl.bind("SUPER + SHIFT + right", hl.dsp.window.move({ direction = "r" }))

-- === Column Navigation ===
hl.bind("SUPER + Home", hl.dsp.focus({ window = "first" }))
hl.bind("SUPER + End", hl.dsp.focus({ window = "last" }))

-- === Monitor Navigation ===
hl.bind("SUPER + CTRL + left", hl.dsp.focus({ monitor = "l" }))
hl.bind("SUPER + CTRL + right", hl.dsp.focus({ monitor = "r" }))
hl.bind("SUPER + CTRL + H", hl.dsp.focus({ monitor = "l" }))
hl.bind("SUPER + CTRL + J", hl.dsp.focus({ monitor = "d" }))
hl.bind("SUPER + CTRL + K", hl.dsp.focus({ monitor = "u" }))
hl.bind("SUPER + CTRL + L", hl.dsp.focus({ monitor = "r" }))

-- === Move Window to Monitor ===
hl.bind("SUPER + SHIFT + CTRL + left", hl.dsp.window.move({ monitor = "l" }))
hl.bind("SUPER + SHIFT + CTRL + down", hl.dsp.window.move({ monitor = "d" }))
hl.bind("SUPER + SHIFT + CTRL + up", hl.dsp.window.move({ monitor = "u" }))
hl.bind("SUPER + SHIFT + CTRL + right", hl.dsp.window.move({ monitor = "r" }))
hl.bind("SUPER + SHIFT + CTRL + H", hl.dsp.window.move({ monitor = "l" }))
hl.bind("SUPER + SHIFT + CTRL + J", hl.dsp.window.move({ monitor = "d" }))
hl.bind("SUPER + SHIFT + CTRL + K", hl.dsp.window.move({ monitor = "u" }))
hl.bind("SUPER + SHIFT + CTRL + L", hl.dsp.window.move({ monitor = "r" }))

-- === Workspace Navigation ===
-- hl.bind("SUPER + Page_Down", hl.dsp.focus({ workspace = "e+1" }))
-- hl.bind("SUPER + Page_Up", hl.dsp.focus({ workspace = "e-1" }))
-- hl.bind("SUPER + U", hl.dsp.focus({ workspace = "e+1" }))
-- hl.bind("SUPER + I", hl.dsp.focus({ workspace = "e-1" }))
-- hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
-- hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
--
-- -- === Move Window to Workspace ===
-- hl.bind("SUPER + CTRL + down", hl.dsp.window.move({ workspace = "e+1" }))
-- hl.bind("SUPER + CTRL + up", hl.dsp.window.move({ workspace = "e-1" }))
-- hl.bind("SUPER + CTRL + U", hl.dsp.window.move({ workspace = "e+1" }))
-- hl.bind("SUPER + CTRL + I", hl.dsp.window.move({ workspace = "e-1" }))
-- hl.bind("SUPER + CTRL + mouse_down", hl.dsp.window.move({ workspace = "e+1" }))
-- hl.bind("SUPER + CTRL + mouse_up", hl.dsp.window.move({ workspace = "e-1" }))
-- hl.bind("SUPER + SHIFT + Page_Down", hl.dsp.window.move({ workspace = "e+1" }))
-- hl.bind("SUPER + SHIFT + Page_Up", hl.dsp.window.move({ workspace = "e-1" }))
-- hl.bind("SUPER + SHIFT + U", hl.dsp.window.move({ workspace = "e+1" }))
-- hl.bind("SUPER + SHIFT + I", hl.dsp.window.move({ workspace = "e-1" }))

-- === Numbered Workspaces ===
hl.bind("SUPER + 1", hl.dsp.focus({ workspace = "1" }))
hl.bind("SUPER + 2", hl.dsp.focus({ workspace = "2" }))
hl.bind("SUPER + 3", hl.dsp.focus({ workspace = "3" }))
hl.bind("SUPER + 4", hl.dsp.focus({ workspace = "4" }))
hl.bind("SUPER + 5", hl.dsp.focus({ workspace = "5" }))
hl.bind("SUPER + 6", hl.dsp.focus({ workspace = "6" }))
hl.bind("SUPER + 7", hl.dsp.focus({ workspace = "7" }))
hl.bind("SUPER + 8", hl.dsp.focus({ workspace = "8" }))
hl.bind("SUPER + 9", hl.dsp.focus({ workspace = "9" }))

-- === Move Window to Numbered Workspace ===
hl.bind("SUPER + SHIFT + 1", hl.dsp.window.move({ workspace = "1" }))
hl.bind("SUPER + SHIFT + 2", hl.dsp.window.move({ workspace = "2" }))
hl.bind("SUPER + SHIFT + 3", hl.dsp.window.move({ workspace = "3" }))
hl.bind("SUPER + SHIFT + 4", hl.dsp.window.move({ workspace = "4" }))
hl.bind("SUPER + SHIFT + 5", hl.dsp.window.move({ workspace = "5" }))
hl.bind("SUPER + SHIFT + 6", hl.dsp.window.move({ workspace = "6" }))
hl.bind("SUPER + SHIFT + 7", hl.dsp.window.move({ workspace = "7" }))
hl.bind("SUPER + SHIFT + 8", hl.dsp.window.move({ workspace = "8" }))
hl.bind("SUPER + SHIFT + 9", hl.dsp.window.move({ workspace = "9" }))

-- === Column Management ===
hl.bind("SUPER + bracketleft", hl.dsp.layout("preselect l"))
hl.bind("SUPER + bracketright", hl.dsp.layout("preselect r"))

-- === Resize ===
hl.bind("SUPER + minus", hl.dsp.window.resize({ x = -100, y = 0, relative = true }), { repeating = true })
hl.bind("SUPER + equal", hl.dsp.window.resize({ x = 100, y = 0, relative = true }), { repeating = true })
hl.bind("SUPER + SHIFT + minus", hl.dsp.window.resize({ x = 0, y = -100, relative = true }), { repeating = true })
hl.bind("SUPER + SHIFT + equal", hl.dsp.window.resize({ x = 0, y = 100, relative = true }), { repeating = true })
hl.bind("SUPER + code:20", hl.dsp.window.resize({ x = -100, y = 0, relative = true }), { description = "Expand window left" })
hl.bind("SUPER + code:21", hl.dsp.window.resize({ x = 100, y = 0, relative = true }), { description = "Shrink window left" })

-- === Mouse Drag ===
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true, description = "Move window" })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "Resize window" })

-- === Touchpad Gestures ===
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

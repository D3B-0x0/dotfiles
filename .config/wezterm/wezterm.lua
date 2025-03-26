-- Pull in the wezterm API
local wezterm = require "wezterm"
local act = wezterm.action
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.color_scheme = "Catppuccin Mocha"
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 14
config.line_height = 1.0  -- Slightly increase line height for better spacing
--config.harfbuzz_features = { "calt=1", "liga=1", "clig=1" }  -- Enable ligatures

config.window_decorations = "NONE"
config.window_background_opacity = 1

config.leader = { key = "q", mods = "CTRL", timeout_milliseconds = 2500 }
config.keys = {
  {
    mods = "LEADER",
    key = "t",
    action = act.SpawnTab "CurrentPaneDomain",
  },
  {
    key = 'r',
    mods = 'LEADER',
    action = act.PromptInputLine {
      description = 'Enter new name for tab',
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:active_tab():set_title(line)
        end
      end),
    },
  },
  {
    key = 'w',
    mods = 'LEADER',
    action = act.PaneSelect {
      mode = 'MoveToNewWindow',
    },
  },
  -- Fixed new features
  {
    key = 'z',
    mods = 'LEADER',
    action = act.TogglePaneZoomState,
  },
  {
    key = 'p',
    mods = 'LEADER',
    action = act.PaneSelect({
      alphabet = '1234567890',
    }),
  },
  {
    key = '/',
    mods = 'LEADER',
    action = act.Search("CurrentSelectionOrEmptyString"),
  },
  {
    key = 'f',
    mods = 'LEADER',
    action = act.ToggleFullScreen,
  },
  {
    mods = "LEADER",
    key = "x",
    action = act.CloseCurrentPane { confirm = true }
  },
  {
    mods = "LEADER",
    key = "b",
    action = act.ActivateTabRelative(-1)
  },
  {
    mods = "LEADER",
    key = "n",
    action = act.ActivateTabRelative(1)
  },
  {
    mods = "LEADER",
    key = "v",
    action = act.SplitHorizontal { domain = "CurrentPaneDomain" }
  },
  {
    mods = "LEADER",
    key = "-",
    action = act.SplitVertical { domain = "CurrentPaneDomain" }
  },
  {
    mods = "LEADER",
    key = "h",
    action = act.ActivatePaneDirection "Left"
  },
  {
    mods = "LEADER",
    key = "j",
    action = act.ActivatePaneDirection "Down"
  },
  {
    mods = "LEADER",
    key = "k",
    action = act.ActivatePaneDirection "Up"
  },
  {
    mods = "LEADER",
    key = "l",
    action = act.ActivatePaneDirection "Right"
  },
  {
    mods = "LEADER",
    key = "LeftArrow",
    action = act.AdjustPaneSize { "Left", 5 }
  },
  {
    mods = "LEADER",
    key = "RightArrow",
    action = act.AdjustPaneSize { "Right", 5 }
  },
  {
    mods = "LEADER",
    key = "DownArrow",
    action = act.AdjustPaneSize { "Down", 5 }
  },
  {
    mods = "LEADER",
    key = "UpArrow",
    action = act.AdjustPaneSize { "Up", 5 }
  },
}

for i = 0, 9 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = "LEADER",
    action = act.ActivateTab(i),
  })
end

config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.tab_and_split_indices_are_zero_based = true

wezterm.on("update-right-status", function(window, _)
  local SOLID_LEFT_ARROW = ""
  local ARROW_FOREGROUND = { Foreground = { Color = "#c6a0f6" } }
  local prefix = ""
  if window:leader_is_active() then
    prefix = " " .. utf8.char(0x1f427)
    SOLID_LEFT_ARROW = utf8.char(0xe0b2)
  end
  if window:active_tab():tab_id() ~= 0 then
    ARROW_FOREGROUND = { Foreground = { Color = "#1e2030" } }
  end
  window:set_left_status(wezterm.format {
    { Background = { Color = "#1E1E2E" } },
    { Text = prefix },
    ARROW_FOREGROUND,
    { Text = SOLID_LEFT_ARROW }
  })
end)

config.scrollback_lines = 10000
config.enable_scroll_bar = true

return config

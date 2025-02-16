local wezterm = require("wezterm")
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config = {
  default_cursor_style = "SteadyBar",
  automatically_reload_config = true,
  window_close_confirmation = "NeverPrompt",
  adjust_window_size_when_changing_font_size = false,
  window_decorations = "RESIZE",
  check_for_updates = false,
  font_size = 12.5,
  font = wezterm.font("FiraCode Nerd Font Mono", { weight = "Bold" }),
  enable_tab_bar = true,
  hide_tab_bar_if_only_one_tab = true,
  use_fancy_tab_bar = false,
  tab_bar_at_bottom = true,

  window_padding = {
    left = 40,
    right = 30,
    top = 10,
    bottom = 10,
  },

  background = {
    {
      source = { Color = "#24273a" },
      width = "100%",
      height = "100%",
      opacity = 0.8,
    },
  },

  hyperlink_rules = {
    {
      regex = "\\((\\w+://\\S+)\\)",
      format = "$1",
      highlight = 1,
    },
    {
      regex = "\\[(\\w+://\\S+)\\]",
      format = "$1",
      highlight = 1,
    },
    {
      regex = "\\{(\\w+://\\S+)\\}",
      format = "$1",
      highlight = 1,
    },
    {
      regex = "<(\\w+://\\S+)>",
      format = "$1",
      highlight = 1,
    },
    {
      regex = "[^(]\\b(\\w+://\\S+[)/a-zA-Z0-9-]+)",
      format = "$1",
      highlight = 1,
    },
    {
      regex = "\\b\\w+@[\\w-]+(\\.[\\w-]+)+\\b",
      format = "mailto:$0",
    },
  },

  -- Keybindings
  leader = { key = "q", mods = "CTRL", timeout_milliseconds = 1000 }, -- Leader key
  keys = {
    -- New Tab
    { mods = "LEADER", key = "c", action = wezterm.action.SpawnTab "CurrentPaneDomain" },

    -- Close Pane
    { mods = "LEADER", key = "x", action = wezterm.action.CloseCurrentPane { confirm = true } },

    -- Switch Between Tabs
    { mods = "LEADER", key = "b", action = wezterm.action.ActivateTabRelative(-1) },
    { mods = "LEADER", key = "n", action = wezterm.action.ActivateTabRelative(1) },

    -- Split Pane
    { mods = "LEADER", key = "|", action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" } },
    { mods = "LEADER", key = "-", action = wezterm.action.SplitVertical { domain = "CurrentPaneDomain" } },

    -- Navigate Panes
    { mods = "LEADER", key = "h", action = wezterm.action.ActivatePaneDirection "Left" },
    { mods = "LEADER", key = "j", action = wezterm.action.ActivatePaneDirection "Down" },
    { mods = "LEADER", key = "k", action = wezterm.action.ActivatePaneDirection "Up" },
    { mods = "LEADER", key = "l", action = wezterm.action.ActivatePaneDirection "Right" },

    -- Resize Panes
    { mods = "LEADER", key = "LeftArrow", action = wezterm.action.AdjustPaneSize { "Left", 5 } },
    { mods = "LEADER", key = "RightArrow", action = wezterm.action.AdjustPaneSize { "Right", 5 } },
    { mods = "LEADER", key = "DownArrow", action = wezterm.action.AdjustPaneSize { "Down", 5 } },
    { mods = "LEADER", key = "UpArrow", action = wezterm.action.AdjustPaneSize { "Up", 5 } },
  },
}

-- Add number keys (Leader + Number) to switch tabs
for i = 0, 9 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = "LEADER",
    action = wezterm.action.ActivateTab(i),
  })
end

return config


-- Keybindings:
-- 1. Tab Management:
--    - LEADER + c: Create a new tab in the current pane's domain.
--    - LEADER + x: Close the current pane (with confirmation).
--    - LEADER + b: Switch to the previous tab.
--    - LEADER + n: Switch to the next tab.
--    - LEADER + <number>: Switch to a specific tab (0–9).

-- 2. Pane Splitting:
--    - LEADER + |: Split the current pane horizontally into two panes.
--    - LEADER + -: Split the current pane vertically into two panes.

-- 3. Pane Navigation:
--    - LEADER + h: Move to the pane on the left.
--    - LEADER + j: Move to the pane below.
--    - LEADER + k: Move to the pane above.
--    - LEADER + l: Move to the pane on the right.

-- 4. Pane Resizing:
--    - LEADER + LeftArrow: Increase the pane size to the left by 5 units.
--    - LEADER + RightArrow: Increase the pane size to the right by 5 units.
--    - LEADER + DownArrow: Increase the pane size downward by 5 units.
--    - LEADER + UpArrow: Increase the pane size upward by 5 units.

-- 5. Status Line:
--    - The status line indicates when the leader key is active, displaying an ocean wave emoji (🌊).

-- Miscellaneous Configurations:
-- - Tabs are shown even if there's only one tab.
-- - The tab bar is located at the bottom of the terminal window.
-- - Tab and split indices are zero-based.


-- Pull in the wezterm API
local wezterm = require "wezterm"
-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
    config = wezterm.config_builder()
end

-- For example, changing the color scheme:
config.adjust_window_size_when_changing_font_size = false
config.font =wezterm.font("FiraCode Nerd Font Mono", { weight = "Bold" })
config.font_size = 16
config.automatically_reload_config = true
config.window_decorations = "RESIZE"
config.window_close_confirmation = "NeverPrompt"

config.window_background_opacity = 0.8 -- Adjust the opacity as needed
config.background = {
    {
        source = { Color = "#24273a" }, -- Replace with your desired color
        width = "100%",
        height = "100%",
        opacity = 0.8,
    },
}

config.window_padding = {
    left = 40,
    right = 30,
    top = 10,
    bottom = 10,
  }


-- tab bar
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.tab_and_split_indices_are_zero_based = true

-- tmux
config.leader = { key = "q", mods = "CTRL", timeout_milliseconds = 2000 }
config.keys = {
    {
        mods = "LEADER",
        key = "c",
        action = wezterm.action.SpawnTab "CurrentPaneDomain",
    },
    {
        mods = "LEADER",
        key = "x",
        action = wezterm.action.CloseCurrentPane { confirm = true }
    },
    {
        mods = "LEADER",
        key = "b",
        action = wezterm.action.ActivateTabRelative(-1)
    },
    {
        mods = "LEADER",
        key = "n",
        action = wezterm.action.ActivateTabRelative(1)
    },
    {
        mods = "LEADER",
        key = "|",
        action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" }
    },
    {
        mods = "LEADER",
        key = "-",
        action = wezterm.action.SplitVertical { domain = "CurrentPaneDomain" }
    },
    {
        mods = "LEADER",
        key = "h",
        action = wezterm.action.ActivatePaneDirection "Left"
    },
    {
        mods = "LEADER",
        key = "j",
        action = wezterm.action.ActivatePaneDirection "Down"
    },
    {
        mods = "LEADER",
        key = "k",
        action = wezterm.action.ActivatePaneDirection "Up"
    },
    {
        mods = "LEADER",
        key = "l",
        action = wezterm.action.ActivatePaneDirection "Right"
    },
    {
        mods = "LEADER",
        key = "LeftArrow",
        action = wezterm.action.AdjustPaneSize { "Left", 5 }
    },
    {
        mods = "LEADER",
        key = "RightArrow",
        action = wezterm.action.AdjustPaneSize { "Right", 5 }
    },
    {
        mods = "LEADER",
        key = "DownArrow",
        action = wezterm.action.AdjustPaneSize { "Down", 5 }
    },
    {
        mods = "LEADER",
        key = "UpArrow",
        action = wezterm.action.AdjustPaneSize { "Up", 5 }
    },
}

for i = 0, 9 do
    -- leader + number to activate that tab
    table.insert(config.keys, {
        key = tostring(i),
        mods = "LEADER",
        action = wezterm.action.ActivateTab(i),
    })
end



-- tmux status
wezterm.on("update-right-status", function(window, _)
    local SOLID_LEFT_ARROW = ""
    local ARROW_FOREGROUND = { Foreground = { Color = "#c6a0f6" } }
    local prefix = ""

    if window:leader_is_active() then
        prefix = " " .. utf8.char(0x1f30a) -- ocean wave
        SOLID_LEFT_ARROW = utf8.char(0xe0b2)
    end

    if window:active_tab():tab_id() ~= 0 then
        ARROW_FOREGROUND = { Foreground = { Color = "#1e2030" } }
    end -- arrow color based on if tab is first pane

    window:set_left_status(wezterm.format {
        { Background = { Color = "#b7bdf8" } },
        { Text = prefix },
        ARROW_FOREGROUND,
        { Text = SOLID_LEFT_ARROW }
    })
end)

config.colors = {
    tab_bar = {
      -- The color of the strip that goes along the top of the window
      -- (does not apply when fancy tab bar is in use)
      background = '#24273a',
  
      -- The active tab is the one that has focus in the window
      active_tab = {
        -- The color of the background area for the tab
        bg_color = '#a5adcb',
        -- The color of the text for the tab
        fg_color = '#181926',
  
        -- Specify whether you want "Half", "Normal" or "Bold" intensity for the
        -- label shown for this tab.
        -- The default is "Normal"
        intensity = 'Normal',
  
        -- Specify whether you want "None", "Single" or "Double" underline for
        -- label shown for this tab.
        -- The default is "None"
        underline = 'None',
  
        -- Specify whether you want the text to be italic (true) or not (false)
        -- for this tab.  The default is false.
        italic = false,
  
        -- Specify whether you want the text to be rendered with strikethrough (true)
        -- or not for this tab.  The default is false.
        strikethrough = false,
      },
  
      -- Inactive tabs are the tabs that do not have focus
      inactive_tab = {
        bg_color = '#24273a',
        fg_color = '#808080',
  
        -- The same options that were listed under the `active_tab` section above
        -- can also be used for `inactive_tab`.
      },
  
      -- You can configure some alternate styling when the mouse pointer
      -- moves over inactive tabs
      inactive_tab_hover = {
        bg_color = '#a5adcb',
        fg_color = '#181926',
        italic = true,
  
        -- The same options that were listed under the `active_tab` section above
        -- can also be used for `inactive_tab_hover`.
      },
  
      -- The new tab button that let you create new tabs
      new_tab = {
        bg_color = '#24273a',
        fg_color = '#808080',
  
        -- The same options that were listed under the `active_tab` section above
        -- can also be used for `new_tab`.
      },
  
      -- You can configure some alternate styling when the mouse pointer
      -- moves over the new tab button
      new_tab_hover = {
        bg_color = '#8bd5ca',
        fg_color = '#181926',
        italic = true,
  
        -- The same options that were listed under the `active_tab` section above
        -- can also be used for `new_tab_hover`.
      },
    },
  }

-- and finally, return the configuration to wezterm
return config
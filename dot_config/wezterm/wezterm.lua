-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
config.font = wezterm.font 'MesloLGM Nerd Font Mono'
config.font_size = 12

-- For example, changing the color scheme:
config.colors = {
    foreground = '#979eab',
    background = '#282c34',
    cursor_fg = '#cccccc',
    selection_fg = '#282c34',
    selection_bg = '#979eab',
    ansi = {
        '#282c34',
        "#e06c75",
        "#98c379",
        "#e5c07b",
        "#61afef",
        "#be5046",
        "#56b6c2",
        "#979eab",
    },
    brights = {
        "#393e48",
        "#d19a66",
        "#56b6c2",
        "#e5c07b",
        "#61afef",
        "#be5046",
        "#56b6c2",
        "#abb2bf",
    },
}

-- and finally, return the configuration to wezterm
return config

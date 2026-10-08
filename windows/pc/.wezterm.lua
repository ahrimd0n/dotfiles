-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

local act = wezterm.action

-- SSH Domains
-- config.ssh_domains = {
--   {
--     name = 'Ubuntu Server',
--     remote_address = '192.168.0.202:30'
--     -- ssh_option = {
--       -- identityfile = '/path/to/id_rsa.pub',
--     -- },
--   },
-- }

-- Disable SSH Agent to fix issue with ssh-agent
-- config.mux_enable_ssh_agent = false

-- Font
config.font = wezterm.font('JetBrains Mono', { weight = 'Regular', italic = false })
config.font_size = 12.0

-- Graphics
config.front_end = "OpenGL"
config.max_fps = 165
config.default_cursor_style = "BlinkingBlock"
config.animation_fps = 165
config.cursor_blink_rate = 500
config.term = "xterm-256color"



config.cell_width = 0.9
config.default_prog = { "pwsh.exe", "-nologo" }
config.set_environment_variables = {
	-- SHELL = shell,
}

-- config.hide_tab_bar_if_only_one_tab = false

-- config.initial_cols = 80

config.enable_scroll_bar = true
config.scrollback_lines = 10000
config.alternate_buffer_wheel_scroll_speed = 10


-- Tabline
config.use_fancy_tab_bar = true

-- local tabline = wezterm.plugin.require("file:///tabline.wez")

-- tabline.setup({
--   options = {
--     icons_enabled = true,
--     theme = 'Harmonic16 Dark (base16)',
--     tabs_enabled = true,
--     theme_overrides = {},
--     section_separators = {
--       left = wezterm.nerdfonts.pl_left_hard_divider,
--       right = wezterm.nerdfonts.pl_right_hard_divider,
--     },
--     component_separators = {
--       left = wezterm.nerdfonts.pl_left_soft_divider,
--       right = wezterm.nerdfonts.pl_right_soft_divider,
--     },
--     tab_separators = {
--       left = wezterm.nerdfonts.pl_left_hard_divider,
--       right = wezterm.nerdfonts.pl_right_hard_divider,
--     },
--   },
--   sections = {
--     tabline_a = { 'mode' },
--     tabline_b = { 'workspace', 'domain' },
--     tabline_c = { '' },
--     tab_active = {
--       'index',
--       { 'parent', padding = 0 },
--       '/',
--       { 'cwd', padding = { left = 0, right = 1 } },
--       { 'zoomed', padding = 0 },
--     },
--     tab_inactive = { 'index', { 'process', padding = { left = 0, right = 1 } } },
--     tabline_x = { 'ram', 'cpu' },
--     tabline_y = { },
--     tabline_z = { 'datetime' },
--   },
--   extensions = {},
-- })

-- config.window_background_opacity = 1 --0.8
config.text_background_opacity = 1.0
config.window_decorations = "TITLE | RESIZE"
config.ssh_backend = "LibSsh"
-- config.multiplexing = "No"

-- Close Confirmation
config.window_close_confirmation = "NeverPrompt"
config.skip_close_confirmation_for_processes_named = {
	"bash",
	"sh",
	"zsh",
	"fish",
	"tmux",
	"nu",
	"cmd.exe",
	"pwsh.exe",
	"powershell.exe",
}

config.launch_menu = {
	{
		-- Optional label to show in the launcher. If omitted, a label
		-- is derived from the `args`
		label = "Bash",
		-- The argument array to spawn.  If omitted the default program
		-- will be used as described in the documentation above
		args = { "C:/Program Files/Git/usr/bin/bash.exe", "-l" },

		-- You can specify an alternative current working directory;
		-- if you don't specify one then a default based on the OSC 7
		-- escape sequence will be used (see the Shell Integration
		-- docs), falling back to the home directory.
		-- cwd = "/some/path"

		-- You can override environment variables just for this command
		-- by setting this here.  It has the same semantics as the main
		-- set_environment_variables configuration option described above
		-- set_environment_variables = { FOO = "bar" },
	},
}

config.visual_bell = {
  fade_in_duration_ms = 75,
  fade_out_duration_ms = 75,
  target = 'CursorColor',
}

-- config.visual_bell = {
--   fade_in_function = 'EaseIn',
--   fade_in_duration_ms = 150,
--   fade_out_function = 'EaseOut',
--   fade_out_duration_ms = 150,
-- }
-- config.colors = {
--   visual_bell = '#202020',
-- }


function get_appearance()
	if wezterm.gui then
		return wezterm.gui.get_appearance()
	end
	return "DarkHighContrast"
end

function scheme_for_appearance(appearance)
	if appearance:find("DarkHighContrast") then
		return "Builtin Solarized Dark"
	else
		return "Builtin Solarized Light"
	end
end

config.skip_close_confirmation_for_processes_named = {}

config.mouse_bindings = {
  -- Change the default click behavior so that it only selects
  -- text and doesn't open hyperlinks, and that it populates
  -- the Clipboard rather the PrimarySelection which is part
  -- of the default assignment for a left mouse click.
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'NONE',
    action = wezterm.action.CompleteSelection 'Clipboard',
  },
}

-- keymaps
config.keys = {
	{
		key = "RightArrow",
		mods = "CTRL|ALT",
		action = act.SplitPane({
			direction = "Right",
			size = { Percent = 50 },
		}),
	},
	{
		key = "LeftArrow",
		mods = "CTRL|ALT",
		action = act.SplitPane({
			direction = "Left",
			size = { Percent = 50 },
		}),
	},
	{
		key = "UpArrow",
		mods = "CTRL|ALT",
		action = act.SplitPane({
			direction = "Up",
			size = { Percent = 50 },
		}),
	},
	{
		key = "DownArrow",
		mods = "CTRL|ALT",
		action = act.SplitPane({
			direction = "Down",
			size = { Percent = 50 },
		}),
	},
	{
		key = "k",
		mods = "CTRL|SHIFT",
		action = act.ClearScrollback("ScrollbackAndViewport"),
	},
	{
		key = "LeftArrow",
		mods = "CTRL|SHIFT",
		action = act.AdjustPaneSize({ "Left", 5 }),
	},
	{
		key = "DownArrow",
		mods = "CTRL|SHIFT",
		action = act.AdjustPaneSize({ "Down", 5 }),
	},
	{
		key = "UpArrow",
		mods = "CTRL|SHIFT",
		action = act.AdjustPaneSize({ "Up", 5 }),
	},
	{
		key = "RightArrow",
		mods = "CTRL|SHIFT",
		action = act.AdjustPaneSize({ "Right", 5 }),
	},
	{
		key = "w",
		mods = "CTRL|ALT",
		action = act.CloseCurrentTab({ confirm = false }),
	},
	{
		key = "w",
		mods = "CTRL|SHIFT",
		action = act.CloseCurrentPane({ confirm = false }),
	},
	-- {
	-- 	-- Clears the scrollback and viewport, and then sends CTRL-L to ask the
	-- 	-- shell to redraw its prompt
	-- 	key = 'K',
	-- 	mods = 'CTRL|SHIFT',
	-- 	action = act.Multiple {
	-- 	act.ClearScrollback 'ScrollbackAndViewport',
	-- 	act.SendKey { key = 'L', mods = 'CTRL' },
	-- },
	{ key = "S", mods = "CTRL|SHIFT", action = act.PaneSelect },
	{ key = "L", mods = "CTRL", action = act.ShowDebugOverlay },
	{
		key = "o",
		mods = "CTRL|ALT",
		-- toggling opacity
		action = wezterm.action_callback(function(window, _)
			local overrides = window:get_config_overrides() or {}
			if overrides.window_background_opacity == 1.0 then
				overrides.window_background_opacity = 0.5
			else
				overrides.window_background_opacity = 1.0
			end
			window:set_config_overrides(overrides)
		end),
	},
}

-- config.window_frame = {
-- 	font = wezterm.font({ family = "Ubuntu Mono", weight = "Regular" }),
-- 	active_titlebar_bg = "#0c0b0f",
-- }

-- config.keys = {
-- 	-- CTRL-SHIFT-l activates the debug overlay
-- 	{ key = 'L', mods = 'CTRL', action = wezterm.action.ShowDebugOverlay },
--   }

-- Change the color scheme
-- config.background = {
-- 	{
-- 		source = {
-- 			Color = '#0f1019'
-- 		},
-- 		width = "100%",
-- 		height = "100%",
-- 		opacity = .9
-- 	},
-- }

-- config.colors = {
-- 	-- foreground = '#8f92a0',
-- 	background = '#0f1019',
-- 	selection_fg = '#8f92a0',
-- 	selection_bg = '#1f2131',
-- }

-- Background
-- The art is a bit too bright and colorful to be useful as a backdrop
-- for text, so we're going to dim it down.
-- local dimmer = { brightness = 0.1 }
-- config.background = {
-- 	{
-- 		source = {
-- 			File = wezterm.config_dir .. '/backgrounds/botw_corrupted_nydra_rev.jpg',
-- 		},
-- 		repeat_x = 'NoRepeat',
-- 	repeat_y = 'NoRepeat',
-- 		hsb = dimmer,
-- 	},
-- }
-- config.macos_window_background_blur = 20

-- Center on screen
-- wezterm.on("gui-startup", function(cmd)
-- 	local screen = wezterm.gui.screens().active
-- 	local ratio = 0.7
-- 	local width, height = (screen.width * ratio) / 1.5, (screen.height * ratio) / 1.5
-- 	-- local tab, pane, window = wezterm.mux.spawn_window(cmd or {
-- 	-- 	position = { x = (screen.width) / 2, y = (screen.height) / 2 },
-- 	-- })
-- 	-- -- window:gui_window():maximize()
-- 	-- window:gui_window():set_inner_size(width, height)
-- end)

-- and finally, return the configuration to wezterm
return config

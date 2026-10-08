-- Pull in the wezterm API
local wezterm = require('wezterm')

-- This will hold the configuration.
local config = wezterm.config_builder()

local act = wezterm.action

-- Add the current directory to the package path
local config_dir = wezterm.config_dir or (os.getenv("USERPROFILE") or os.getenv("HOME"))
package.path = package.path .. ";" .. config_dir .. "/?.lua"

local session_manager = require("session-manager")

wezterm.on("save_state", function(window, pane) session_manager.save_state(window, pane) end)
wezterm.on("load_state", function() session_manager.load_state() end)
wezterm.on("restore_state", function(window) session_manager.restore_state(window) end)

wezterm.on("print_info", function(window)
  local mux = wezterm.mux
  local workspace = mux.get_active_workspace()
  local workspace2 = window:active_workspace()
  local windowid = window:window_id()
  wezterm.log_info("Workspace: " .. workspace)
  wezterm.log_info("Workspace option 2: " .. workspace2)
  wezterm.log_info("All Windows: " .. windowid)

  -- local info = string.format(
  --   "Window ID: %d, Tab ID: %d, Pane ID: %d, Workspace: %s",
  --   window:window_id(), tab:tab_id(), pane:pane_id(), workspace:name()
  -- )
  local tabs_info = window:tabs_with_info()
  local tab_details = {}

  for _, tab_info in ipairs(tabs_info) do
    local details = string.format("Tab Index: %d, Is Active: %s, Tab ID: %d",
      tab_info.index,
      tostring(tab_info.is_active),
      tab_info.tab:tab_id())
    table.insert(tab_details, details)
  end

  local tab_details_str = table.concat(tab_details, "; ")
  wezterm.log_info(string.format("Window ID: %d, Tabs Info: [%s]", window:window_id(), tab_details_str))
end)
-- Functions
local get_last_folder_segment = function(cwd)
  if cwd == nil then
    return "N/A" -- or some default value you prefer
  end

  -- Strip off 'file:///' if present
  local pathStripped = cwd:match("^file:///(.+)") or cwd
  -- Normalize backslashes to slashes for Windows paths
  pathStripped = pathStripped:gsub("\\", "/")
  -- Split the path by '/'
  local path = {}
  for segment in string.gmatch(pathStripped, "[^/]+") do
    table.insert(path, segment)
  end
  return path[#path] -- returns the last segment
end

local function get_current_working_dir(tab)
  local current_dir = tab.active_pane.current_working_dir or ''
  return get_last_folder_segment(current_dir)
end

-- local process_icons = {
--   ['docker'] = wezterm.nerdfonts.linux_docker,
--   ['docker-compose'] = wezterm.nerdfonts.linux_docker,
--   ['psql'] = wezterm.nerdfonts.dev_postgresql,
--   ['kuberlr'] = wezterm.nerdfonts.linux_docker,
--   ['kubectl'] = wezterm.nerdfonts.linux_docker,
--   ['stern'] = wezterm.nerdfonts.linux_docker,
--   ['nvim'] = wezterm.nerdfonts.custom_vim,
--   ['make'] = wezterm.nerdfonts.seti_makefile,
--   ['vim'] = wezterm.nerdfonts.dev_vim,
--   ['go'] = wezterm.nerdfonts.seti_go,
--   ['zsh'] = wezterm.nerdfonts.dev_terminal,
--   ['bash'] = wezterm.nerdfonts.cod_terminal_bash,
--   ['btm'] = wezterm.nerdfonts.mdi_chart_donut_variant,
--   ['htop'] = wezterm.nerdfonts.mdi_chart_donut_variant,
--   ['cargo'] = wezterm.nerdfonts.dev_rust,
--   ['sudo'] = wezterm.nerdfonts.fa_hashtag,
--   ['lazydocker'] = wezterm.nerdfonts.linux_docker,
--   ['git'] = wezterm.nerdfonts.dev_git,
--   ['lua'] = wezterm.nerdfonts.seti_lua,
--   ['wget'] = wezterm.nerdfonts.mdi_arrow_down_box,
--   ['curl'] = wezterm.nerdfonts.mdi_flattr,
--   ['gh'] = wezterm.nerdfonts.dev_github_badge,
--   ['ruby'] = wezterm.nerdfonts.cod_ruby,
--   ['pwsh'] = wezterm.nerdfonts.seti_powershell,
--   ['node'] = wezterm.nerdfonts.dev_nodejs_small,
--   ['dotnet'] = wezterm.nerdfonts.md_language_csharp,
-- }

-- local function get_process(tab)
--   local process_name = tab.active_pane.foreground_process_name:match("([^/\\]+)%.exe$") or
--       tab.active_pane.foreground_process_name:match("([^/\\]+)$")

--   local icon = process_icons[process_name] or wezterm.nerdfonts.seti_checkbox_unchecked

--   return icon
-- end

config.font_size = 12.0
config.front_end = 'OpenGL'
config.max_fps = 165
config.default_cursor_style = 'BlinkingBlock'
config.animation_fps = 165
config.cursor_blink_rate = 500
config.term = 'xterm-256color'
config.cell_width = 0.9
config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = true
config.initial_cols = 80
config.default_prog = { 'pwsh.exe', '-nologo' }
config.set_environment_variables = {
    -- SHELL = shell,
}

config.scrollback_lines = 10000

config.alternate_buffer_wheel_scroll_speed = 10

config.enable_scroll_bar = true
config.window_background_opacity = 1 --0.8
config.text_background_opacity = 0.8
config.window_decorations = 'RESIZE'

config.ssh_backend = 'Ssh2'

-- config.multiplexing = "No"

config.window_close_confirmation = 'NeverPrompt'
config.skip_close_confirmation_for_processes_named = {
    'bash',
    'sh',
    'zsh',
    'fish',
    'tmux',
    'nu',
    'cmd.exe',
    'pwsh.exe',
    'powershell.exe',
}

config.launch_menu = {
    {
        -- Optional label to show in the launcher. If omitted, a label
        -- is derived from the `args`
        label = 'Bash',
        -- The argument array to spawn.  If omitted the default program
        -- will be used as described in the documentation above
        args = { 'C:/Program Files/Git/usr/bin/bash.exe', '-l' },

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

function get_appearance()
    if wezterm.gui then
        return wezterm.gui.get_appearance()
    end
    return 'DarkHighContrast'
end

function scheme_for_appearance(appearance)
    if appearance:find('DarkHighContrast') then
        return 'Builtin Solarized Dark'
    else
        return 'Builtin Solarized Light'
    end
end

config.skip_close_confirmation_for_processes_named = {}

-- Use the defaults as a base
-- config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- -- make task numbers clickable
-- -- the first matched regex group is captured in $1.
-- table.insert(config.hyperlink_rules, {
--   regex = [[\b[tt](\d+)\b]],
--   format = 'https://example.com/tasks/?t=$1',
-- })

-- -- make username/project paths clickable. this implies paths like the following are for github.
-- -- ( "nvim-treesitter/nvim-treesitter" | wbthomason/packer.nvim | wezterm/wezterm | "wezterm/wezterm.git" )
-- -- as long as a full url hyperlink regex exists above this it should not match a full url to
-- -- github or gitlab / bitbucket (i.e. https://gitlab.com/user/project.git is still a whole clickable url)
-- table.insert(config.hyperlink_rules, {
--   regex = [[["]?([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)["]?]],
--   format = 'https://www.github.com/$1/$3',
-- })

-- config.mouse_bindings = {
-- 	-- Disable default link opening on plain click
-- 	{
-- 	  event = { Up = { streak = 1, button = "Left" } },
-- 	  mods = "NONE",
-- 	  action = act.Nop,
-- 	},
-- 	-- Allow CTRL+Click to open hyperlinks
-- 	{
-- 	  event = { Up = { streak = 1, button = "Left" } },
-- 	  mods = "CTRL",
-- 	  action = act.OpenLinkAtMouseCursor,
-- 	},
--   }

config.leader = { key = "Space", mods = "SHIFT", timeout_milliseconds = 3000 }

-- keymaps
config.keys = {
    -- Session manager bindings
    {key = "s", mods = "LEADER", action = wezterm.action{EmitEvent = "save_state"}},
    {key = "l", mods = "LEADER", action = wezterm.action{EmitEvent = "load_state"}},
    {key = "r", mods = "LEADER", action = wezterm.action{EmitEvent = "restore_state"}},
    {
        key = 'RightArrow',
        mods = 'CTRL|ALT',
        action = act.SplitPane({
            direction = 'Right',
            size = { Percent = 50 },
        }),
    },
    {
        key = 'LeftArrow',
        mods = 'CTRL|ALT',
        action = act.SplitPane({
            direction = 'Left',
            size = { Percent = 50 },
        }),
    },
    {
        key = 'UpArrow',
        mods = 'CTRL|ALT',
        action = act.SplitPane({
            direction = 'Up',
            size = { Percent = 50 },
        }),
    },
    {
        key = 'DownArrow',
        mods = 'CTRL|ALT',
        action = act.SplitPane({
            direction = 'Down',
            size = { Percent = 50 },
        }),
    },
    {
        key = 'k',
        mods = 'CTRL|SHIFT',
        action = act.ClearScrollback('ScrollbackAndViewport'),
    },
    {
        key = 'LeftArrow',
        mods = 'CTRL|SHIFT',
        action = act.AdjustPaneSize({ 'Left', 5 }),
    },
    {
        key = 'DownArrow',
        mods = 'CTRL|SHIFT',
        action = act.AdjustPaneSize({ 'Down', 5 }),
    },
    {
        key = 'UpArrow',
        mods = 'CTRL|SHIFT',
        action = act.AdjustPaneSize({ 'Up', 5 }),
    },
    {
        key = 'RightArrow',
        mods = 'CTRL|SHIFT',
        action = act.AdjustPaneSize({ 'Right', 5 }),
    },
    {
        key = 'w',
        mods = 'CTRL|ALT',
        action = act.CloseCurrentTab({ confirm = false }),
    },
    {
        key = 'w',
        mods = 'CTRL|SHIFT',
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
    { key = '9', mods = 'CTRL', action = act.PaneSelect },
    { key = 'L', mods = 'CTRL', action = act.ShowDebugOverlay },
    {
        key = 'o',
        mods = 'CTRL|ALT',
        -- toggling opacity
        action = wezterm.action_callback(function(window, _)
            local overrides = window:get_config_overrides() or {}
            if overrides.window_background_opacity == 1.0 then
                overrides.window_background_opacity = 0.8
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

-- What's our shell?
-- local shell = '/opt/homebrew/bin/fish'

-- config.keys = {
-- 	-- CTRL-SHIFT-l activates the debug overlay
-- 	{ key = 'L', mods = 'CTRL', action = wezterm.action.ShowDebugOverlay },
--   }

-- Change the color scheme
-- config.color_scheme = 'Wombat'
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

-- Font
-- config.font = wezterm.font 'MesloLGM Nerd Font Mono'
-- config.window_decorations = "NONE | RESIZE"

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

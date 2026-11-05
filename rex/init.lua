local config_home = os.getenv("XDG_CONFIG_HOME") or (os.getenv("HOME") .. "/.config")
local PREFIX = "ctrl+q"

-- Navigate panes with Vim direction keys.
rex.bind("cmd+alt+h", "pane.focus.left")
rex.bind("cmd+alt+j", "pane.focus.down")
rex.bind("cmd+alt+k", "pane.focus.up")
rex.bind("cmd+alt+l", "pane.focus.right")

-- Press the prefix, release it, then a Vim direction key.
rex.bind(PREFIX .. ">h", "pane.focus.left")
rex.bind(PREFIX .. ">j", "pane.focus.down")
rex.bind(PREFIX .. ">k", "pane.focus.up")
rex.bind(PREFIX .. ">l", "pane.focus.right")

-- Split vertically (side by side) or horizontally (stacked).
rex.bind(PREFIX .. ">v", "pane.split.right")
rex.bind(PREFIX .. ">-", "pane.split.down")

-- Cycle tabs and open the session picker with the same prefix.
rex.bind(PREFIX .. ">" .. PREFIX, "client.tab.next")
rex.bind(PREFIX .. ">s", "session.switch")
rex.bind(PREFIX .. ">z", "pane.zoom")
rex.bind("cmd+shift+r", "session.rename")

-- Run this action from Rex's command palette to import and select the theme.
-- Client actions cannot run automatically while init.lua is loading.
rex.action {
  name = "monokai_machine",
  title = "Use Monokai Pro Machine",
  run = function()
    rex.client.queue("client.theme.import", {
      path = config_home .. "/rex/themes/Monokai Pro Machine",
    })
  end,
}

local config_home = os.getenv("XDG_CONFIG_HOME") or (os.getenv("HOME") .. "/.config")

-- Navigate panes with Vim direction keys.
rex.bind("cmd+alt+h", "pane.focus.left")
rex.bind("cmd+alt+j", "pane.focus.down")
rex.bind("cmd+alt+k", "pane.focus.up")
rex.bind("cmd+alt+l", "pane.focus.right")

-- Press Ctrl-Q, release it, then a Vim direction key.
rex.bind("ctrl+q>h", "pane.focus.left")
rex.bind("ctrl+q>j", "pane.focus.down")
rex.bind("ctrl+q>k", "pane.focus.up")
rex.bind("ctrl+q>l", "pane.focus.right")

-- Cycle tabs and open the session picker with the same prefix.
rex.bind("ctrl+q>ctrl+q", "client.tab.next")
rex.bind("ctrl+q>s", "session.switch")

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

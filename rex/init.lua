local config_home = os.getenv("XDG_CONFIG_HOME") or (os.getenv("HOME") .. "/.config")

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

require("options")
require("keymaps")

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
require("lazy").setup({
	{
		-- Detect tabstop and shiftwidth automatically
		"tpope/vim-sleuth",
	},
	{
		"github/copilot.vim",
	},
	require("plugins.colortheme"), -- needs config and perhaps remove/replace
	require("plugins.neotree"), -- needs config
	require("plugins.bufferline"), -- needs config and perhaps remove/replace
	require("plugins.lualine"),
	require("plugins.treesitter"),
	require("plugins.telescope"),
	require("plugins.lsp"),
	require("plugins.autocomplete"),
	require("plugins.conform"),
	require("plugins.undotree"),
	require("plugins.scm"),
	{ "vuciv/golf" },
	{
		"tzachar/local-highlight.nvim",
		config = function()
			require("local-highlight").setup({
				animate = {
					enabled = false,
				},
			})
		end,
	},
})

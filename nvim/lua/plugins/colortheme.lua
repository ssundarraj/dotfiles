local M = {}

M.plugins = {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("tokyonight").setup({})
			vim.cmd.hi("Comment gui=none")
		end,
	},
	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("kanagawa").setup({})
		end,
	},
	{
		"loctvl842/monokai-pro.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("monokai-pro").setup({
				plugins = {
					bufferline = {
						underline_selected = false,
						underline_visible = false,
					},
				},
				override = function(colors)
					require("monokai-pro.theme.plugins.bufferline").setup_bufferline_icon("DevIconDefault")
					return {
						-- Make winbar bg the same as buffer bg
						WinBar = { fg = colors.base.dimmed1, bg = colors.base.background },
						WinBarNC = { fg = colors.base.dimmed3, bg = colors.base.background },
					}
				end,
			})
		end,
	},
}

M.selected_theme = "monokai-pro"

return M

return {
	"mbbill/undotree",
	event = "VeryLazy",
	config = function()
		vim.keymap.set(
			"n",
			"<leader>u",
			":UndotreeToggle<CR>",
			{ noremap = true, silent = true, desc = "Toggle [U]ndo Tree" }
		)
	end,
}

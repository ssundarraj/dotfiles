return {
	"folke/which-key.nvim",
	event = "VimEnter",
	opts = {
		filter = function(mapping)
			-- Keep Escape-prefixed shortcuts from making Escape a popup trigger.
			local keys = vim.api.nvim_replace_termcodes(mapping.lhs, true, true, true)
			return keys:sub(1, 1) ~= "\27"
		end,
	},
}

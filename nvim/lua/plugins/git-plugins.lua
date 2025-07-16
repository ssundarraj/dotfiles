return {
	{
		"tpope/vim-fugitive",
	},
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
			vim.keymap.set("n", "<leader>gb", ":Gitsigns blame<CR>", { desc = "[G]it [B]lame" })
		end,
	},
	{
		"linrongbin16/gitlinker.nvim",
		cmd = "GitLink",
		opts = {},
		keys = {
			{ "<leader>gy", "<cmd>GitLink<cr>", mode = { "n", "v" }, desc = "Yank git link" },
			{ "<leader>gY", "<cmd>GitLink!<cr>", mode = { "n", "v" }, desc = "Open git link" },
		},
	},
	{
		"sindrets/diffview.nvim",
		dependencies = {
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			require("diffview").setup()

			local pickers = require("telescope.pickers")
			local finders = require("telescope.finders")
			local conf = require("telescope.config").values
			local actions = require("telescope.actions")
			local action_state = require("telescope.actions.state")

			local function git_commits_diffview()
				local handle = io.popen("git log --oneline --pretty=format:'%h %s' HEAD -20")
				local result = handle:read("*a")
				handle:close()

				local commits = {}
				for line in result:gmatch("[^\r\n]+") do
					table.insert(commits, line)
				end

				pickers
					.new({}, {
						prompt_title = "Git Commits (DiffView)",
						finder = finders.new_table({
							results = commits,
						}),
						sorter = conf.generic_sorter({}),
						attach_mappings = function(prompt_bufnr, map)
							actions.select_default:replace(function()
								actions.close(prompt_bufnr)
								local selection = action_state.get_selected_entry()
								if selection then
									local commit_hash = selection.value:match("^(%w+)")
									vim.cmd("DiffviewOpen " .. commit_hash)
								end
							end)
							return true
						end,
					})
					:find()
			end

			vim.keymap.set("n", "<leader>do", ":DiffviewOpen<CR>", { desc = "[D]iff [O]pen" })
			vim.keymap.set("n", "<leader>dc", ":DiffviewClose<CR>", { desc = "[D]iff [C]lose" })
			vim.keymap.set("n", "<leader>dh", ":DiffviewFileHistory<CR>", { desc = "[D]iff [H]istory" })
			vim.keymap.set("n", "<leader>dgc", git_commits_diffview, { desc = "[D]iff [V]iew [C]ommits" })
		end,
	},
}

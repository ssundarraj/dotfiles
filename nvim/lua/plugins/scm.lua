return {
	{
		"tpope/vim-fugitive",
	},
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
			vim.keymap.set("n", "<leader>gb", ":Gitsigns blame<CR>", { desc = "[G]it [B]lame" })
			vim.keymap.set("n", "[h", ":Gitsigns prev_hunk<CR>", { desc = "Prev Hunk" })
			vim.keymap.set("n", "]h", ":Gitsigns next_hunk<CR>", { desc = "Next Hunk" })
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

			local function get_commits()
				local handle = io.popen("git log --oneline --pretty=format:'%h %s' HEAD -100")
				if not handle then
					return {}
				end
				local result = handle:read("*a")
				handle:close()

				local commits = {}
				if result then
					for line in result:gmatch("[^\r\n]+") do
						table.insert(commits, line)
					end
				end
				return commits
			end

			local function git_commits_diffview()
				local commits = get_commits()
				local left_commit = nil

				-- First picker: select left commit
				pickers
					.new({}, {
						prompt_title = "Select LEFT commit",
						finder = finders.new_table({
							results = commits,
						}),
						sorter = conf.generic_sorter({}),
						attach_mappings = function(prompt_bufnr, map)
							actions.select_default:replace(function()
								actions.close(prompt_bufnr)
								local selection = action_state.get_selected_entry()
								if selection then
									left_commit = selection.value:match("^(%w+)")

									-- Second picker: select right commit
									local right_commits = { "Uncommitted changes", unpack(commits) }
									pickers
										.new({}, {
											prompt_title = "Select RIGHT commit (comparing with " .. left_commit .. ")",
											finder = finders.new_table({
												results = right_commits,
											}),
											sorter = conf.generic_sorter({}),
											attach_mappings = function(prompt_bufnr2, map2)
												actions.select_default:replace(function()
													actions.close(prompt_bufnr2)
													local selection2 = action_state.get_selected_entry()
													if selection2 then
														if selection2.value:match("^Uncommitted") then
															vim.cmd("DiffviewOpen " .. left_commit)
														else
															local right_commit = selection2.value:match("^(%w+)")
															vim.cmd(
																"DiffviewOpen " .. left_commit .. ".." .. right_commit
															)
														end
													end
												end)
												return true
											end,
										})
										:find()
								end
							end)
							return true
						end,
					})
					:find()
			end

			local function diff_from_branch_point()
				local result = vim.fn.systemlist("git symbolic-ref --short refs/remotes/origin/HEAD")
				if result and result[1] and not result[1]:match("^fatal:") then
					local default_branch = result[1]:gsub("^origin/", "")
					vim.cmd("DiffviewOpen origin/" .. default_branch .. "...HEAD")
				else
					vim.notify("Could not determine default branch", vim.log.levels.ERROR)
				end
			end

			vim.keymap.set("n", "<leader>do", ":DiffviewOpen<CR>", { desc = "[D]iff [O]pen" })
			vim.keymap.set("n", "<leader>dc", ":DiffviewClose<CR>", { desc = "[D]iff [C]lose" })
			vim.keymap.set("n", "<leader>dh", ":DiffviewFileHistory<CR>", { desc = "[D]iff [H]istory" })
			vim.keymap.set("n", "<leader>dg", git_commits_diffview, { desc = "[D]iff [G]it Commits" })
			vim.keymap.set("n", "<leader>db", diff_from_branch_point, { desc = "[D]iff from [B]ranch point" })
		end,
	},
}

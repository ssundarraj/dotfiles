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
			{ "<leader>gy", "<cmd>GitLink default_branch<cr>", mode = { "n", "v" }, desc = "Yank git link" },
			{ "<leader>gY", "<cmd>GitLink! default_branch<cr>", mode = { "n", "v" }, desc = "Open git link" },
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
			local entry_display = require("telescope.pickers.entry_display")

			local function close_diffview_if_open()
				for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
					local buf = vim.api.nvim_win_get_buf(win)
					local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
					if ft:match("^Diffview") then
						vim.cmd("DiffviewClose")
						return
					end
				end
			end

			local function get_commits()
				local handle = io.popen("git log --decorate=short --pretty=format:'%h%x1f%d%x1f%s' HEAD -100")
				if not handle then
					return {}
				end
				local result = handle:read("*a")
				handle:close()

				local commits = {}
				if result then
					for line in result:gmatch("[^\r\n]+") do
						local sha, refs, subject = line:match("^([^%z\31]+)%z?\31([^%z\31]*)%z?\31(.*)$")
						if sha then
							refs = refs:gsub("^%s+", ""):gsub("%s+$", "")
							if refs == "" then
								refs = nil
							end
							table.insert(commits, {
								sha = sha,
								refs = refs,
								subject = subject,
							})
						end
					end
				end
				return commits
			end

			local commit_displayer = entry_display.create({
				separator = " ",
				items = {
					{ width = 8 },
					{ width = 28 },
					{ remaining = true },
				},
			})

			local function make_uncommitted_entry()
				return {
					value = {
						kind = "uncommitted",
						label = "Uncommitted changes",
					},
					ordinal = "uncommitted changes working tree index",
					display = function(entry)
						return commit_displayer({
							{ "", "TelescopeResultsIdentifier" },
							{ "[working tree]", "TelescopeResultsComment" },
							entry.value.label,
						})
					end,
				}
			end

			local function commits_finder(commits, include_uncommitted)
				local results = {}
				if include_uncommitted then
					table.insert(results, make_uncommitted_entry())
				end
				for _, commit in ipairs(commits) do
					table.insert(results, {
						value = commit,
						ordinal = table.concat({
							commit.sha,
							commit.refs or "",
							commit.subject or "",
						}, " "),
						display = function(entry)
							local value = entry.value
							return commit_displayer({
								{ value.sha, "TelescopeResultsIdentifier" },
								{ value.refs or "", "TelescopeResultsComment" },
								value.subject,
							})
						end,
					})
				end
				return finders.new_table({
					results = results,
					entry_maker = function(entry)
						return entry
					end,
				})
			end

			local function git_commits_diffview()
				local commits = get_commits()
				local left_commit = nil

				-- First picker: select left commit
				pickers
					.new({}, {
						prompt_title = "Select LEFT commit",
						finder = commits_finder(commits, false),
						sorter = conf.generic_sorter({}),
						attach_mappings = function(prompt_bufnr, map)
							actions.select_default:replace(function()
								actions.close(prompt_bufnr)
								local selection = action_state.get_selected_entry()
								if selection then
									left_commit = selection.value.sha

									-- Second picker: select right commit
									pickers
										.new({}, {
											prompt_title = "Select RIGHT commit (comparing with " .. left_commit .. ")",
											finder = commits_finder(commits, true),
											sorter = conf.generic_sorter({}),
											attach_mappings = function(prompt_bufnr2, map2)
												actions.select_default:replace(function()
													actions.close(prompt_bufnr2)
													local selection2 = action_state.get_selected_entry()
													if selection2 then
														if selection2.value.kind == "uncommitted" then
															close_diffview_if_open()
															vim.cmd("DiffviewOpen " .. left_commit)
														else
															local right_commit = selection2.value.sha
															close_diffview_if_open()
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
					vim.cmd("DiffviewOpen origin/" .. default_branch)
				else
					vim.notify("Could not determine default branch", vim.log.levels.ERROR)
				end
			end

			vim.keymap.set("n", "<leader>do", function()
				close_diffview_if_open()
				vim.cmd("DiffviewOpen")
			end, { desc = "[D]iff [O]pen" })
			vim.keymap.set("n", "<leader>dc", ":DiffviewClose<CR>", { desc = "[D]iff [C]lose" })
			vim.keymap.set("n", "<leader>dh", function()
				close_diffview_if_open()
				vim.cmd("DiffviewFileHistory")
			end, { desc = "[D]iff [H]istory" })
			vim.keymap.set("n", "<leader>dg", function()
				git_commits_diffview()
			end, { desc = "[D]iff [G]it Commits" })
			vim.keymap.set("n", "<leader>db", function()
				close_diffview_if_open()
				diff_from_branch_point()
			end, { desc = "[D]iff from [B]ranch point" })
		end,
	},
}

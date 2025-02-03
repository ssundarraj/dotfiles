return { -- Fuzzy Finder (files, lsp, etc)tele
	"nvim-telescope/telescope.nvim",
	event = "VimEnter",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ -- If encountering errors, see telescope-fzf-native README for installation instructions
			"nvim-telescope/telescope-fzf-native.nvim",

			-- `build` is used to run some command when the plugin is installed/updated.
			-- This is only run then, not every time Neovim starts up.
			build = "make",

			-- `cond` is a condition used to determine whether this plugin should be
			-- installed and loaded.
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},
		{ "nvim-telescope/telescope-ui-select.nvim" },
		{ "nvim-telescope/telescope-symbols.nvim" },

		-- Useful for getting pretty icons, but requires a Nerd Font.
		{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
	},
	config = function()
		-- Telescope is a fuzzy finder that comes with a lot of different things that
		-- it can fuzzy find! It's more than just a "file finder", it can search
		-- many different aspects of Neovim, your workspace, LSP, and more!
		--
		-- The easiest way to use Telescope, is to start by doing something like:
		--  :Telescope help_tags
		--
		-- After running this command, a window will open up and you're able to
		-- type in the prompt window. You'll see a list of `help_tags` options and
		-- a corresponding preview of the help.
		--
		-- Two important keymaps to use while in Telescope are:
		--  - Insert mode: <c-/>
		--  - Normal mode: ?
		--
		-- This opens a window that shows you all of the keymaps for the current
		-- Telescope picker. This is really useful to discover what Telescope can
		-- do as well as how to actually do it!

		-- [[ Configure Telescope ]]
		-- See `:help telescope` and `:help telescope.setup()`
		require("telescope").setup({
			-- You can put your default mappings / updates / etc. in here
			--  All the info you're looking for is in `:help telescope.setup()`
			--
			defaults = {
				path_display = { "smart" },
				layout_config = {
					horizontal = {
						width = { padding = 5 },
						height = { padding = 5 },
					},
				},
				mappings = {
					i = {
						["<C-enter>"] = "to_fuzzy_refine",
						["<C-j>"] = "move_selection_next",
						["<C-k>"] = "move_selection_previous",
						["<C-f>"] = "send_to_qflist",
					},
				},
			},
			pickers = {
				find_files = {
					file_ignore_patterns = { "node_modules", ".git", ".venv" },
					hidden = true,
				},
			},
			live_grep = {
				file_ignore_patterns = { "node_modules", ".git", ".venv" },
				additional_args = function(_)
					return { "--hidden" }
				end,
			},
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown(),
				},
			},
		})

		-- Enable Telescope extensions if they are installed
		pcall(require("telescope").load_extension, "fzf")
		pcall(require("telescope").load_extension, "ui-select")

		local pickers = require("telescope.pickers")
		local finders = require("telescope.finders")
		local conf = require("telescope.config").values
		local previewers = require("telescope.previewers")
		local from_entry = require("telescope.from_entry")
		local putils = require("telescope.previewers.utils")

		local function project_files()
			local success = pcall(require("telescope.builtin").git_files)
			if not success then
				require("telescope.builtin").find_files()
			end
		end

		local branch_diff = function(opts)
			return previewers.new_buffer_previewer({
				title = "Git Branch Diff Preview",
				get_buffer_by_name = function(_, entry)
					return entry.value
				end,

				define_preview = function(self, entry, _)
					local file_name = entry.value
					local get_git_status_command = "git status -s -- " .. file_name
					local git_status = io.popen(get_git_status_command):read("*a")
					local git_status_short = string.sub(git_status, 1, 1)
					if git_status_short ~= "" then
						local p = from_entry.path(entry, true)
						if p == nil or p == "" then
							return
						end
						conf.buffer_previewer_maker(p, self.state.bufnr, {
							bufname = self.state.bufname,
							winid = self.state.winid,
						})
					else
						putils.job_maker(
							{ "git", "--no-pager", "diff", opts.base_branch .. "..HEAD", "--", file_name },
							self.state.bufnr,
							{
								value = file_name,
								bufname = self.state.bufname,
							}
						)
						putils.regex_highlighter(self.state.bufnr, "diff")
					end
				end,
			})
		end

		local changed_files = function()
			local command = "git diff --name-only origin/dev...HEAD"
			pickers
				.new({}, {
					prompt_title = "Changed Files",
					finder = finders.new_oneshot_job(vim.split(command, " ")),
					previewer = branch_diff({ base_branch = "origin/dev" }),
					-- previewer = previewers.new_termopen_previewer({
					-- 	get_command = function(entry)
					-- 		return {
					-- 			"git",
					-- 			"-c",
					-- 			"core.pager=delta",
					-- 			"-c",
					-- 			"delta.side-by-side=false",
					-- 			"diff",
					-- 			entry.value,
					-- 		}
					-- 	end,
					-- }),
					sorter = conf.file_sorter({}),
				})
				:find()
		end

		-- See `:help telescope.builtin`
		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
		vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
		vim.keymap.set("n", "<leader>sf", project_files, { desc = "[S]earch [F]iles" })
		vim.keymap.set("n", "<leader>st", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
		vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
		vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
		vim.keymap.set("n", "<leader>sGS", builtin.git_status, { desc = "[S]earch [G]it [S]tatus" })
		vim.keymap.set("n", "<leader>scf", changed_files, { desc = "[S]earch [C]hanged [F]iles" })
		vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
		vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
		vim.keymap.set("n", "<leader>so", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
		vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
		vim.keymap.set("n", "<leader>gsw", builtin.git_branches, { desc = "[G]it [Sw]itch" })

		-- Slightly advanced example of overriding default behavior and theme
		vim.keymap.set("n", "<leader>/", function()
			-- You can pass additional configuration to Telescope to change the theme, layout, etc.
			builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
				winblend = 10,
				previewer = false,
			}))
		end, { desc = "[/] Fuzzily search in current buffer" })

		-- It's also possible to pass additional configuration options.
		--  See `:help telescope.builtin.live_grep()` for information about particular keys
		vim.keymap.set("n", "<leader>s/", function()
			builtin.live_grep({
				grep_open_files = true,
				prompt_title = "Live Grep in Open Files",
			})
		end, { desc = "[S]earch [/] in Open Files" })

		-- Shortcut for searching your Neovim configuration files
		vim.keymap.set("n", "<leader>sn", function()
			builtin.find_files({ cwd = vim.fn.stdpath("config") })
		end, { desc = "[S]earch [N]eovim files" })
	end,
}

vim.opt.number = true -- Make line numbers default (default: false)
vim.opt.relativenumber = true -- Set relative numbered lines (default: false)

-- vim.opt.clipboard = 'unnamedplus' -- Sync clipboard between OS and Neovim. (default: '')

vim.opt.wrap = false -- Display lines as one long line (default: true)
vim.opt.linebreak = true -- Companion to wrap, don't split words (default: false)

vim.opt.mouse = "a" -- Enable mouse mode (default: '')

vim.opt.autoindent = true -- Copy indent from current line when starting new one (default: true)

vim.opt.ignorecase = true -- Case-insensitive searching UNLESS \C or capital in search (default: false)
vim.opt.smartcase = true -- Smart case (default: false)

vim.o.tabstop = 2 -- Insert n spaces for a tab (default: 8)
vim.o.softtabstop = 2 -- Number of spaces that a tab counts for while performing editing operations (default: 0)
vim.opt.expandtab = true -- Convert tabs to spaces (default: false)

vim.o.splitbelow = true -- Force all horizontal splits to go below current window (default: false)
vim.o.splitright = true -- Force all vertical splits to go to the right of current window (default: false)

vim.o.scrolloff = 4 -- Minimal number of screen lines to keep above and below the cursor (default: 0)

vim.o.winbar = "%f"

-- recommended for auto-session
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

vim.o.cursorline = true -- Highlight the screen line of the cursor with CursorLine (default: false)

-- treesitter folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false -- Don't fold by default

-- matching more stuff with %
vim.opt.matchpairs:append("<:>")

-- show sign column
vim.opt.signcolumn = "yes"

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.g.have_nerd_font = true


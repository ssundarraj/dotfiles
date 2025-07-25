-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable the spacebar key's default behavior in Normal and Visual modes
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- For conciseness
local opts = { noremap = true, silent = true }

-- save with ctrl s
vim.keymap.set("n", "<C-s>", "<cmd> w <CR>", opts)

-- Window management
vim.keymap.set("n", "<leader>v", "<C-w>v", opts) -- split window vertically
vim.keymap.set("n", "<leader>h", "<C-w>s", opts) -- split window horizontally
vim.keymap.set("n", "<leader>se", "<C-w>=", opts) -- make split windows equal width & height
vim.keymap.set("n", "<leader>sm", "<C-w>|", opts) -- maximize vertical split window
vim.keymap.set("n", "<leader>xs", ":close<CR>", opts) -- close current split window

-- Navigate between splits
vim.keymap.set("n", "<C-k>", ":wincmd k<CR>", opts)
vim.keymap.set("n", "<C-j>", ":wincmd j<CR>", opts)
vim.keymap.set("n", "<C-h>", ":wincmd h<CR>", opts)
vim.keymap.set("n", "<C-l>", ":wincmd l<CR>", opts)

-- Tabs
vim.keymap.set("n", "<leader>to", ":tabnew<CR>", opts) -- open new tab
vim.keymap.set("n", "<leader>tc", ":tabclose<CR>", opts) -- close current tab
vim.keymap.set("n", "<leader>ts", ":tab split<CR>", opts) -- split current buffer into new tab

-- Toggle line wrapping
vim.keymap.set("n", "<leader>lw", "<cmd>set wrap!<CR>", opts)

-- Stay in indent mode when indenting
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

-- Keep last yanked when pasting
vim.keymap.set("v", "p", '"_dP', opts)
-- leader + y to copy to system clipboard
vim.keymap.set({ "n", "v" }, "y", '"+y', opts)

-- Resize with arrows
vim.keymap.set("n", "<Up>", ":resize -2<CR>", opts)
vim.keymap.set("n", "<Down>", ":resize +2<CR>", opts)
vim.keymap.set("n", "<Left>", ":vertical resize -2<CR>", opts)
vim.keymap.set("n", "<Right>", ":vertical resize +2<CR>", opts)

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

vim.keymap.set("n", "<leader>fp", function()
	local relative_path = vim.fn.fnamemodify(vim.fn.expand("%"), ":.")
	vim.fn.setreg("+", relative_path)
	vim.notify("Copied: " .. relative_path)
end, { desc = "Copy [F]ile [P]ath" })

if vim.fn.has("mac") == 1 then
	vim.api.nvim_set_keymap("n", "<Esc><BS>", "db", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("i", "<Esc><BS>", "<C-o>db", { noremap = true, silent = true })
end

-- Refresh all buffers
vim.keymap.set("n", "<leader>r", function()
	vim.cmd("bufdo e!")
	vim.notify("All buffers refreshed")
end, { desc = "Refresh all buffers" })

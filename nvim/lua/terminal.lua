local terminal_bufnr
local terminal_layout = "horizontal"

local function find_terminal_window()
	for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
		if vim.api.nvim_win_get_buf(win) == terminal_bufnr then
			return win
		end
	end
end

local function open_terminal(layout)
	local terminal_win = find_terminal_window()
	if terminal_win then
		vim.api.nvim_win_close(terminal_win, true)
	end

	local is_vertical = layout == "vertical"
	vim.cmd(is_vertical and "botright 80vsplit" or "botright 15split")
	if terminal_bufnr and vim.api.nvim_buf_is_valid(terminal_bufnr) then
		vim.api.nvim_win_set_buf(0, terminal_bufnr)
	else
		vim.cmd("terminal")
		terminal_bufnr = vim.api.nvim_get_current_buf()
		vim.bo[terminal_bufnr].bufhidden = "hide"
	end

	vim.wo.winfixheight = not is_vertical
	vim.wo.winfixwidth = is_vertical
	vim.cmd("startinsert")
	terminal_layout = layout
end

vim.keymap.set("n", "<leader>tt", function()
	local terminal_win = find_terminal_window()
	if terminal_win then
		vim.api.nvim_win_close(terminal_win, true)
	else
		open_terminal(terminal_layout)
	end
end, { desc = "[T]oggle [T]erminal" })

vim.keymap.set("n", "<leader>th", function()
	open_terminal("horizontal")
end, { desc = "[T]erminal [H]orizontal" })

vim.keymap.set("n", "<leader>tv", function()
	open_terminal("vertical")
end, { desc = "[T]erminal [V]ertical" })

vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]], { desc = "Leave terminal mode" })

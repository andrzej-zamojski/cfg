vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.cmd.expandtab = true	-- use spaces instead of tabs
vim.cmd.tabstop = 2 		-- size of an indent
vim.cmd.softtabstop = 2		-- tak key results in 4 spaces
vim.cmd.shiftwidth = 2		-- real tabs (if any) look like 4 spaces

vim.opt.nu = true

-- REQUIRED: Tell the original copilot.vim plugin NOT to map <Tab> globally.
vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true

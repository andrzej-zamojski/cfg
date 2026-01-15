vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.opt.nu = true

-- REQUIRED: Tell the original copilot.vim plugin NOT to map <Tab> globally.
vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true

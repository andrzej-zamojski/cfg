return {
	{
		'nvim-telescope/telescope.nvim',
		tag = '0.1.5',
		dependencies = { 'nvim-lua/plenary.nvim' },
		config = function()
			local builtin = require("telescope.builtin")
			vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
			vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
			vim.keymap.set('n', '<C-p>', builtin.git_files, { desc = 'Telescope find files' })
			vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
			vim.keymap.set('n', '<leader>gw', builtin.grep_string,
				{ desc = 'Telescope grep word under cursor' })
			vim.keymap.set('n', '<leader>ps', function()
				builtin.grep_string({ search = vim.fn.input("Grep > ") });
			end)
		end
	},
	{
		'nvim-telescope/telescope-ui-select.nvim',
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown {
							-- even more opts
						}
					}
				},
				defaults = {
					preview = {
						treesitter = false, -- this disables treesitter in the previewer only and use regex highligher
					},
				},
			})
			-- To get ui-select loaded and working with telescope, you need to call
			-- load_extension, somewhere after setup function:
			require("telescope").load_extension("ui-select") -- This is
		end
	}
}

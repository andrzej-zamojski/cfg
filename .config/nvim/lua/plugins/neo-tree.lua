return {
	"nvim-neo-tree/neo-tree.nvim",
	enabled = false,
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	opts = {
		filesystem = {
			filtered_items = {
				visible = true,
				hide_dotfiles = false,
				hide_gitignored = false,
				always_show = {
					".gitignore",
				},
			},
		},
		follow_current_file = {
			enabled = true,
		}
	},
	config = function(_, opts)
		require("neo-tree").setup(opts)

		--vim.keymap.set('n', '<C-n>', ':Neotree filesystem reveal left<CR>', {})
		vim.keymap.set('n', '<C-n>', ':Neotree toggle<CR>', {})
	end
}

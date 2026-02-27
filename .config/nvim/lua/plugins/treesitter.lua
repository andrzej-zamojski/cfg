return {
	"nvim-treesitter/nvim-treesitter",
	version = false,
	build = ":TSUpdate",
	lazy = false, -- Disable lazy loading to ensure Telescope can find it
	init = function()
		-- This restores the missing function Telescope is looking for
		-- We do it in 'init' so it's available as soon as Neovim starts
		if not vim.treesitter.ft_to_lang then
			vim.treesitter.ft_to_lang = function(ft)
				local success, result = pcall(function()
					return vim.treesitter.language.get_lang(ft)
				end)
				return success and result or ft
			end
		end
	end,
	opts = {
		highlight = { enable = true },
		indent = { enable = true },
		ensure_installed = { "lua", "vim", "vimdoc", "python", "markdown", "clangd" },
	},
	config = function(_, opts)
		-- Use pcall because 'nvim-treesitter.configs' is deprecated/renamed in some versions
		local ok, configs = pcall(require, "nvim-treesitter.configs")
		if ok then
			configs.setup(opts)
		end
	end,
}

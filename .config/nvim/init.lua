-- FORCE the missing function into the global treesitter table
table.insert(package.searchers or {}, 1, function(name)
	if name == "nvim-treesitter.configs" then
		return function() end
	end
end)

-- This is the specific fix for the Telescope error
vim.api.nvim_create_autocmd("User", {
	pattern = "VeryLazy",
	callback = function()
		function vim.treesitter.ft_to_lang(ft)
			return vim.treesitter.language.get_lang(ft) or ft
		end
	end,
})

-- 1. Fix the missing function globally
_G.vim.treesitter.ft_to_lang = function(ft)
	if not ft then return end
	local lang = vim.treesitter.language.get_lang(ft)
	return lang or ft
end

-- 2. Your existing lazy.nvim startup follows...
require("config.lazy")
require("vim-options")

vim.g.clipboard = {
	name = 'OSC 52',
	copy = {
		['+'] = require('vim.ui.clipboard.osc52').copy('+'),
		['*'] = require('vim.ui.clipboard.osc52').copy('*'),
	},
	paste = {
		['+'] = require('vim.ui.clipboard.osc52').paste('+'),
		['*'] = require('vim.ui.clipboard.osc52').paste('*'),
	},
}

vim.opt.clipboard = "unnamedplus"

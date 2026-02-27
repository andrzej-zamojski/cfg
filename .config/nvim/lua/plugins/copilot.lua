return {
	{
		enabled = true,
		"github/copilot.vim"
	},
	{
		enabled = true,
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim"
		},
		branch = "main",
		config = function()
			local cc = require('CopilotChat')
			local select = require('CopilotChat.select')

			cc.setup({
				--        model = 'gpt-4',
				window = {
					width = 0.4,
					--          height = 0.5,
					--          auto_follow_cursor = true
				},
			})

			-- interactive mode section
			--      vim.keymap.set('i', '<Tab>', '<Cmd>CopilotChatAccept<CR>') -- <Tab>
			vim.keymap.set('i', '<leader>cqa', function()
				local input = vim.fn.input("Copilot ask: ")
				if input ~= "" then
					cc.ask(input, { selection = select.buffer })
				end
			end
			)
			vim.keymap.set('i', '<leader>cf', '<cmd>CopilotChatFix<CR>')

			-- normal mode section
			vim.keymap.set('n', '<leader>cc', '<Cmd>CopilotChatToggle<CR>',
				{ desc = "Toggle Copilot chat window" })

			vim.keymap.set('n', '<leader>cf', '<Cmd>CopilotChatFix<CR>',
				{ desc = "Fix/refactor based on diagnostics" })

			-- visual mode section
			vim.keymap.set('v', '<leader>ce', function()
				cc.ask("Explain the selected code.", { selection = select.visual })
			end
			)

			vim.keymap.set('v', '<leader>cr', function()
				cc.ask("Review the selected code for improvements.", { selection = select.visual })
			end
			)

			vim.keymap.set('v', '<leader>ct', function()
				cc.ask("Generate unit tests for the selected code..", { selection = select.visual })
			end
			)

			vim.keymap.set('v', '<leader>cd', function()
				cc.ask("Generate a docstring/documentation for the selected code",
					{ selection = select.visual })
			end
			)
		end
	}
}

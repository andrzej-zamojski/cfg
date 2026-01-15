-- Add this helper function at the top of your config function
local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

return {
  {
    "hrsh7th/cmp-nvim-lsp"
  },
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      'saadparwaiz1/cmp_luasnip',
      'rafamadriz/friendly-snippets'
    },
  },
  {
    "hrsh7th/nvim-cmp",
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      local cmp_select = {behavior = cmp.SelectBehavior.Select}
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' }
        }),
        mapping = {
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<Up>'] = cmp.mapping.select_prev_item(cmp_select),
          ['<Down>'] = cmp.mapping.select_next_item(cmp_select),
          ['<Enter>'] = cmp.mapping.confirm({ select = true }),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<Tab>'] = cmp.mapping(function(fallback)
            -- 1. Get the keys for accepting the Copilot suggestion
--            local copilot_keys = vim.fn["copilot#Accept"]()

            if cmp.visible() then
              -- A. If the nvim-cmp menu is visible, navigate to the next item
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              -- B. If a snippet is expandable, expand it (requires luasnip)
              luasnip.expand_or_jump()
	    elseif has_words_before() then
	      local copilot_keys = vim.fn["copilot#Accept"]()
              if copilot_keys ~= "" and type(copilot_keys) == "string" then
                -- C. If Copilot has a ghost suggestion, accept it
                vim.api.nvim_feedkeys(copilot_keys, 'i', true)
	      else
	        cmp.complete()
	      end

--            elseif copilot_keys ~= "" and type(copilot_keys) == "string" then
              -- C. If Copilot has a ghost suggestion, accept it
--              vim.api.nvim_feedkeys(copilot_keys, 'i', true)
            else
              -- D. Fallback: insert a literal <Tab> or whatever your editor default is
              fallback()
            end
          end, { 'i', 's' }),
          ['Esc'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.close()
            else
              fallback()
            end
          end, { 'i', 's' }),
        },

        --required for LuaSnip to work with nvim-cmp.
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        }
      })
    end
  }
}

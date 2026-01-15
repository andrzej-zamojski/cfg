local on_attach = function(_, _)
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, {})
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {})
  vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, {})
  
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
  vim.keymap.set({'n', 'v'}, '<leader>ca', vim.lsp.buf.code_action,
    { desc = "[C]ode [A]ction" })
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = "[R]ename" })
end

vim.diagnostic.config({
  update_in_insert = false,
  float = {
    border = 'rounded',
    max_width = 80,
    win = {
      wrap = true,
      foldenable = false,
      cursorline = false,

      filetype = 'NvimDiagnostic',
    },
    source = 'always',
  },
  virtual_text = true,
  signs = true,
})

-- To use cmp-nvim_lsp as source for snippets
local cmp_nvim_lsp_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if cmp_nvim_lsp_ok then
    -- ⭐️ Apply completion capabilities globally to ALL language servers.
    -- The '*' server name ensures these capabilities are merged into every config.
    vim.lsp.config('*', {
        capabilities = cmp_nvim_lsp.default_capabilities(),
    })
end

return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup()
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls", "clangd", 'pyright', 'gopls' }
      })
    end
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      vim.lsp.config('gopls',
        {
          on_attach = on_attach,
          settings = {
            gopls = {
              usePlaceholders = true,
--              analyses = {
--                unusedparams = true,
--              },
              staticcheck = true,
              gofumpt = true, -- for formatting
            },
          },
        }
      )
      vim.lsp.enable('gopls')

      vim.lsp.config('pyright', { on_attach = on_attach } )
      vim.lsp.enable('pyright')

      vim.lsp.config('lua_ls', { on_attach = on_attach })
      vim.lsp.enable('lua_ls')

      vim.lsp.config('clangd', { on_attach = on_attach } )
      vim.lsp.enable('clangd')
    end
  }
}

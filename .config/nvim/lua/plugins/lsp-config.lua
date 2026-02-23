local on_attach = function(client, bufnr)
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, {})
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {})
  vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, {})
  --  vim.keymap.set('n', 'gr', vim.lsp.buf.references, {})

  vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
  vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action,
    { desc = "[C]ode [A]ction" })
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = "[R]ename" })

  -- create an autocommand to format on save
  if client.supports_method("textDocument/formatting") then
    -- Create a unique group so we don't duplicate commands
    local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = false })

    -- Clear existing autocmds for THIS buffer only before creating a new one
    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = augroup,
      buffer = bufnr,
      callback = function()
        -- This is where we call formatting
        vim.lsp.buf.format({
          bufnr = bufnr,
          -- To format ONLY changed lines, clangd needs the range.
          -- Using 'conform.nvim' is better for "changed lines only",
          -- but for standard "Format File", use this:
          filter = function(c) return c.name == "clangd" end
        })
      end,
    })
  end
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
    "stevearc/conform.nvim", -- used to format changed lines on save
    opts = {
      formatters_by_ft = {
        cpp = { "clang-format" },
        c = { "clang-format" },
        lua = { "stylua" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      }
    },
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
      --				vim.lsp.enable('gopls')

      vim.lsp.config('pyright', { on_attach = on_attach })
      vim.lsp.enable('pyright')

      vim.lsp.config('lua_ls', { on_attach = on_attach })
      vim.lsp.enable('lua_ls')

      vim.lsp.config('clangd',
        {
          on_attach = on_attach,
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy", -- enables .clang-tidy integration
            "--completion-style=detailed",
            "--header-insertion=never",
            "--function-arg-placeholders",
            "--fallback-style=llvm",
            "--query-driver=/usr/bin/g++,/usr/bin/clang++,/usr/bin/gcc,/usr/bin/clang"
          }
        })
      vim.lsp.enable('clangd')

      -- Format visual selection
      vim.keymap.set('v', '<leader>f', function()
        vim.lsp.buf.format({
          range = {
            ["start"] = vim.api.nvim_buf_get_mark(0, "<"),
            ["end"] = vim.api.nvim_buf_get_mark(0, ">"),
          }
        })
      end, { desc = "Format selection" }) -- Format visual selection
    end
  }
}

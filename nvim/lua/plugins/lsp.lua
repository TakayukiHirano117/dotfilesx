return {
  { "mason-org/mason.nvim", opts = {} },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig", "saghen/blink.cmp" },
    config = function()
      vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities() })
      vim.lsp.config("lua_ls", { settings = { Lua = { diagnostics = { globals = { "vim" } } } } })
      require("mason-lspconfig").setup({
        ensure_installed = { "gopls", "ruby_lsp", "ts_ls", "lua_ls" },
        automatic_enable = true,
      })
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("user_lsp", { clear = true }),
        callback = function(ev)
          local o = { buffer = ev.buf, silent = true }
          local m = vim.keymap.set
          m("n", "gd", vim.lsp.buf.definition, o)
          m("n", "gy", vim.lsp.buf.type_definition, o)
          m("n", "gi", vim.lsp.buf.implementation, o)
          m("n", "gr", vim.lsp.buf.references, o)
          m("n", "K", vim.lsp.buf.hover, o)
          m("n", "gh", vim.lsp.buf.hover, o)
          m("n", "[g", function() vim.diagnostic.jump({ count = -1, float = true }) end, o)
          m("n", "]g", function() vim.diagnostic.jump({ count = 1, float = true }) end, o)
          m("n", "<leader>a", vim.lsp.buf.code_action, o)
          m("n", "<leader>r", vim.lsp.buf.rename, o)
        end,
      })
    end,
  },
  {
    "saghen/blink.cmp", version = "1.*",
    opts = {
      keymap = { preset = "default" },
      sources = { default = { "lsp", "path", "snippets", "buffer" } },
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
  },
}

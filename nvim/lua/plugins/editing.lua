return {
  { "tpope/vim-surround" },
  { "tpope/vim-commentary" },
  { "mg979/vim-visual-multi" },
  { "Wansmer/treesj", opts = {} },
  { "matze/vim-move", init = function() vim.g.move_key_modifier = "M" end },
  { "christoomey/vim-tmux-navigator" },
  { "tpope/vim-rails" },
  { "ixru/nvim-markdown" },
  {
    "simeji/winresizer",
    init = function()
      vim.g.winresizer_enable = 1
      vim.g.winresizer_start_key = "<leader>w"
      vim.g.winresizer_vert_resize = 5
      vim.g.winresizer_horiz_resize = 2
      vim.g.winresizer_finish_with_escape = 1
    end,
  },
  {
    "ntpeters/vim-better-whitespace", lazy = false,
    init = function()
      vim.g.better_whitespace_enabled = 1
      vim.g.strip_whitespace_on_save = 0
      vim.g.strip_whitespace_confirm = 0
      vim.g.strip_only_modified_lines = 1
      vim.g.strip_whitelines_at_eof = 0
      vim.g.better_whitespace_operator = ""
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("better_whitespace_config", { clear = true }),
        pattern = { "ruby", "eruby", "javascript", "typescript", "json", "yaml" },
        command = "EnableStripWhitespaceOnSave",
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter", branch = "main", lazy = false, build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")
      ts.setup({})
      local want = { "go", "ruby", "javascript", "typescript", "html", "css", "json", "yaml", "lua", "vim", "markdown" }
      -- パーサーのビルドには tree-sitter CLI が必要（brew install tree-sitter-cli）
      if vim.fn.executable("tree-sitter") == 1 then pcall(ts.install, want) end
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("ts_start", { clear = true }),
        callback = function(ev)
          if pcall(vim.treesitter.start, ev.buf) then
            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
}

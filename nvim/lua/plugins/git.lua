return {
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      on_attach = function(buf)
        local gs = require("gitsigns")
        local o = { buffer = buf, silent = true }
        vim.keymap.set("n", "g[", function() gs.nav_hunk("prev") end, o)
        vim.keymap.set("n", "g]", function() gs.nav_hunk("next") end, o)
        vim.keymap.set("n", "gp", gs.preview_hunk, o)
      end,
    },
  },
  -- 以前は ~/.config/nvim/pack/tpope 経由で読み込んでいたもの
  { "tpope/vim-fugitive" },
}

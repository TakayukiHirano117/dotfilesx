return {
  {
    "navarasu/onedark.nvim", lazy = false, priority = 1000,
    config = function()
      -- Atom One Dark（Cursor の workbench.colorTheme）に合わせる。
      require("onedark").setup({
        style = "dark",
        highlights = {
          Cursor = { fg = "#528BFF", bg = "#528BFF", fmt = "none" },
          lCursor = { fg = "#528BFF", bg = "#528BFF", fmt = "none" },
          CursorLine = { bg = "#24394F" },
          CursorLineNr = { fg = "#ABB2BF", fmt = "bold" },
          Visual = { bg = "#3E4451" },
          SignColumn = { bg = "#282C34" },
          BookmarkSign = { fg = "#E6C384", bg = "#282C34", fmt = "bold" },
          BookmarkAnnotationSign = { fg = "#7FB4CA", bg = "#282C34", fmt = "bold" },
          CurrentWord = { fg = "none", bg = "#264F78", fmt = "bold,underline" },
          CurrentWordTwins = { fg = "none", bg = "#30363D", fmt = "underline" },
          ExtraWhitespace = { bg = "#D16969" },
          ["@markup.list.unchecked"] = { fg = "#E86671", fmt = "none" },
          ["@markup.list.checked"] = { fg = "#98C379", fmt = "none" },
        },
      })
      require("onedark").load()
    end,
  },
  { "nvim-tree/nvim-web-devicons", lazy = true },
  { "MunifTanjim/nui.nvim", lazy = true },
  { "nvim-lua/plenary.nvim", lazy = true },
  { "rcarriga/nvim-notify", opts = { background_colour = "#282C34" } },
  {
    "folke/noice.nvim", event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
    opts = { routes = { { filter = { event = "msg_show", find = "written" }, opts = { skip = true } } } },
  },
  {
    "lukas-reineke/indent-blankline.nvim", main = "ibl",
    opts = { indent = { char = "┆", tab_char = "┆" }, scope = { enabled = false } },
  },
  {
    "goolord/alpha-nvim", lazy = false,
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")
      dashboard.section.header.opts.position = "center"
      dashboard.section.buttons.val = {
        dashboard.button("e", "  New File", ":ene <BAR> startinsert<CR>"),
        dashboard.button("f", "󰈞  Find File", ":Telescope find_files<CR>"),
        dashboard.button("r", "  Recent Files", ":Telescope oldfiles<CR>"),
        dashboard.button("q", "  Quit", ":qa<CR>"),
      }
      dashboard.section.buttons.opts.position = "center"
      dashboard.section.footer.val = "Happy hacking!"
      dashboard.section.footer.opts.position = "center"
      dashboard.config.layout = {
        { type = "padding", val = 6 }, dashboard.section.header,
        { type = "padding", val = 2 }, dashboard.section.buttons,
        { type = "padding", val = 2 }, dashboard.section.footer,
      }
      alpha.setup(dashboard.opts)
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    opts = {
      view = { width = 35, side = "left" },
      renderer = { group_empty = true },
      filters = { dotfiles = false },
      git = { enable = true, ignore = false },
      actions = { open_file = { quit_on_open = false } },
    },
  },
  {
    "nvim-telescope/telescope.nvim", cmd = "Telescope",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { defaults = { initial_mode = "insert", file_ignore_patterns = { "node_modules", ".git" } } },
  },
  {
    "akinsho/bufferline.nvim",
    opts = { options = {
      numbers = "ordinal", indicator = { style = "underline" }, show_close_icon = false,
      always_show_bufferline = true, separator_style = "thin",
      offsets = { { filetype = "NvimTree", text = "File Explorer", highlight = "Directory", separator = true } },
    } },
  },
  {
    "HiPhish/rainbow-delimiters.nvim",
    init = function()
      vim.g.rainbow_delimiters = { highlight = {
        "RainbowDelimiterRed", "RainbowDelimiterYellow", "RainbowDelimiterBlue", "RainbowDelimiterOrange",
        "RainbowDelimiterGreen", "RainbowDelimiterViolet", "RainbowDelimiterCyan" } }
    end,
  },
  {
    "akinsho/toggleterm.nvim", version = "*",
    config = function()
      require("toggleterm").setup({
        direction = "horizontal", size = 15, start_in_insert = true, persist_size = true, close_on_exit = false,
        winbar = { enabled = true, name_formatter = function(term) return " Terminal " .. term.id .. " " end },
      })
      function _G.split_new_terminal()
        local next_id = 1
        for _, term in pairs(require("toggleterm.terminal").get_all()) do
          if term.id >= next_id then next_id = term.id + 1 end
        end
        vim.cmd(next_id .. "ToggleTerm")
      end
    end,
  },
  { "stevearc/aerial.nvim", opts = {} },
  { "lambdalisue/nerdfont.vim" },
  { "lambdalisue/glyph-palette.vim" },
  { "psliwka/vim-smoothie" },
  { "machakann/vim-highlightedyank" },
  {
    "dominikduda/vim_current_word",
    init = function()
      vim.g["vim_current_word#enabled"] = 1
      vim.g["vim_current_word#highlight_current_word"] = 1
      vim.g["vim_current_word#highlight_twins"] = 1
      vim.g["vim_current_word#highlight_delay"] = 150
      vim.g["vim_current_word#highlight_only_in_focused_window"] = 1
      vim.g["vim_current_word#excluded_filetypes"] = { "NvimTree", "TelescopePrompt", "alpha", "help", "noice" }
    end,
  },
  {
    "MattesGroeger/vim-bookmarks",
    init = function()
      vim.g.bookmark_sign = "●"
      vim.g.bookmark_annotation_sign = "◆"
    end,
  },
}

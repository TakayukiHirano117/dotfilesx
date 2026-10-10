-- Neovim 設定（lazy.nvim + ネイティブLSP）
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- lazy.nvim bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({ { "Failed to clone lazy.nvim:\n", "ErrorMsg" }, { out, "WarningMsg" } }, true, {})
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

if vim.g.vscode then
  -- VSCode/Cursor 用の軽量設定
  require("config.vscode")
  require("lazy").setup({
    { "tpope/vim-surround" },
    { "vscode-neovim/vscode-multi-cursor.nvim", config = function()
        require("vscode-multi-cursor").setup()
        local f = function() require("vscode-multi-cursor").addSelectionToNextFindMatch() end
        vim.keymap.set({ "n", "x", "i" }, "<M-d>", f, { silent = true })
      end },
  }, { install = { missing = true }, change_detection = { enabled = false } })
  return
end

require("config.options")
require("config.keymaps")
require("lazy").setup({
  spec = { { import = "plugins" } },
  install = { colorscheme = { "onedark" } },
  change_detection = { notify = false },
  rocks = { enabled = false },
})

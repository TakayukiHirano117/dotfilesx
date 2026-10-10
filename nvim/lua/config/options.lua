local o = vim.opt
o.signcolumn = "yes"
o.iskeyword:append("-")
o.termguicolors = true
local tc = { "#073642","#dc322f","#859900","#b58900","#268bd2","#d33682","#2aa198","#eee8d5",
  "#002b36","#cb4b16","#586e75","#657b83","#839496","#6c71c4","#93a1a1","#fdf6e3" }
for i, c in ipairs(tc) do vim.g["terminal_color_" .. (i - 1)] = c end

o.mouse = ""
o.clipboard = "unnamedplus"
o.fileencoding = "utf-8"
o.backup = false
o.shiftwidth = 2; o.tabstop = 2; o.expandtab = true; o.autoindent = true
o.textwidth = 0
o.hlsearch = true
o.number = true
o.swapfile = false
o.autoread = true
o.background = "dark"
o.cursorline = true
o.ambiwidth = "single"
o.updatetime = 250
o.ignorecase = true; o.smartcase = true
o.undofile = true
o.guicursor = "n-v-c:block-Cursor/lCursor,i-ci-ve:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor"

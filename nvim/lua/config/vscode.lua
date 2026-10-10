local o = vim.opt
o.clipboard = "unnamedplus"
o.swapfile = false; o.backup = false; o.writebackup = false; o.undofile = false
o.shada = ""
o.shiftwidth = 2; o.tabstop = 2; o.expandtab = true; o.autoindent = true
o.signcolumn = "yes"
o.hlsearch = true; o.ignorecase = true; o.smartcase = true

local map = vim.keymap.set
local function act(name) return function() require("vscode").action(name) end end
map({ "x", "n", "o" }, "gc", "<Plug>VSCodeCommentary", { remap = true })
map("n", "gcc", "<Plug>VSCodeCommentaryLine", { remap = true })
local s = { silent = true }
map("n", "<leader>e", act("workbench.action.toggleSidebarVisibility"), s)
map("n", "<leader>p", act("workbench.action.quickOpen"), s)
map("n", "<leader>g", act("workbench.action.findInFiles"), s)
map("n", "<leader>b", act("workbench.action.showAllEditors"), s)
map("n", "]b", act("workbench.action.nextEditor"), s)
map("n", "[b", act("workbench.action.previousEditor"), s)
map("n", "<leader>v", act("workbench.action.splitEditor"), s)
map("n", "<leader>s", act("workbench.action.splitEditorDown"), s)
map("n", "<C-h>", act("workbench.action.focusLeftGroup"), s)
map("n", "<C-l>", act("workbench.action.focusRightGroup"), s)
map("n", "<C-j>", act("workbench.action.focusBelowGroup"), s)
map("n", "<C-k>", act("workbench.action.focusAboveGroup"), s)
map("n", "<leader>a", act("editor.action.quickFix"), s)
map("n", "<leader>r", act("editor.action.rename"), s)
map("n", "<leader>=", act("editor.action.formatDocument"), s)
map("n", "g[", act("workbench.action.editor.previousChange"), s)
map("n", "g]", act("workbench.action.editor.nextChange"), s)
for _, k in ipairs({ "grr", "gri", "grt", "gra", "grn", "grx" }) do pcall(vim.keymap.del, { "n", "x" }, k) end
map("n", "gr", act("editor.action.goToReferences"), { silent = true, nowait = true })
map("n", "gi", act("editor.action.goToImplementation"), { silent = true, nowait = true })
map("n", "gy", act("editor.action.goToTypeDefinition"), { silent = true, nowait = true })
map("n", "[g", act("editor.action.marker.prev"), s)
map("n", "]g", act("editor.action.marker.next"), s)
map("n", "<Esc>", "<Cmd>nohlsearch<CR>", s)

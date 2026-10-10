local map = vim.keymap.set
local s = { silent = true }
-- nvim-tree / telescope
map("n", "<leader>e", "<Cmd>NvimTreeToggle<CR>", s)
map("n", "<leader>o", "<Cmd>NvimTreeFocus<CR>", s)
map("n", "<Space>", "<Cmd>NvimTreeFocus<CR>", s)
map("n", "<leader>l", "<C-w>l", s)
map("n", "<leader>p", "<Cmd>Telescope find_files<CR>")
map("n", "<leader>f", "<Cmd>Telescope find_files<CR>")
map("n", "<leader>g", "<Cmd>Telescope live_grep<CR>")
map("n", "<leader>b", "<Cmd>Telescope buffers<CR>")
map("n", "<leader>h", "<Cmd>Telescope help_tags<CR>")
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("nvim_tree_navigation", { clear = true }),
  pattern = "NvimTree",
  callback = function(ev) map("n", "<Space>", "<C-w>l", { buffer = ev.buf, silent = true }) end,
})
-- bufferline
map("n", "<S-h>", "<Cmd>BufferLineCyclePrev<CR>", s)
map("n", "<S-l>", "<Cmd>BufferLineCycleNext<CR>", s)
map("n", "gT", "<Cmd>BufferLineCyclePrev<CR>", s)
map("n", "gt", "<Cmd>BufferLineCycleNext<CR>", s)
for i = 1, 4 do map("n", "<leader>" .. i, "<Cmd>BufferLineGoToBuffer " .. i .. "<CR>", s) end
-- terminal / window
map("n", "<C-t>", "<Cmd>ToggleTerm<CR>", s)
map("t", "<C-t>", "<C-\\><C-n><Cmd>ToggleTerm<CR>", s)
map("t", "<Esc>", "<C-\\><C-n>")
map("n", "<leader>tn", function() _G.split_new_terminal() end, s)
map("t", "<leader>tn", "<C-\\><C-n><Cmd>lua _G.split_new_terminal()<CR>", s)
map("n", "<leader>tc", "<Cmd>bdelete!<CR>", s)
map("t", "<leader>tc", "<C-\\><C-n><Cmd>bdelete!<CR>", s)
map("n", "<leader>tl", "<Cmd>TermSelect<CR>", s)
map("t", "<leader>tl", "<C-\\><C-n><Cmd>TermSelect<CR>", s)
for _, k in ipairs({ "h", "j", "k", "l" }) do
  map("t", "<A-" .. k .. ">", "<C-\\><C-n><C-w>" .. k, s)
  map("n", "<A-" .. k .. ">", "<C-w>" .. k, s)
end
-- whitespace
map("n", "<leader>ws", "<Cmd>StripWhitespace<CR>", s)
map("x", "<leader>ws", ":StripWhitespace<CR>", s)
map("n", "]w", "<Cmd>NextTrailingWhitespace<CR>", s)
map("n", "[w", "<Cmd>PrevTrailingWhitespace<CR>", s)

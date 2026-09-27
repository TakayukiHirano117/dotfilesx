" ─────────────────────────────────────────────
" プラグイン（vim-plug）
" ─────────────────────────────────────────────
call plug#begin()
" VSCode/Cursor と共通で使うプラグイン
Plug 'vscode-neovim/vscode-multi-cursor.nvim'
Plug 'tpope/vim-surround'

" ターミナルNeovim専用プラグイン
Plug 'goolord/alpha-nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'mg979/vim-visual-multi'
Plug 'machakann/vim-highlightedyank'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'ixru/nvim-markdown'
Plug 'stevearc/aerial.nvim'
Plug 'Wansmer/treesj'
Plug 'psliwka/vim-smoothie'
Plug 'lambdalisue/nerdfont.vim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'lambdalisue/glyph-palette.vim'
Plug 'matze/vim-move'
Plug 'tpope/vim-commentary'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tpope/vim-rails'
Plug 'airblade/vim-gitgutter'
Plug 'folke/noice.nvim'
Plug 'MunifTanjim/nui.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-tree/nvim-tree.lua'
Plug 'akinsho/bufferline.nvim'
Plug 'HiPhish/rainbow-delimiters.nvim'
Plug 'rcarriga/nvim-notify'
Plug 'christoomey/vim-tmux-navigator'
Plug 'akinsho/toggleterm.nvim', { 'tag': '*' }
Plug 'lewis6991/gitsigns.nvim'
Plug 'MattesGroeger/vim-bookmarks'
Plug 'dominikduda/vim_current_word'
"Plug 'ntpeters/vim-better-whitespace'
Plug 'simeji/winresizer'
Plug 'navarasu/onedark.nvim'
call plug#end()

" ─────────────────────────────────────────────
" VSCode/Cursor用の軽量設定
" ─────────────────────────────────────────────
if exists('g:vscode')
  let mapleader = ","
  " Neovim側で一時ファイルや履歴を作らない
  set clipboard=unnamedplus
  set noswapfile
  set nobackup
  set nowritebackup
  set noundofile
  set shada=
  " 編集
  set shiftwidth=2
  set tabstop=2
  set expandtab
  set autoindent
  set signcolumn=yes
  " 検索
  set hlsearch
  set ignorecase
  set smartcase
  " コメント
  xmap gc  <Plug>VSCodeCommentary
  nmap gc  <Plug>VSCodeCommentary
  omap gc  <Plug>VSCodeCommentary
  nmap gcc <Plug>VSCodeCommentaryLine
  " ファイルエクスプローラー
  nnoremap <silent> <leader>e <Cmd>lua require('vscode').action('workbench.action.toggleSidebarVisibility')<CR>
  " ファイル検索
  nnoremap <silent> <leader>p <Cmd>lua require('vscode').action('workbench.action.quickOpen')<CR>
  " 全文検索
  nnoremap <silent> <leader>g <Cmd>lua require('vscode').action('workbench.action.findInFiles')<CR>
  " 開いているエディター
  nnoremap <silent> <leader>b <Cmd>lua require('vscode').action('workbench.action.showAllEditors')<CR>
  " 次・前のエディター
  nnoremap <silent> ]b <Cmd>lua require('vscode').action('workbench.action.nextEditor')<CR>
  nnoremap <silent> [b <Cmd>lua require('vscode').action('workbench.action.previousEditor')<CR>
  " 画面分割
  nnoremap <silent> <leader>v <Cmd>lua require('vscode').action('workbench.action.splitEditor')<CR>
  nnoremap <silent> <leader>s <Cmd>lua require('vscode').action('workbench.action.splitEditorDown')<CR>
  " 分割画面間の移動
  nnoremap <silent> <C-h> <Cmd>lua require('vscode').action('workbench.action.focusLeftGroup')<CR>
  nnoremap <silent> <C-l> <Cmd>lua require('vscode').action('workbench.action.focusRightGroup')<CR>
  nnoremap <silent> <C-j> <Cmd>lua require('vscode').action('workbench.action.focusBelowGroup')<CR>
  nnoremap <silent> <C-k> <Cmd>lua require('vscode').action('workbench.action.focusAboveGroup')<CR>
  " コードアクション
  nnoremap <silent> <leader>a <Cmd>lua require('vscode').action('editor.action.quickFix')<CR>
  nnoremap <silent> <leader>r <Cmd>lua require('vscode').action('editor.action.rename')<CR>
  " フォーマット
  nnoremap <silent> <leader>= <Cmd>lua require('vscode').action('editor.action.formatDocument')<CR>
  " Git差分
  nnoremap <silent> g[ <Cmd>lua require('vscode').action('workbench.action.editor.previousChange')<CR>
  nnoremap <silent> g] <Cmd>lua require('vscode').action('workbench.action.editor.nextChange')<CR>
  " 検索ハイライト消去
  nnoremap <silent> <Esc> <Cmd>nohlsearch<CR>

  " ── マルチカーソル設定（Option + D で次の一致箇所を追加） ──
  lua require('vscode-multi-cursor').setup()
  nnoremap <silent> <M-d> <Cmd>lua require('vscode-multi-cursor').addSelectionToNextFindMatch()<CR>
  xnoremap <silent> <M-d> <Cmd>lua require('vscode-multi-cursor').addSelectionToNextFindMatch()<CR>
  inoremap <silent> <M-d> <Cmd>lua require('vscode-multi-cursor').addSelectionToNextFindMatch()<CR>

  " Cursor起動時はここで設定読み込みを終了する
  finish
endif

" ─────────────────────────────────────────────
" これ以降はターミナル用Neovimの設定
" ─────────────────────────────────────────────
set signcolumn=yes
let mapleader = ","
set iskeyword+=-
" ─────────────────────────────────────────────
" カラーコード設定
" ─────────────────────────────────────────────
if has('termguicolors')
  set termguicolors
  let g:terminal_color_0  = '#073642'
  let g:terminal_color_1  = '#dc322f'
  let g:terminal_color_2  = '#859900'
  let g:terminal_color_3  = '#b58900'
  let g:terminal_color_4  = '#268bd2'
  let g:terminal_color_5  = '#d33682'
  let g:terminal_color_6  = '#2aa198'
  let g:terminal_color_7  = '#eee8d5'
  let g:terminal_color_8  = '#002b36'
  let g:terminal_color_9  = '#cb4b16'
  let g:terminal_color_10 = '#586e75'
  let g:terminal_color_11 = '#657b83'
  let g:terminal_color_12 = '#839496'
  let g:terminal_color_13 = '#6c71c4'
  let g:terminal_color_14 = '#93a1a1'
  let g:terminal_color_15 = '#fdf6e3'
endif
" ─────────────────────────────────────────────
" 基本設定
" ─────────────────────────────────────────────
set mouse=
set clipboard=unnamedplus
set fenc=utf-8
set nobackup
set shiftwidth=2
set tabstop=2
set expandtab
set autoindent
set textwidth=0
set hlsearch
set number
syntax on
set noswapfile
set autoread
set background=dark
set cursorline
set ambiwidth=single
set updatetime=250
set ignorecase
set smartcase
set undofile
filetype plugin indent on
" ─────────────────────────────────────────────
" vim_current_word
" ─────────────────────────────────────────────
let g:vim_current_word#enabled = 1
let g:vim_current_word#highlight_current_word = 1
let g:vim_current_word#highlight_twins = 1
let g:vim_current_word#highlight_delay = 150
let g:vim_current_word#highlight_only_in_focused_window = 1
let g:vim_current_word#excluded_filetypes = [
      \ 'NvimTree',
      \ 'TelescopePrompt',
      \ 'alpha',
      \ 'help',
      \ 'noice',
      \ ]
" ─────────────────────────────────────────────
" vim-better-whitespace
" ─────────────────────────────────────────────
let g:better_whitespace_enabled = 1
let g:strip_whitespace_on_save = 0
let g:strip_whitespace_confirm = 0
let g:strip_only_modified_lines = 1
let g:strip_whitelines_at_eof = 0
let g:better_whitespace_operator = ''
" ─────────────────────────────────────────────
" winresizer
" ─────────────────────────────────────────────
let g:winresizer_enable = 1
let g:winresizer_start_key = '<leader>w'
let g:winresizer_vert_resize = 5
let g:winresizer_horiz_resize = 2
let g:winresizer_finish_with_escape = 1
" ─────────────────────────────────────────────
" nvim-treesitter
" ─────────────────────────────────────────────
lua << EOF
require'nvim-treesitter.config'.setup {
  ensure_installed = { "go", "ruby", "javascript", "typescript", "html", "css", "json", "yaml", "lua", "vim", "markdown" },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
  }
}
EOF
augroup better_whitespace_config
  autocmd!
  autocmd FileType ruby,eruby,javascript,typescript,json,yaml
        \ EnableStripWhitespaceOnSave
augroup END
nnoremap <silent> <leader>ws <Cmd>StripWhitespace<CR>
xnoremap <silent> <leader>ws :StripWhitespace<CR>
nnoremap <silent> ]w <Cmd>NextTrailingWhitespace<CR>
nnoremap <silent> [w <Cmd>PrevTrailingWhitespace<CR>
" ─────────────────────────────────────────────
" カラースキーム
" ─────────────────────────────────────────────
let g:bookmark_sign = '●'
let g:bookmark_annotation_sign = '◆'
highlight BookmarkSign guifg=#FFD700 guibg=#000000 ctermfg=Yellow ctermbg=Black
highlight BookmarkAnnotationSign guifg=#00D7FF guibg=#000000 ctermfg=Cyan ctermbg=Black
highlight SignColumn guibg=#000000 ctermbg=Black
highlight CurrentWord
      \ guifg=NONE
      \ guibg=#264F78
      \ gui=bold,underline
      \ cterm=bold,underline
highlight CurrentWordTwins
      \ guifg=NONE
      \ guibg=#30363D
      \ gui=NONE
      \ cterm=underline
highlight ExtraWhitespace
      \ guibg=#D16969
      \ ctermbg=Red
" ─────────────────────────────────────────────
" vim-move
" ─────────────────────────────────────────────
let g:move_key_modifier = 'M'
" ─────────────────────────────────────────────
" gitgutter
" ─────────────────────────────────────────────
nnoremap g[ :GitGutterPrevHunk<CR>
nnoremap g] :GitGutterNextHunk<CR>
nnoremap gp :GitGutterPreviewHunk<CR>
highlight GitGutterAdd ctermfg=green
highlight GitGutterChange ctermfg=blue
highlight GitGutterDelete ctermfg=red
" ─────────────────────────────────────────────
" noice.nvim
" ─────────────────────────────────────────────
lua << EOF
require("notify").setup({
  background_colour = "#282C34",
})
require("noice").setup({
  routes = {
    {
      filter = {
        event = "msg_show",
        find = "written",
      },
      opts = { skip = true },
    },
  },
})
EOF
" ─────────────────────────────────────────────
" indent-blankline.nvim
" ─────────────────────────────────────────────
lua << EOF
require("ibl").setup({
  indent = {
    char = "┆",
    tab_char = "┆",
  },
  scope = { enabled = false },
})
EOF
" ─────────────────────────────────────────────
" alpha-nvim
" ─────────────────────────────────────────────
lua << EOF
local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")
dashboard.section.header.opts.position = "center"
dashboard.section.buttons.val = {
  dashboard.button("e", "  New File", ":ene <BAR> startinsert<CR>"),
  dashboard.button("f", "󰈞  Find File", ":Telescope find_files<CR>"),
  dashboard.button("r", "  Recent Files", ":Telescope oldfiles<CR>"),
  dashboard.button("q", "  Quit", ":qa<CR>"),
}
dashboard.section.buttons.opts.position = "center"
dashboard.section.footer.val = "Happy hacking!"
dashboard.section.footer.opts.position = "center"
dashboard.config.layout = {
  { type = "padding", val = 6 },
  dashboard.section.header,
  { type = "padding", val = 2 },
  dashboard.section.buttons,
  { type = "padding", val = 2 },
  dashboard.section.footer,
}
alpha.setup(dashboard.opts)
EOF
" ─────────────────────────────────────────────
" nvim-tree
" ─────────────────────────────────────────────
nnoremap <silent> <leader>e :NvimTreeToggle<CR>
nnoremap <silent> <leader>o :NvimTreeFocus<CR>
nnoremap <silent> <Space> :NvimTreeFocus<CR>
augroup nvim_tree_navigation
  autocmd!
  autocmd FileType NvimTree nnoremap <buffer><silent> <Space> <C-w>l
augroup END
nnoremap <silent> <leader>f :Telescope find_files<CR>
nnoremap <silent> <leader>l <C-w>l
lua << EOF
require("nvim-tree").setup({
  view = {
    width = 35,
    side = "left",
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = false,
  },
  git = {
    enable = true,
    ignore = false,
  },
  actions = {
    open_file = {
      quit_on_open = false,
    },
  },
})
EOF
" ─────────────────────────────────────────────
" telescope
" ─────────────────────────────────────────────
nnoremap <leader>p :Telescope find_files<CR>
nnoremap <leader>f :Telescope find_files<CR>
nnoremap <leader>g :Telescope live_grep<CR>
nnoremap <leader>b :Telescope buffers<CR>
nnoremap <leader>h :Telescope help_tags<CR>
lua << EOF
require("telescope").setup({
  defaults = {
    file_ignore_patterns = { "node_modules", ".git" },
  },
})
EOF
" ─────────────────────────────────────────────
" bufferline
" ─────────────────────────────────────────────
lua << EOF
require("bufferline").setup({
  options = {
    numbers = "ordinal",
    indicator = { style = "underline" },
    show_close_icon = false,
    always_show_bufferline = true,
    separator_style = "thin",
    offsets = {
      {
        filetype = "NvimTree",
        text = "File Explorer",
        highlight = "Directory",
        separator = true,
      },
    },
  },
})
EOF
nnoremap <silent> <S-h> <Cmd>BufferLineCyclePrev<CR>
nnoremap <silent> <S-l> <Cmd>BufferLineCycleNext<CR>
nnoremap <silent> <leader>1 <Cmd>BufferLineGoToBuffer 1<CR>
nnoremap <silent> <leader>2 <Cmd>BufferLineGoToBuffer 2<CR>
nnoremap <silent> <leader>3 <Cmd>BufferLineGoToBuffer 3<CR>
nnoremap <silent> <leader>4 <Cmd>BufferLineGoToBuffer 4<CR>
" ─────────────────────────────────────────────
" rainbow-delimiters.nvim
" ─────────────────────────────────────────────
lua << EOF
vim.g.rainbow_delimiters = {
  highlight = {
    "RainbowDelimiterRed",
    "RainbowDelimiterYellow",
    "RainbowDelimiterBlue",
    "RainbowDelimiterOrange",
    "RainbowDelimiterGreen",
    "RainbowDelimiterViolet",
    "RainbowDelimiterCyan",
  },
}
EOF
" ─────────────────────────────────────────────
" 下部ターミナル
" ─────────────────────────────────────────────
lua << EOF
require("toggleterm").setup({
  direction = "horizontal",
  size = 15,
  start_in_insert = true,
  persist_size = true,
  close_on_exit = false,
  winbar = {
    enabled = true,
    name_formatter = function(term)
      return " Terminal " .. term.id .. " "
    end
  },
})
function _G.split_new_terminal()
  local terms = require("toggleterm.terminal").get_all()
  local next_id = 1
  for _, term in pairs(terms) do
    if term.id >= next_id then
      next_id = term.id + 1
    end
  end
  vim.cmd(next_id .. "ToggleTerm")
end
EOF
nnoremap <silent> <C-t> <Cmd>ToggleTerm<CR>
tnoremap <silent> <C-t> <C-\><C-n><Cmd>ToggleTerm<CR>
tnoremap <Esc> <C-\><C-n>
nnoremap <silent> <leader>tn <Cmd>lua _G.split_new_terminal()<CR>
tnoremap <silent> <leader>tn <C-\><C-n><Cmd>lua _G.split_new_terminal()<CR>
nnoremap <silent> <leader>tc <Cmd>bdelete!<CR>
tnoremap <silent> <leader>tc <C-\><C-n><Cmd>bdelete!<CR>
nnoremap <silent> <leader>tl <Cmd>TermSelect<CR>
tnoremap <silent> <leader>tl <C-\><C-n><Cmd>TermSelect<CR>
tnoremap <silent> <A-h> <C-\><C-n><C-w>h
tnoremap <silent> <A-j> <C-\><C-n><C-w>j
tnoremap <silent> <A-k> <C-\><C-n><C-w>k
tnoremap <silent> <A-l> <C-\><C-n><C-w>l
nnoremap <silent> <A-h> <C-w>h
nnoremap <silent> <A-j> <C-w>j
nnoremap <silent> <A-k> <C-w>k
nnoremap <silent> <A-l> <C-w>l
" ─────────────────────────────────────────────
" CoC: terminal Neovim LSP keymaps
" ─────────────────────────────────────────────
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <silent> <leader>a <Plug>(coc-codeaction-cursor)
nmap <silent> <leader>r <Plug>(coc-rename)
function! ShowDocumentation() abort
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction
nnoremap <silent> K  :call ShowDocumentation()<CR>
nnoremap <silent> gh :call ShowDocumentation()<CR>
lua << EOF
-- Atom One Dark（Cursor の workbench.colorTheme）に合わせる。
-- カーソル色はハイライトの bg。iTerm2 のプロファイル色は変えない。
-- CursorLine は editor.lineHighlightBackground #1073cf2d を背景 #282C34 に合成した色。
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
    -- treesitter の task list は comments の italic を流用している。
    -- https://github.com/navarasu/onedark.nvim/blob/master/lua/onedark/highlights.lua
    ["@markup.list.unchecked"] = { fg = "#E86671", fmt = "none" },
    ["@markup.list.checked"] = { fg = "#98C379", fmt = "none" },
  },
})
require("onedark").load()
EOF
set guicursor=n-v-c:block-Cursor/lCursor,i-ci-ve:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor

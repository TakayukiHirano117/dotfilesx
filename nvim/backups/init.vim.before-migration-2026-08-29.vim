" " ─────────────────────────────────────────────
" " VSCode/Cursor用の軽量設定
" " ─────────────────────────────────────────────
" if exists('g:vscode')
"   let mapleader = ","
  
"   " 基本設定（ファイル書き込み系を全て無効化）
"   set clipboard=unnamedplus
"   set noswapfile
"   set nobackup
"   set nowritebackup
"   set noundofile
"   let &shada = ""
  
"   " 編集系
"   set shiftwidth=2
"   set tabstop=2
"   set expandtab
"   set autoindent
  
"   " 検索
"   set hlsearch
"   set ignorecase
"   set smartcase
  
"   " キーマップ：VSCode側のコマンドを呼び出す
"   " コメントトグル（VSCodeのコメント機能を使う）
"   xmap gc  <Plug>(VSCodeCommentary)
"   nmap gc  <Plug>(VSCodeCommentary)
"   omap gc  <Plug>(VSCodeCommentary)
"   nmap gcc <Plug>(VSCodeCommentaryLine)
  
"   " ファイルエクスプローラー
"   nnoremap <leader>e <Cmd>call VSCodeNotify('workbench.action.toggleSidebarVisibility')<CR>
  
"   " ファイル検索
"   nnoremap <leader>p <Cmd>call VSCodeNotify('workbench.action.quickOpen')<CR>
  
"   " 全文検索
"   nnoremap <leader>g <Cmd>call VSCodeNotify('workbench.action.findInFiles')<CR>
  
"   " バッファ（タブ）移動
"   nnoremap <leader>b <Cmd>call VSCodeNotify('workbench.action.showAllEditors')<CR>
  
"   " 次/前のタブ
"   nnoremap ]b <Cmd>call VSCodeNotify('workbench.action.nextEditor')<CR>
"   nnoremap [b <Cmd>call VSCodeNotify('workbench.action.previousEditor')<CR>
  
"   " 画面分割
"   nnoremap <leader>v <Cmd>call VSCodeNotify('workbench.action.splitEditor')<CR>
"   nnoremap <leader>s <Cmd>call VSCodeNotify('workbench.action.splitEditorDown')<CR>
  
"   " 分割画面間の移動
"   nnoremap <C-h> <Cmd>call VSCodeNotify('workbench.action.focusLeftGroup')<CR>
"   nnoremap <C-l> <Cmd>call VSCodeNotify('workbench.action.focusRightGroup')<CR>
"   nnoremap <C-j> <Cmd>call VSCodeNotify('workbench.action.focusBelowGroup')<CR>
"   nnoremap <C-k> <Cmd>call VSCodeNotify('workbench.action.focusAboveGroup')<CR>
  
"   " 定義ジャンプ系（VSCodeのLSPを使う）
"   nnoremap gd <Cmd>call VSCodeNotify('editor.action.revealDefinition')<CR>
"   nnoremap gr <Cmd>call VSCodeNotify('editor.action.goToReferences')<CR>
"   nnoremap gi <Cmd>call VSCodeNotify('editor.action.goToImplementation')<CR>
"   nnoremap K  <Cmd>call VSCodeNotify('editor.action.showHover')<CR>
  
"   " コードアクション
"   nnoremap <leader>a <Cmd>call VSCodeNotify('editor.action.quickFix')<CR>
"   nnoremap <leader>r <Cmd>call VSCodeNotify('editor.action.rename')<CR>
  
"   " フォーマット
"   nnoremap <leader>= <Cmd>call VSCodeNotify('editor.action.formatDocument')<CR>
  
"   " Git（gitgutterの代わり）
"   nnoremap g[ <Cmd>call VSCodeNotify('workbench.action.editor.previousChange')<CR>
"   nnoremap g] <Cmd>call VSCodeNotify('workbench.action.editor.nextChange')<CR>
  
"   " 検索ハイライト消去
"   nnoremap <Esc> :nohlsearch<CR>
  
"   finish
" endif





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
set shell=/bin/zsh
set nobackup
set shiftwidth=2
set tabstop=2
set expandtab
set autoindent
set textwidth=0
set hlsearch
set number
" syntax on
set noswapfile
set autoread
set background=dark
set cursorline
set ambiwidth=single
set updatetime=250

" ─────────────────────────────────────────────
" プラグイン（vim-plug）
" ─────────────────────────────────────────────
call plug#begin()

Plug 'goolord/alpha-nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'mg979/vim-visual-multi'
Plug 'machakann/vim-highlightedyank'
Plug 'ixru/nvim-markdown'
Plug 'stevearc/aerial.nvim'
Plug 'psliwka/vim-smoothie'
Plug 'lambdalisue/nerdfont.vim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'lambdalisue/glyph-palette.vim'
Plug 'tomasiser/vim-code-dark'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'matze/vim-move'
Plug 'kshenoy/vim-signature'
Plug 'romkatv/powerlevel10k'
Plug 'ntk148v/vim-horizon'
Plug 'tpope/vim-commentary'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tpope/vim-rails'
Plug 'airblade/vim-gitgutter'
Plug 'folke/noice.nvim'
Plug 'MunifTanjim/nui.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-tree/nvim-tree.lua'
Plug 'akinsho/bufferline.nvim'

call plug#end()

" ─────────────────────────────────────────────
" カラースキーム
" ─────────────────────────────────────────────
colorscheme codedark
highlight Normal guifg=White guibg=Black
highlight Search guibg=#FFD700 guifg=Black ctermbg=Yellow ctermfg=Black
highlight Cursor guibg=White guifg=Black

if exists('&guicursor')
  set guicursor=n-v-c:block-Cursor,i-ci-ve:ver25-Cursor,r-cr:hor20
endif

" ─────────────────────────────────────────────
" vim-move
" ─────────────────────────────────────────────
let g:move_key_modifier = 'M'

" ─────────────────────────────────────────────
" vim-airline
" ─────────────────────────────────────────────
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#default#layout = [ [ 'a', 'b', 'c' ], ['z'] ]
let g:airline_section_c = '%t %M'
let g:airline_section_z = '%3l:%-2v'
let g:airline#extensions#hunks#non_zero_only = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#tabline#show_tabs = 1
let g:airline_theme = 'codedark'

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
lua require("noice").setup()

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
" alpha-nvim（project.nvim 依存部分は削除）
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
nnoremap <leader>e :NvimTreeToggle<CR>
nnoremap <leader>f :NvimTreeFindFile<CR>
nnoremap <leader>o :NvimTreeFocus<CR>

lua << EOF
require("nvim-tree").setup({
  view = {
    width = 35,
    side = "left",
  },
  git = { enable = true },
})
EOF

" ─────────────────────────────────────────────
" telescope
" ─────────────────────────────────────────────
nnoremap <leader>p :Telescope find_files<CR>
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

" let g:bullets_enabled_file_types = [
"       \ 'markdown',
"       \ 'text',
"       \ 'gitcommit'
"       \ ]
let g:vim_markdown_auto_insert_bullets = 1

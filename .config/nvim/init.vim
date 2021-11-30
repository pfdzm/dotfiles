set nocompatible              " be iMproved, required
"syntax enable
set noswapfile
set nobackup
set encoding=utf-8
set clipboard=unnamedplus

syntax on
filetype plugin indent on

set exrc
" set guicursor=
set guicursor=n-v-c:block-Cursor
set guicursor+=i:ver100-iCursor
set guicursor+=n-v-c:blinkon1
set guicursor+=i:blinkwait10
set relativenumber
set number
set nohlsearch
set hidden
set noerrorbells
set tabstop=2 softtabstop=2
set shiftwidth=2
set expandtab
set smartindent
set nu
set nowrap
set smartcase
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch
set termguicolors
set scrolloff=8
set noshowmode
set completeopt=menuone,noinsert,noselect " do not instert auto with completion

" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" For all text files set 'textwidth' to 80 characters.
autocmd FileType text setlocal textwidth=80
set colorcolumn=80

let mapleader="\<Space>"


if executable('volta')
  let g:node_host_prog = trim(system("volta which neovim-node-host"))
endif

lua vim.o.completeopt = "menuone,noselect"

" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" nvim-treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update

Plug 'gruvbox-community/gruvbox'

Plug 'neovim/nvim-lspconfig'


" telescope.nvim
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" nvim-compe
Plug 'hrsh7th/nvim-compe'

Plug 'sainnhe/gruvbox-material'

Plug 'hrsh7th/vim-vsnip'

Plug 'tpope/vim-fugitive'

Plug 'github/copilot.vim'
      
" post install (yarn install | npm install) then load plugin only for editing supported files
Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install',
  \}

" Plug 'jiangmiao/auto-pairs'
" Plug 'windwp/nvim-autopairs'
" Plug 'windwp/nvim-ts-autotag'

" Initialize plugin system
call plug#end()

" vim-prettier
let g:prettier#exec_cmd_async = 1
let g:prettier#autoformat_require_pragma = 0

lua require'lspconfig'.tsserver.setup{}
lua require'lspconfig'.eslint.setup{}
lua require'lspconfig'.vuels.setup{}

lua << EOF
require'compe'.setup {
enabled = true;
autocomplete = true;
debug = false;
min_length = 1;
preselect = 'enable';
throttle_time = 80;
source_timeout = 200;
resolve_timeout = 800;
incomplete_delay = 400;
max_abbr_width = 100;
max_kind_width = 100;
max_menu_width = 100;
documentation = {
  border = { '', '' ,'', ' ', '', '', '', ' ' }, -- the border option is the same as `|help nvim_open_win|`
  winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
  max_width = 120,
  min_width = 60,
  max_height = math.floor(vim.o.lines * 0.3),
  min_height = 1,
  };
map_cr = true, --  map <CR> on insert mode
map_complete = true, -- it will auto insert `(` (map_char) after select function or method item
auto_select = false,  -- auto select first item
map_char = { -- modifies the function or method delimiter by filetypes
  all = '(',
  tex = '{'
};
source = {
  path = true;
  buffer = true;
  calc = true;
  nvim_lsp = true;
  nvim_lua = true;
  vsnip = true;
  ultisnips = true;
  luasnip = true;
  };
}
EOF

lua << EOF
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
    }
  }

require'lspconfig'.rust_analyzer.setup {
  capabilities = capabilities,
  }

EOF

" some nice maps
nnoremap <leader>pv :Ex<CR>
nnoremap Y yg$
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z


" telescope remaps
" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" Using lua functions
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
nnoremap <leader>gb <cmd>lua require('telescope.builtin').git_branches()<cr>


" compe remaps
inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm('<CR>')
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })

fun! LspLocationList()
    lua vim.lsp.diagnostic.set_loclist({open_loclist = false})
endfun

" lsp remaps
nnoremap <leader>vd :lua vim.lsp.buf.definition()<CR>
nnoremap <leader>vi :lua vim.lsp.buf.implementation()<CR>
nnoremap <leader>vsh :lua vim.lsp.buf.signature_help()<CR>
nnoremap <leader>vrr :lua vim.lsp.buf.references()<CR>
nnoremap <leader>vrn :lua vim.lsp.buf.rename()<CR>
nnoremap <leader>vh :lua vim.lsp.buf.hover()<CR>
nnoremap <leader>vca :lua vim.lsp.buf.code_action()<CR>
nnoremap <leader>vsd :lua vim.lsp.diagnostic.show_line_diagnostics(); vim.lsp.util.show_line_diagnostics()<CR>
nnoremap <leader>vn :lua vim.lsp.diagnostic.goto_next()<CR>
nnoremap <leader>vll :call LspLocationList()<CR>

" navigation remaps
nnoremap <C-k> :cprev<CR>zz
nnoremap <C-j> :cnext<CR>zz
nnoremap <leader>k :lprev<CR>zz
nnoremap <leader>j :lnext<CR>zz
nnoremap <C-q> :call ToggleQFList(1)<CR>
nnoremap <leader>q :call ToggleQFList(0)<CR>
let g:the_primeagen_qf_l = 0
let g:the_primeagen_qf_g = 0

" netrw
let g:netrw_browse_split = 0
let g:netrw_banner = 0
let g:netrw_winsize = 25

" git
nmap <leader>gs :G<CR>

fun! ToggleQFList(global)
    if a:global
        if g:the_primeagen_qf_g == 1
            let g:the_primeagen_qf_g = 0
            cclose
        else
            let g:the_primeagen_qf_g = 1
            copen
        end
    else
        if g:the_primeagen_qf_l == 1
            let g:the_primeagen_qf_l = 0
            lclose
        else
            let g:the_primeagen_qf_l = 1
            lopen
        end
    endif
endfun


lua << EOF
local t = function(str)
return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
local col = vim.fn.col('.') - 1
return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
if vim.fn.pumvisible() == 1 then
  return t "<C-n>"
elseif vim.fn['vsnip#available'](1) == 1 then
  return t "<Plug>(vsnip-expand-or-jump)"
elseif check_back_space() then
  return t "<Tab>"
else
  return vim.fn['compe#complete']()
end
end
_G.s_tab_complete = function()
if vim.fn.pumvisible() == 1 then
  return t "<C-p>"
elseif vim.fn['vsnip#jumpable'](-1) == 1 then
  return t "<Plug>(vsnip-jump-prev)"
else
  -- If <S-Tab> is not working in your terminal, change it to <C-h>
  return t "<S-Tab>"
end
end

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
EOF


lua require'nvim-treesitter.configs'.setup { highlight = { enable = true }, autotag = { enable = true }  }

if executable('rg')
  let g:rg_derive_root='true'
endif

let g:theprimeagen_colorscheme = "gruvbox"
fun! ColorMyPencils()
    let g:gruvbox_contrast_dark = 'hard'
    if exists('+termguicolors')
        let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
        let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    endif
    let g:gruvbox_invert_selection='0'

    set background=dark
    if has('nvim')
        call luaeval('vim.cmd("colorscheme " .. _A[1])', [g:theprimeagen_colorscheme])
    else
        " TODO: What the way to use g:theprimeagen_colorscheme
        colorscheme gruvbox
    endif

    highlight ColorColumn ctermbg=0 guibg=grey
    hi SignColumn guibg=none
    hi CursorLineNR guibg=None
    highlight Normal guibg=none
    " highlight LineNr guifg=#ff8659
    " highlight LineNr guifg=#aed75f
    highlight LineNr guifg=#5eacd3
    highlight netrwDir guifg=#5eacd3
    highlight qfFileName guifg=#aed75f
    hi TelescopeBorder guifg=#5eacd
endfun
call ColorMyPencils()

lua << EOF
-- require('nvim-autopairs').setup{}

-- local cond = require('nvim-autopairs.conds')
-- 
-- local npairs = require("nvim-autopairs")
-- 
-- npairs.setup({
--     check_ts = true,
--     ts_config = {
--         lua = {'string'},-- it will not add a pair on that treesitter node
--         javascript = {'template_string'},
--         java = false,-- don't check treesitter on java
--     }
-- })
-- 
-- -- put this to setup function and press <a-e> to use fast_wrap
-- npairs.setup({
--     fast_wrap = {},
-- })
-- 
-- 
-- local ts_conds = require('nvim-autopairs.ts-conds')
-- 
-- npairs.enable()
-- 
-- require('nvim-ts-autotag').setup()
-- 
EOF

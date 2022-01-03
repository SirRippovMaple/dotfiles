let mapleader =","

if ! filereadable(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim"'))
    echo "Downloading junegunn/vim-plug to manage plugins..."
    silent !mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/
    silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim
    autocmd VimEnter * PlugInstall
endif

call plug#begin(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/plugged"'))
Plug 'mhinz/vim-startify'
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'junegunn/gv.vim'
Plug 'tpope/vim-surround'
Plug 'junegunn/goyo.vim'
Plug 'jreybert/vimagit'
Plug 'vimwiki/vimwiki'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'akinsho/nvim-bufferline.lua'
Plug 'tpope/vim-commentary'
Plug 'ap/vim-css-color'
Plug 'SirVer/ultisnips'
Plug 'SirRippovMaple/ultisnips-snippets'
Plug '907th/vim-auto-save'
Plug 'lambdalisue/suda.vim'
Plug 'FotiadisM/tabset.nvim'
Plug 'kevinhwang91/rnvimr', {'do': 'make sync'}

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'quangnguyen30192/cmp-nvim-ultisnips'

" C# plugins
Plug 'razzmatazz/csharp-language-server'
" Go plugins
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
" Typescript plugins
Plug 'theia-ide/typescript-language-server'

Plug 'airblade/vim-rooter'
Plug 'rakr/vim-one'
call plug#end()

nmap <leader>P :PlugInstall<CR>

set termguicolors
set background=dark
colorscheme one
let g:airline_powerline_fonts=1
let g:airline_theme='one'
let g:deoplete#enable_at_startup=1
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<S-tab>"
let g:auto_save=0

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

let g:rooter_patterns = ['.git']

lua << EOF
require('bufferline').setup{}
require('tabset').setup({
    defaults = {
        tabwidth = 4,
        shiftwidth = 4,
        expandtab = true
    },
    languages = {
        go = {
            expandtab = false
        },
        ts = {
            tabwidth = 2,
            shiftwidth = 2
        },
    }
})
EOF

set title
set go=a
set mouse=a
set nohlsearch
set clipboard+=unnamedplus
set noshowmode
set noruler
set laststatus=0
set noshowcmd
set ts=4
set shiftwidth=4
set expandtab

" Some basics:
nnoremap c "_c
set nocompatible
filetype plugin on
syntax on
set encoding=utf-8
set fileencoding=utf-8
set number relativenumber
" Enable autocompletion:
set wildmode=longest,list,full
" Disables automatic commenting on newline:
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
" Perform dot commands over visual blocks:
vnoremap . :normal .<CR>
" Splits open at the bottom and right, which is non-retarded, unlike vim defaults.
set splitbelow splitright

" cmp
set completeopt=menu,menuone,noselect

lua <<EOF
    local cmp = require('cmp')

    cmp.setup {
        snippet = {
            expand = function (args)
                vim.fn["UltiSnips#Anon"](args.body)
            end,
        },
        mapping = {
            ['<C-j>'] = cmp.mapping(cmp.mapping.select_next_item()),
            ['<C-k>'] = cmp.mapping(cmp.mapping.select_prev_item()),
            ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), {'i', 'c'}),
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
        },
        sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'ultisnips' },
            { name = 'buffer' },
        })
    }

    -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline('/', {
        sources = {
            { name = 'buffer' }
        }
    })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(':', {
        sources = cmp.config.sources({
            { name = 'path' }
        }, {
            { name = 'cmdline' }
        })
    })

    -- Setup lspconfig.
    local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

    require('lspconfig').csharp_ls.setup{
        capabilities = capabilities
    }
    require('lspconfig').tsserver.setup{
        capabilities = capabilities
    }
EOF

nmap <C-b> <cmd>lua vim.lsp.buf.definition()<CR>

" Ranger
let g:rnvimr_ex_enable = 1
nmap <leader>n <cmd>RnvimrToggle<CR>

" Shortcutting split navigation, saving a keypress:
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Better word wrappage
nnoremap k gk
nnoremap j gj
nnoremap gk k
nnoremap gj j

imap jj <ESC>
vnoremap < <gv
vnoremap > >gv

" Treesitter
lua << EOF
require('nvim-treesitter.configs').setup {
    ensure_installed = "maintained",
    sync_install = false,
    autopairs = {
        enable = true,
    },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = true,
    },
}
EOF

" Telescope
nnoremap <leader>f <cmd>Telescope find_files<CR>
nnoremap <leader>g <cmd>Telescope live_grep<CR>
nnoremap <leader>b <cmd>Telescope buffers<CR>
nnoremap <leader>h <cmd>Telescopr help_tags<CR>

lua << EOF
local actions = require('telescope.actions')
require('telescope').setup{
    defaults = {
        mappings = {
            i = {
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
            },
        }
    },
    extensions = {
        fzy_native = {
            override_generic_sorter = false,
            override_file_sorter = true,
        }
    }
}
require('telescope').load_extension('fzy_native')
EOF

" Buffers
nnoremap ]b :bn<CR>
nnoremap [b :bp<CR>

" Turns off highlighting on the bits of code that are changed, so the line that is changed is highlighted but the actual text that has changed stands out on the line and is readable.
if &diff
    highlight! link DiffText MatchParen
endif

" Function for toggling the bottom statusbar:
let s:hidden_all = 0
function! ToggleHiddenAll()
    if s:hidden_all  == 0
        let s:hidden_all = 1
        set noshowmode
        set noruler
        set laststatus=0
        set noshowcmd
    else
        let s:hidden_all = 0
        set showmode
        set ruler
        set laststatus=2
        set showcmd
    endif
endfunction
nnoremap <leader>h :call ToggleHiddenAll()<CR>

function! DoPrettyXML()
  " save the filetype so we can restore it later
  let l:origft = &ft
  set ft=
  " delete the xml header if it exists. This will
  " permit us to surround the document with fake tags
  " without creating invalid xml.
  1s/<?xml .*?>//e
  " insert fake tags around the entire document.
  " This will permit us to pretty-format excerpts of
  " XML that may contain multiple top-level elements.
  0put ='<PrettyXML>'
  $put ='</PrettyXML>'
  silent %!xmllint --format -
  " xmllint will insert an <?xml?> header. it's easy enough to delete
  " if you don't want it.
  " delete the fake tags
  2d
  $d
  " restore the 'normal' indentation, which is one extra level
  " too deep due to the extra tags we wrapped around the document.
  silent %<
  " back to home
  1
  " restore the filetype
  exe "set ft=" . l:origft
endfunction
command! PrettyXML call DoPrettyXML()

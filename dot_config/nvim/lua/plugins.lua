fn = vim.fn
mapkey = vim.api.nvim_set_keymap
set = vim.opt

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

return require('packer').startup(
    function(use)
        use {
            'wbthomason/packer.nvim',
            config = function()
                mapkey('n', '<Leader>p', ':PackerCompile<CR>', {})
            end
        }

        use {
            'nvim-lualine/lualine.nvim',
            requires = { 'kyazdani42/nvim-web-devicons' },
            config = function()
                local config = require('lualine')
                config.setup {
                    options = {
                        icons_enabled = true,
                        theme = 'onedark'
                    }
                }
            end
        }

        use {
            'stevearc/qf_helper.nvim',
            config = function()
                mapkey('n', ']q', '<cmd>QNext<CR>', { noremap = true, silent = true })
                mapkey('n', '[q', '<cmd>QPrev<CR>', { noremap = true, silent = true })
                mapkey('n', '<Leader>q', '<cmd>QFToggle!<CR>', { noremap = true, silent = true })
                mapkey('n', '<Leader>l', '<cmd>LLToggle!<CR>', { noremap = true, silent = true })
            end
        }

        use 'kyazdani42/nvim-web-devicons'

        use {
            'kyazdani42/nvim-tree.lua',
            config = function()
                mapkey('n', '<Leader>n', '<cmd>NvimTreeToggle<CR>', {})
                local nvim_tree = require("nvim-tree")
                local nvim_tree_config = require("nvim-tree.config")
                local tree_cb = nvim_tree_config.nvim_tree_callback

                nvim_tree.setup {
                    disable_netrw = true,
                    hijack_netrw = true,
                    open_on_setup = false,
                    open_on_tab = false,
                    hijack_cursor = false,
                    update_cwd = true,
                    diagnostics = {
                        enable = true,
                    },
                    update_focused_file = {
                        enable = true,
                        update_cwd = true,
                    },
                    git = {
                       enable = true,
                       ignore = true,
                       timeout = 500,
                    },
                    view = {
                        mappings = {
                            list = {
                                { key = { "l", "<CR>", "o" }, cb = tree_cb "edit" },
                                { key = "h", cb = tree_cb "close_node" },
                                { key = "v", cb = tree_cb "vsplit" },
                            },
                        },
                    }
                }
            end,
            run = function()
                vim.api.nvim_create_autocmd({ "BufEnter" }, {
                    nested = true,
                    callback = function()
                        if #vim.api.nvim_list_wins() == 1 and vim.api.nvim_buf_get_name(0):match("NvimTree_") ~= nil then
                            vim.cmd "quit"
                        end
                    end
                })
            end
        }

        use {
            'akinsho/nvim-bufferline.lua',
            config = function()
                local cfg = require('bufferline')
                cfg.setup{}
            end
        }

        use 'ap/vim-css-color'

        use {
            'SirVer/ultisnips',
            config = function()
                vim.g.UltiSnipsExpandTrigger = '<tab>'
                vim.g.UltiSnipsJumpForwardTrigger='<tab>'
                vim.g.UltiSnipsJumpBackwardTrigger='<S-tab>'
                vim.g.UltiSnaipsEditSplit = 'vertical'
            end
        }

        use 'SirRippovMaple/ultisnips-snippets'

        use {
            'FotiadisM/tabset.nvim',
            config = function()
                local cfg = require('tabset')
                cfg.setup({
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
            end
        }

        use 'lukas-reineke/indent-blankline.nvim'

        use 'nvim-lua/plenary.nvim'

        use {
            'nvim-telescope/telescope.nvim',
            config = function()
                mapkey('n', '<Leader>f', '<cmd>Telescope find_files<CR>', { noremap = true })
                mapkey('n', '<Leader>b', '<cmd>Telescope buffers<CR>', { noremap = true })
                mapkey('n', '<Leader>g', '<cmd>Telescope live_grep<CR>', { noremap = true })
                mapkey('n', '<Leader>h', '<cmd>Telescope help_tags<CR>', { noremap = true })

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
            end
        }

        use {
            'nvim-telescope/telescope-fzy-native.nvim',
            requires = {'nvim-telescope/telescope.nvim'},
            config = function()
                require('telescope').load_extension('fzy_native')
            end
        }

        use {
            'renerocksai/telekasten.nvim',
            requires = {
                'nvim-telescope/telescope.nvim',
                'renerocksai/calendar-vim'
            },
            config = function()
                local home = vim.fn.expand("~/.notable")
                require('telekasten').setup({
                    home = home,
                    take_over_my_home = true,
                    auto_set_filetype = true,
                })
            end
        }
        
        use {
            'renerocksai/calendar-vim',
        }

        use {
            'lervag/vimtex',
        }

        use {
            'nvim-treesitter/nvim-treesitter',
            as = 'telescope',
            run = ':TSUpdate',
            config = function()
                require('nvim-treesitter.configs').setup {
                    sync_install = false,
                    autopairs = {
                        enable = true,
                    },
                    highlight = {
                        enable = true,
                        additional_vim_regex_highlighting = true,
                    },
                }
            end
        }

        use {
            'neovim/nvim-lspconfig',
            config = function()
                mapkey('n', '<C-b>', '<cmd>lua vim.lsp.buf.definition()<CR>', {})
                fn.sign_define(
                  "LspDiagnosticsSignError",
                  { texthl = "LspDiagnosticsSignError", text = "", numhl = "LspDiagnosticsSignError" }
                )
                fn.sign_define(
                  "LspDiagnosticsSignWarning",
                  { texthl = "LspDiagnosticsSignWarning", text = "", numhl = "LspDiagnosticsSignWarning" }
                )
                fn.sign_define(
                  "LspDiagnosticsSignHint",
                  { texthl = "LspDiagnosticsSignHint", text = "", numhl = "LspDiagnosticsSignHint" }
                )
                fn.sign_define(
                  "LspDiagnosticsSignInformation",
                  { texthl = "LspDiagnosticsSignInformation", text = "", numhl = "LspDiagnosticsSignInformation" }
                )
            end
        }

        use 'hrsh7th/cmp-nvim-lsp'
        use 'hrsh7th/cmp-buffer'
        use 'hrsh7th/cmp-path'
        use 'hrsh7th/cmp-cmdline'

        use {
            'hrsh7th/nvim-cmp',
            requires = {'neovim/nvim-lspconfig'},
            config = function()
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
                    }),
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

                local lspConfig = require('lspconfig')
                lspConfig.csharp_ls.setup{
                    capabilities = capabilities
                }
                lspConfig.tsserver.setup{
                    capabilities = capabilities
                }
                lspConfig.sumneko_lua.setup{
                    capabilities = capabilities,
                    settings = {
                        Lua = {
                            diagnostics = {
                                globals = {'vim'}
                            },
                            workspace = {
                                library = vim.api.nvim_get_runtime_file("", true)
                            }
                        }
                    }
                }
            end
        }

        use {
            'alexaandru/nvim-lspupdate',
            requires = {'neovim/nvim-lspconfig'},
        }

        use 'quangnguyen30192/cmp-nvim-ultisnips'

        -- C# plugins
        use 'razzmatazz/csharp-language-server'

        -- Go plugins
        use {
            'fatih/vim-go',
            run = ':GoUpdateBinaries'
        }

        -- Typescript plugins
        use 'theia-ide/typescript-language-server'

        use {
            'airblade/vim-rooter',
            config = function()
                vim.g.rooter_patterns = {'.git'}
            end
        }

        use {
            'ful1e5/onedark.nvim',
            config = function()
                require('onedark').setup({
                    dark_float = true
                })
            end
        }

        use {
            'phaazon/hop.nvim',
            config = function()
                cfg = require('hop')
                cfg.setup{}
                mapkey('n', '<Leader><Leader>w', '<cmd>HopWord<CR>', { silent = true })
                mapkey('n', '<Leader><Leader>l', '<cmd>HopLine<CR>', { silent = true })
                mapkey('n', '<Leader><Leader>c', '<cmd>HopChar1<CR>', { silent = true })
                mapkey('n', '<Leader><Leader>/', '<cmd>HopPattern<CR>', { silent = true })
            end
        }

        if packer_bootstrap then
            require('packer').sync()
        end
    end
)


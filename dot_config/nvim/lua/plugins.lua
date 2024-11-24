
fn = vim.fn
mapkey = vim.api.nvim_set_keymap
mapkeylua = vim.keymap.set

local lazypath = fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

return require('lazy').setup({
    {
        'nvim-lualine/lualine.nvim',
        dependencies = {
            'kyazdani42/nvim-web-devicons',
            'akinsho/nvim-bufferline.lua',
        },
        config = function()
            local config = require('lualine')
            config.setup {
                options = {
                    icons_enabled = true,
                    theme = 'onedark'
                }
            }
        end
    },
    {
        'stevearc/qf_helper.nvim',
        lazy = true,
        keys = {
            { ']q', '<cmd>QNext<CR>', { noremap = true, silent = true } },
            { '[q', '<cmd>QPrev<CR>', { noremap = true, silent = true } },
            { '<Leader>q', '<cmd>QFToggle!<CR>', { noremap = true, silent = true } },
            { '<Leader>l', '<cmd>LLToggle!<CR>', { noremap = true, silent = true } },
        },
        config = function ()
            require('qf_helper').setup()
        end
    },
    {
        'kyazdani42/nvim-web-devicons',
        lazy = true,
    },
    {
        'kyazdani42/nvim-tree.lua',
        config = function()
            mapkey('n', '<Leader>n', '<cmd>NvimTreeToggle<CR>', {})
            local nvim_tree = require("nvim-tree")
            local on_attach = function(bufnr)
                local api = require('nvim-tree.api')

                local function opts(desc)
                    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
                end


                -- Default mappings. Feel free to modify or remove as you wish.
                --
                -- BEGIN_DEFAULT_ON_ATTACH
                vim.keymap.set('n', '<C-]>', api.tree.change_root_to_node,          opts('CD'))
                vim.keymap.set('n', '<C-e>', api.node.open.replace_tree_buffer,     opts('Open: In Place'))
                vim.keymap.set('n', '<C-k>', api.node.show_info_popup,              opts('Info'))
                vim.keymap.set('n', '<C-r>', api.fs.rename_sub,                     opts('Rename: Omit Filename'))
                vim.keymap.set('n', '<C-t>', api.node.open.tab,                     opts('Open: New Tab'))
                vim.keymap.set('n', '<C-v>', api.node.open.vertical,                opts('Open: Vertical Split'))
                vim.keymap.set('n', '<C-x>', api.node.open.horizontal,              opts('Open: Horizontal Split'))
                vim.keymap.set('n', '<BS>',  api.node.navigate.parent_close,        opts('Close Directory'))
                vim.keymap.set('n', '<CR>',  api.node.open.edit,                    opts('Open'))
                vim.keymap.set('n', '<Tab>', api.node.open.preview,                 opts('Open Preview'))
                vim.keymap.set('n', '>',     api.node.navigate.sibling.next,        opts('Next Sibling'))
                vim.keymap.set('n', '<',     api.node.navigate.sibling.prev,        opts('Previous Sibling'))
                vim.keymap.set('n', '.',     api.node.run.cmd,                      opts('Run Command'))
                vim.keymap.set('n', '-',     api.tree.change_root_to_parent,        opts('Up'))
                vim.keymap.set('n', 'a',     api.fs.create,                         opts('Create'))
                vim.keymap.set('n', 'bmv',   api.marks.bulk.move,                   opts('Move Bookmarked'))
                vim.keymap.set('n', 'B',     api.tree.toggle_no_buffer_filter,      opts('Toggle No Buffer'))
                vim.keymap.set('n', 'c',     api.fs.copy.node,                      opts('Copy'))
                vim.keymap.set('n', 'C',     api.tree.toggle_git_clean_filter,      opts('Toggle Git Clean'))
                vim.keymap.set('n', '[c',    api.node.navigate.git.prev,            opts('Prev Git'))
                vim.keymap.set('n', ']c',    api.node.navigate.git.next,            opts('Next Git'))
                vim.keymap.set('n', 'd',     api.fs.remove,                         opts('Delete'))
                vim.keymap.set('n', 'D',     api.fs.trash,                          opts('Trash'))
                vim.keymap.set('n', 'E',     api.tree.expand_all,                   opts('Expand All'))
                vim.keymap.set('n', 'e',     api.fs.rename_basename,                opts('Rename: Basename'))
                vim.keymap.set('n', ']e',    api.node.navigate.diagnostics.next,    opts('Next Diagnostic'))
                vim.keymap.set('n', '[e',    api.node.navigate.diagnostics.prev,    opts('Prev Diagnostic'))
                vim.keymap.set('n', 'F',     api.live_filter.clear,                 opts('Clean Filter'))
                vim.keymap.set('n', 'f',     api.live_filter.start,                 opts('Filter'))
                vim.keymap.set('n', 'g?',    api.tree.toggle_help,                  opts('Help'))
                vim.keymap.set('n', 'gy',    api.fs.copy.absolute_path,             opts('Copy Absolute Path'))
                vim.keymap.set('n', 'H',     api.tree.toggle_hidden_filter,         opts('Toggle Dotfiles'))
                vim.keymap.set('n', 'I',     api.tree.toggle_gitignore_filter,      opts('Toggle Git Ignore'))
                vim.keymap.set('n', 'J',     api.node.navigate.sibling.last,        opts('Last Sibling'))
                vim.keymap.set('n', 'K',     api.node.navigate.sibling.first,       opts('First Sibling'))
                vim.keymap.set('n', 'm',     api.marks.toggle,                      opts('Toggle Bookmark'))
                vim.keymap.set('n', 'o',     api.node.open.edit,                    opts('Open'))
                vim.keymap.set('n', 'O',     api.node.open.no_window_picker,        opts('Open: No Window Picker'))
                vim.keymap.set('n', 'p',     api.fs.paste,                          opts('Paste'))
                vim.keymap.set('n', 'P',     api.node.navigate.parent,              opts('Parent Directory'))
                vim.keymap.set('n', 'q',     api.tree.close,                        opts('Close'))
                vim.keymap.set('n', 'r',     api.fs.rename,                         opts('Rename'))
                vim.keymap.set('n', 'R',     api.tree.reload,                       opts('Refresh'))
                vim.keymap.set('n', 's',     api.node.run.system,                   opts('Run System'))
                vim.keymap.set('n', 'S',     api.tree.search_node,                  opts('Search'))
                vim.keymap.set('n', 'U',     api.tree.toggle_custom_filter,         opts('Toggle Hidden'))
                vim.keymap.set('n', 'W',     api.tree.collapse_all,                 opts('Collapse'))
                vim.keymap.set('n', 'x',     api.fs.cut,                            opts('Cut'))
                vim.keymap.set('n', 'y',     api.fs.copy.filename,                  opts('Copy Name'))
                vim.keymap.set('n', 'Y',     api.fs.copy.relative_path,             opts('Copy Relative Path'))
                vim.keymap.set('n', '<2-LeftMouse>',  api.node.open.edit,           opts('Open'))
                vim.keymap.set('n', '<2-RightMouse>', api.tree.change_root_to_node, opts('CD'))
                -- END_DEFAULT_ON_ATTACH


                -- Mappings migrated from view.mappings.list
                --
                -- You will need to insert "your code goes here" for any mappings with a custom action_cb
                vim.keymap.set('n', 'l', api.node.open.edit, opts('Open'))
                vim.keymap.set('n', '<CR>', api.node.open.edit, opts('Open'))
                vim.keymap.set('n', 'o', api.node.open.edit, opts('Open'))
                vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts('Close Directory'))
                vim.keymap.set('n', 'v', api.node.open.vertical, opts('Open: Vertical Split'))

            end

            nvim_tree.setup {
                disable_netrw = true,
                hijack_netrw = true,
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
                on_attach = on_attach,
            }
        end,
    },
    {
        'akinsho/nvim-bufferline.lua',
        config = function()
            local cfg = require('bufferline')
            cfg.setup{}
        end
    },
    'ap/vim-css-color',
    {
        'SirVer/ultisnips',
        config = function()
            vim.g.UltiSnipsExpandTrigger = '<tab>'
            vim.g.UltiSnipsJumpForwardTrigger='<tab>'
            vim.g.UltiSnipsJumpBackwardTrigger='<S-tab>'
            vim.g.UltiSnaipsEditSplit = 'vertical'
        end
    },
    'SirRippovMaple/ultisnips-snippets',
    {
        'FotiadisM/tabset.nvim',
        config = function()
            local cfg = require('tabset')
            cfg.setup({
                defaults = {
                    tabwidth = 4,
                    shiftwidth = 4,
                    expandtab = true,
                },
                languages = {
                    go = {
                        expandtab = false,
                    },
                    ts = {
                        tabwidth = 2,
                        shiftwidth = 2,
                    },
                    yaml = {
                        tabwidth = 2,
                        shiftwidth = 2,
                        expandtab = true,
                    },
                    make = {
                        expandtab = false,
                    }
                },
            })
        end
    },
    'lukas-reineke/indent-blankline.nvim',
    'nvim-lua/plenary.nvim',
    {
        'nvim-telescope/telescope.nvim',
        keys = {
            { '<Leader>f', '<cmd>Telescope find_files<CR>', { noremap = true } },
            { '<Leader>b', '<cmd>Telescope buffers<CR>', { noremap = true } },
            { '<Leader>g', '<cmd>Telescope live_grep<CR>', { noremap = true } },
            { '<Leader>h', '<cmd>Telescope help_tags<CR>', { noremap = true } },
        },
        lazy = true,
        config = function()
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
    },
    {
        'nvim-telescope/telescope-fzy-native.nvim',
        dependencies = {'nvim-telescope/telescope.nvim'},
        config = function()
            require('telescope').load_extension('fzy_native')
        end
    },
    {
        'lervag/vimtex',
        lazy = true,
        ft = 'tex'
    },
    {
        'nvim-treesitter/nvim-treesitter',
        build = ":TSUpdate",
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
    },
    {
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
    },
    {
        'rcarriga/nvim-dap-ui',
        dependencies = {'mfussenegger/nvim-dap'},
        config = function()
            local cfg = require('dapui')
            local dap = require('dap')
            cfg.setup {
                layouts = {
                    {
                        elements = {
                            "scopes",
                            "breakpoints"
                        },
                        size = 40,
                        position = "right"
                    }
                },
            }

            dap.listeners.after.event_initialized["dapui_config"] = function()
                cfg.open()
            end

            dap.listeners.before.event_terminated["dapui_config"] = function()
                cfg.close()
            end

            dap.listeners.before.event_exited["dapui_config"] = function()
                cfg.close()
            end
        end
    },
    {
        'mfussenegger/nvim-dap',
        config = function()
            fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" })
            mapkey("n", "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", { silent = true })
            mapkey("n", "<leader>dc", "<cmd>lua require'dap'.continue()<cr>", { silent = true })
            mapkey("n", "<leader>di", "<cmd>lua require'dap'.step_into()<cr>", { silent = true })
            mapkey("n", "<leader>do", "<cmd>lua require'dap'.step_over()<cr>", { silent = true })
            mapkey("n", "<leader>dO", "<cmd>lua require'dap'.step_out()<cr>", { silent = true })
            mapkey("n", "<leader>dr", "<cmd>lua require'dap'.repl.toggle()<cr>", { silent = true })
            mapkey("n", "<leader>dl", "<cmd>lua require'dap'.run_last()<cr>", { silent = true })
            mapkey("n", "<leader>du", "<cmd>lua require'dapui'.toggle()<cr>", { silent = true })
            mapkey("n", "<leader>dt", "<cmd>lua require'dap'.terminate()<cr>", { silent = true })
        end
    },
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'neovim/nvim-lspconfig',
            'simrat39/rust-tools.nvim'
        },
        config = function()
            local cmp = require('cmp')
            local kind_icons = {
                Text = "",
                Method = "m",
                Function = "",
                Constructor = "",
                Field = "",
                Variable = "",
                Class = "",
                Interface = "",
                Module = "",
                Property = "",
                Unit = "",
                Value = "",
                Enum = "",
                Keyword = "",
                Snippet = "",
                Color = "",
                File = "",
                Reference = "",
                Folder = "",
                EnumMember = "",
                Constant = "",
                Struct = "",
                Event = "",
                Operator = "",
                TypeParameter = "",
            }
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
                formatting = {
                    fields = { "kind", "abbr", "menu" },
                    format = function(entry, vim_item)
                        -- Kind icons
                        vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
                        -- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
                        vim_item.menu = ({
                            nvim_lsp = "[LSP]",
                            luasnip = "[Snippet]",
                            buffer = "[Buffer]",
                            path = "[Path]",
                        })[entry.source.name]
                        return vim_item
                    end,
                },
                sources = cmp.config.sources({
                    { 'nvim_lsp' },
                    { 'ultisnips' },
                    { 'buffer' },
                }),
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered()
                }
            }

            -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline('/', {
                sources = {
                    { 'buffer' }
                }
            })

            -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline(':', {
                sources = cmp.config.sources({
                    { 'path' }
                }, {
                    { 'cmdline' }
                })
            })

            -- Setup lspconfig.
            local capabilities = require('cmp_nvim_lsp').default_capabilities()
            local lspConfig = require('lspconfig')
            local lspServers = {
                "csharp_ls",
                "tsserver",
                "lua_ls",
                "dockerls",
                "jsonls",
                "cssls",
                "bashls",
                "marksman",
            }

            for _, server in pairs(lspServers) do
                local opts = {
                    capabilities = capabilities,
                }
                lspConfig[server].setup(opts)
            end

            local rust_tools = require('rust-tools')
            rust_tools.setup {
                server = {
                    capabilities = capabilities
                }
            }
        end
    },
    'quangnguyen30192/cmp-nvim-ultisnips',
    -- Go plugins
    {
        'fatih/vim-go',
        build = ":GoUpdateBinaries",
        lazy = true,
        ft = "go",
    },
    -- Rust plugins
    {
        'simrat39/rust-tools.nvim',
        depencendies = {'neovim/nvim-lspconfig'},
        lazy = true,
        ft = "rust",
    },
    {
        'airblade/vim-rooter',
        config = function()
            vim.g.rooter_patterns = {'.git', 'acl.yaml'}
        end
    },
    {
        'ful1e5/onedark.nvim',
        priority = 1000,
        config = function()
            require('onedark').setup({
                dark_float = true
            })
        end
    },
    {
        'phaazon/hop.nvim',
        config = function()
            local cfg = require('hop')
            cfg.setup{}
            mapkey('n', '<Leader><Leader>w', '<cmd>HopWord<CR>', { silent = true })
            mapkey('n', '<Leader><Leader>l', '<cmd>HopLine<CR>', { silent = true })
            mapkey('n', '<Leader><Leader>c', '<cmd>HopChar1<CR>', { silent = true })
            mapkey('n', '<Leader><Leader>/', '<cmd>HopPattern<CR>', { silent = true })
        end
    },
    {
        'junegunn/vim-easy-align',
        config = function()
            mapkey("x", "ga", "<Plug>(EasyAlign)", {})
            mapkey("n", "ga", "<Plug>(EasyAlign)", {})
        end
    },
    'aklt/plantuml-syntax',
    {
        'tyru/open-browser.vim',
        lazy = true,
        ft = "plantuml",
    },
    {
        'weirongxu/plantuml-previewer.vim',
        lazy = true,
        ft = "plantuml",
    },
    'mechatroner/rainbow_csv',
    {
        'preservim/vim-pencil',
        opt = false,
        config = function()
            vim.g.tex_conceal = ""
            vim.g['pencil#conceallevel'] = 0
            vim.g['pencil#wrapModeDefault'] = 'soft'
        end,
    }
})

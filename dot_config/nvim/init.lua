mapkey = vim.api.nvim_set_keymap
set = vim.opt

require('plugins')

mapkey('n', '<Space>', '<NOP>', { noremap = true, silent = true })
mapkey('n', 'c', '"_c', { noremap = true })
mapkey('', '<C-h>', '<C-w>h', {})
mapkey('', '<C-j>', '<C-w>j', {})
mapkey('', '<C-k>', '<C-w>k', {})
mapkey('', '<C-l>', '<C-w>l', {})
mapkey('n', 'k', 'gk', { noremap = true })
mapkey('n', 'j', 'gj', { noremap = true })
mapkey('n', 'gk', 'k', { noremap = true })
mapkey('n', 'gj', 'j', { noremap = true })
mapkey('i', 'jj', '<esc>', { noremap = true })
mapkey('n', ']b', '<cmd>bn', { noremap = true, silent = true })
mapkey('n', '[b', '<cmd>bp', { noremap = true, silent = true })

vim.g.mapleader = ' '
vim.g.auto_save = 0

set.title = true
set.mouse = 'a'
set.clipboard = 'unnamedplus'
set.ruler = false
set.encoding = 'utf-8'
set.fileencoding = 'utf-8'
set.number = true
set.relativenumber = true
set.splitbelow = true
set.splitright = true

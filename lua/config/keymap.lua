vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '<+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '>-2<CR>gv=gv")


vim.o.number = true
vim.o.relativenumber = true
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.tabstop=2
vim.o.expandtab=true
vim.o.smarttab=true
vim.o.autoindent=true
vim.o.cindent=true


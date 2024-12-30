-- Local Variable for conciseness
local opt = vim.opt

-- Line Numbers
opt.number = true --show absolute line numbers on the cursor line
opt.relativenumber = true --show relative line numbers

-- Tabs and indentations
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true

-- Cursor line hightlight
opt.cursorline = false

-- Terminal Colors & Backgrounds
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

-- Backspace Functionality
opt.backspace = "indent,eol,start"

-- Split Windows
opt.splitright = true
opt.splitbelow = true

-- Turn off Swap File
opt.swapfile = false

-- Line wrap
opt.wrap = true

-- Search options
opt.hlsearch = false
opt.incsearch = true
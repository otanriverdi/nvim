local opt = vim.opt
local g = vim.g

opt.laststatus = 3 -- global statusline
opt.showmode = true

opt.clipboard = "unnamedplus"
opt.cursorline = true

opt.colorcolumn = "120"

-- Indenting
opt.expandtab = true
opt.shiftwidth = 2
opt.smartindent = true
opt.shiftround = true
opt.tabstop = 2
opt.softtabstop = 2

opt.ignorecase = true
opt.smartcase = true
opt.mouse = ""

-- Numbers
opt.number = true
opt.numberwidth = 2

opt.signcolumn = "yes"
opt.splitbelow = true
opt.splitright = true
opt.termguicolors = true
opt.timeout = true
opt.timeoutlen = 300
opt.undofile = true

-- interval for writing swap file to disk, also used by gitsigns
opt.updatetime = 250

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append("<>[]hl")

opt.cmdheight = 1
opt.relativenumber = true

-- yeah...
opt.backup = false
opt.swapfile = false

opt.incsearch = true

-- always have 8 lines visible when scrolling
opt.scrolloff = 8

g.mapleader = " "
g.maplocalleader = " "
local default_providers = {
  "node",
  "perl",
  "python3",
  "ruby",
}

for _, provider in ipairs(default_providers) do
  vim.g["loaded_" .. provider .. "_provider"] = 0
end

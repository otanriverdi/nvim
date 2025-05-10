-- autocmds
local autocmd = vim.api.nvim_create_autocmd

-- fast yank hightlight
local yank_group = vim.api.nvim_create_augroup("HighlightYank", {})
autocmd("TextYankPost", {
  group = yank_group,
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({
      higroup = "IncSearch",
      timeout = 40,
    })
  end,
})

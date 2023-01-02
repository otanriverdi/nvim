local present, tokyonight = pcall(require, "tokyonight")

if not present then
  return
end

tokyonight.setup({
  transparent = true,
  styles = {
    sidebars = "transparent",
    floats = "transparent",
  },
  on_highlights = function(hl, c)
    hl.CursorLineNr = {
      fg = c.blue,
    }
    hl.LineNr = {
      fg = c.blue,
    }
  end,
})

vim.cmd([[colorscheme tokyonight]])

local present, tokyonight = pcall(require, "tokyonight")

if not present then
  return
end

tokyonight.setup {
  transparent = true,
  styles = {
    sidebars = "transparent",
    floats = "transparent",
  },
  on_highlights = function(hl, c)
    hl.CursorLineNr = {
      fg = c.green1,
    }
    hl.LineNr = {
      fg = c.green1,
    }
  end,
}

vim.cmd [[colorscheme tokyonight]]

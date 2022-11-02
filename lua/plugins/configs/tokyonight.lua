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
}

vim.cmd [[colorscheme tokyonight]]

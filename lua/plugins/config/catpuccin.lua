return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavour = "mocha",
      show_end_of_buffer = true,
      dim_inactive = {
        enabled = true, -- dims the background color of inactive window
        shade = "dark",
        percentage = 0.15, -- percentage of the shade to apply to the inactive window
      },
      default_integrations = true,
      integrations = {
        blink_cmp = true,
        gitsigns = true,
        treesitter = true,
        fidget = true,
        harpoon = true,
        nvim_surround = true,
        telescope = {
          enabled = true,
        },
      },
    })
    vim.cmd.colorscheme("catppuccin")
  end,
}

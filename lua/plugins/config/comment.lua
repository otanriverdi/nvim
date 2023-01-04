return {
  "numToStr/Comment.nvim",
  keys = { "gc", "gb" },
  config = function()
    require("Comment").setup({})
  end,
  init = function()
    local mappings = {
      n = {
        ["<leader>/"] = {
          function()
            require("Comment.api").toggle.linewise.current()
          end,
          "toggle comment",
        },
      },

      v = {
        ["<leader>/"] = {
          "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
          "toggle comment",
        },
      },
    }

    require("core.utils").load_mappings(mappings)
  end,
}

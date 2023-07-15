return {
  "mrjones2014/smart-splits.nvim",
  lazy = false,
  init = function()
    local mappings = {
      n = {
        ["<A-h>"] = { ":lua require('smart-splits').resize_left()<CR>", "resize left" },
        ["<A-j>"] = { ":lua require('smart-splits').resize_down()<CR>", "resize down" },
        ["<A-k>"] = { ":lua require('smart-splits').resize_up()<CR>", "resize up" },
        ["<A-l>"] = { ":lua require('smart-splits').resize_right()<CR>", "resize right" },

        ["<C-h>"] = { ":lua require('smart-splits').move_cursor_left()<CR>", "move split right" },
        ["<C-j>"] = { ":lua require('smart-splits').move_cursor_down()<CR>", "move split down" },
        ["<C-k>"] = { ":lua require('smart-splits').move_cursor_up()<CR>", "move split up" },
        ["<C-l>"] = { ":lua require('smart-splits').move_cursor_right()<CR>", "move split right" },
      },
    }

    require("core.utils").load_mappings(mappings)
  end,
}

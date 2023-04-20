return {
  "mrjones2014/smart-splits.nvim",
  lazy = false,
  build = "./kitty/install-kittens.bash",
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

    -- swapping buffers between windows
    -- vim.keymap.set("n", "<leader><leader>h", require("smart-splits").swap_buf_left)
    -- vim.keymap.set("n", "<leader><leader>j", require("smart-splits").swap_buf_down)
    -- vim.keymap.set("n", "<leader><leader>k", require("smart-splits").swap_buf_up)
    -- vim.keymap.set("n", "<leader><leader>l", require("smart-splits").swap_buf_right)

    require("core.utils").load_mappings(mappings)
  end,
}

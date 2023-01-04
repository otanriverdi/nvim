return {
  "ThePrimeagen/harpoon",
  keys = {
    "<leader>ma",
    "<leader>mr",
    "<leader>mf",
    "<TAB>",
    "<S-Tab>",
    "<leader>1",
    "<leader>2",
    "<leader>3",
    "<leader>4",
    "<leader>5",
    "<leader>6",
    "<leader>7",
    "<leader>8",
    "<leader>9",
  },
  init = function()
    local mappings = {
      n = {
        ["<leader>ma"] = { ":lua require('harpoon.mark').add_file()<CR>", "add file to harpoon" },
        ["<leader>mr"] = { ":lua require('harpoon.mark').rm_file()<CR>", "add file to harpoon" },
        ["<leader>mf"] = { ":lua require('harpoon.ui').toggle_quick_menu()<CR>", "toggle harpoon menu" },
        ["<TAB>"] = { ":lua require('harpoon.ui').nav_next()<CR>", "jump to next harpoon file" },
        ["<S-Tab>"] = { ":lua require('harpoon.ui').nav_prev()<CR>", "jump to next harpoon file" },
        ["<leader>1"] = { ":lua require('harpoon.ui').nav_file(1)<CR>", "jump to harpoon file 1" },
        ["<leader>2"] = { ":lua require('harpoon.ui').nav_file(2)<CR>", "jump to harpoon file 2" },
        ["<leader>3"] = { ":lua require('harpoon.ui').nav_file(3)<CR>", "jump to harpoon file 3" },
        ["<leader>4"] = { ":lua require('harpoon.ui').nav_file(4)<CR>", "jump to harpoon file 4" },
        ["<leader>5"] = { ":lua require('harpoon.ui').nav_file(5)<CR>", "jump to harpoon file 5" },
        ["<leader>6"] = { ":lua require('harpoon.ui').nav_file(6)<CR>", "jump to harpoon file 6" },
        ["<leader>7"] = { ":lua require('harpoon.ui').nav_file(7)<CR>", "jump to harpoon file 7" },
        ["<leader>8"] = { ":lua require('harpoon.ui').nav_file(8)<CR>", "jump to harpoon file 8" },
        ["<leader>9"] = { ":lua require('harpoon.ui').nav_file(9)<CR>", "jump to harpoon file 9" },
      },
    }

    require("core.utils").load_mappings(mappings)
  end,
}

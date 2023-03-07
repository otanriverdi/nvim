return {
  "jackMort/ChatGPT.nvim",
  cmd = { "ChatGPT", "ChatGPTActAs", "ChatGPTEditWithInstructions" },
  config = function()
    require("chatgpt").setup({
      welcome_message = "",
      loading_text = "loading",
      keymaps = {
        close = { "<Esc>" },
      },
    })
  end,
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
}

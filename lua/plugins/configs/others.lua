local M = {}

local load_override = require("core.utils").load_override
local utils = require "core.utils"

M.autopairs = function()
  local present1, autopairs = pcall(require, "nvim-autopairs")
  local present2, cmp = pcall(require, "cmp")

  if not (present1 and present2) then
    return
  end

  local options = {
    fast_wrap = {},
    disable_filetype = { "TelescopePrompt", "vim" },
  }

  options = load_override(options, "windwp/nvim-autopairs")
  autopairs.setup(options)

  local cmp_autopairs = require "nvim-autopairs.completion.cmp"
  cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
end

M.blankline = function()
  local present, blankline = pcall(require, "indent_blankline")

  if not present then
    return
  end

  local options = {
    indentLine_enabled = 1,
    filetype_exclude = {
      "help",
      "terminal",
      "alpha",
      "packer",
      "lspinfo",
      "TelescopePrompt",
      "TelescopeResults",
      "mason",
      "",
    },
    buftype_exclude = { "terminal" },
    show_trailing_blankline_indent = false,
    show_first_indent_level = false,
    show_current_context = true,
    show_current_context_start = true,
  }

  options = load_override(options, "lukas-reineke/indent-blankline.nvim")
  blankline.setup(options)
end

M.colorizer = function()
  local present, colorizer = pcall(require, "colorizer")

  if not present then
    return
  end

  local options = {
    filetypes = {
      "*",
    },
    user_default_options = {
      RGB = true, -- #RGB hex codes
      RRGGBB = true, -- #RRGGBB hex codes
      names = false, -- "Name" codes like Blue
      RRGGBBAA = false, -- #RRGGBBAA hex codes
      rgb_fn = false, -- CSS rgb() and rgba() functions
      hsl_fn = false, -- CSS hsl() and hsla() functions
      css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
      css_fn = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn
      mode = "background", -- Set the display mode.
    },
  }

  options = load_override(options, "NvChad/nvim-colorizer.lua")
  colorizer.setup(options)
  -- execute colorizer as soon as possible
  vim.defer_fn(function()
    require("colorizer").attach_to_buffer(0)
  end, 0)
end

M.comment = function()
  local present, nvim_comment = pcall(require, "Comment")

  if not present then
    return
  end

  local options = {}
  options = load_override(options, "numToStr/Comment.nvim")
  nvim_comment.setup(options)
end

M.luasnip = function()
  local present, luasnip = pcall(require, "luasnip")

  if not present then
    return
  end

  local options = {
    history = true,
    updateevents = "TextChanged,TextChangedI",
  }

  options = load_override(options, "L3MON4D3/LuaSnip")
  luasnip.config.set_config(options)
  require("luasnip.loaders.from_vscode").lazy_load { paths = vim.g.luasnippets_path or "" }
  require("luasnip.loaders.from_vscode").lazy_load()

  vim.api.nvim_create_autocmd("InsertLeave", {
    callback = function()
      if
        require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
        and not require("luasnip").session.jump_active
      then
        require("luasnip").unlink_current()
      end
    end,
  })
end

M.gitsigns = function()
  local present, gitsigns = pcall(require, "gitsigns")

  if not present then
    return
  end

  local options = {
    signs = {
      add = { hl = "DiffAdd", text = "│", numhl = "GitSignsAddNr" },
      change = { hl = "DiffChange", text = "│", numhl = "GitSignsChangeNr" },
      delete = { hl = "DiffDelete", text = "", numhl = "GitSignsDeleteNr" },
      topdelete = { hl = "DiffDelete", text = "‾", numhl = "GitSignsDeleteNr" },
      changedelete = { hl = "DiffChangeDelete", text = "~", numhl = "GitSignsChangeNr" },
    },
    on_attach = function(bufnr)
      utils.load_mappings("gitsigns", { buffer = bufnr })
    end,
  }

  options = load_override(options, "lewis6991/gitsigns.nvim")
  gitsigns.setup(options)
end

M.devicons = function()
  local present, devicons = pcall(require, "nvim-web-devicons")

  if present then
    local options = {
      override = {
        default_icon = {
          icon = "",
          name = "Default",
        },

        c = {
          icon = "",
          name = "c",
        },

        css = {
          icon = "",
          name = "css",
        },

        deb = {
          icon = "",
          name = "deb",
        },

        Dockerfile = {
          icon = "",
          name = "Dockerfile",
        },

        html = {
          icon = "",
          name = "html",
        },

        jpeg = {
          icon = "",
          name = "jpeg",
        },

        jpg = {
          icon = "",
          name = "jpg",
        },

        js = {
          icon = "",
          name = "js",
        },

        kt = {
          icon = "󱈙",
          name = "kt",
        },

        lock = {
          icon = "",
          name = "lock",
        },

        lua = {
          icon = "",
          name = "lua",
        },

        mp3 = {
          icon = "",
          name = "mp3",
        },

        mp4 = {
          icon = "",
          name = "mp4",
        },

        out = {
          icon = "",
          name = "out",
        },

        png = {
          icon = "",
          name = "png",
        },

        py = {
          icon = "",
          name = "py",
        },

        ["robots.txt"] = {
          icon = "ﮧ",
          name = "robots",
        },

        toml = {
          icon = "",
          name = "toml",
        },

        ts = {
          icon = "ﯤ",
          name = "ts",
        },

        ttf = {
          icon = "",
          name = "TrueTypeFont",
        },

        rb = {
          icon = "",
          name = "rb",
        },

        rpm = {
          icon = "",
          name = "rpm",
        },

        vue = {
          icon = "﵂",
          name = "vue",
        },

        woff = {
          icon = "",
          name = "WebOpenFontFormat",
        },

        woff2 = {
          icon = "",
          name = "WebOpenFontFormat2",
        },

        xz = {
          icon = "",
          name = "xz",
        },

        zip = {
          icon = "",
          name = "zip",
        },
      },
    }
    options = require("core.utils").load_override(options, "kyazdani42/nvim-web-devicons")

    devicons.setup(options)
  end
end

M.packer_init = function()
  return {
    auto_clean = true,
    compile_on_sync = true,
    git = { clone_timeout = 6000 },
    display = {
      working_sym = "ﲊ",
      error_sym = "✗ ",
      done_sym = " ",
      removed_sym = " ",
      moved_sym = "",
      open_fn = function()
        return require("packer.util").float { border = "single" }
      end,
    },
  }
end

return M

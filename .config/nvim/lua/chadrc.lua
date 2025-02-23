local options = {

  base46 = {
    theme = "catppuccin", -- default theme
    hl_add = {},
    hl_override = {},
    integrations = {},
    changed_themes = {},
    transparency = true,
    theme_toggle = { "catppuccin", "rosepine" },
  },

  ui = {
    cmp = {
      icons = true,
      lspkind_text = true,
      style = "atom_colored", -- default/flat_light/flat_dark/atom/atom_colored
    },

    telescope = { style = "borderless" }, -- borderless / bordered

    statusline = {
      theme = "minimal", -- default/vscode/vscode_colored/minimal
      -- default/round/block/arrow separators work only for default statusline theme
      -- round and block will work for minimal theme only
      separator_style = "round",
      order = nil,
      modules = nil,
    },

    -- lazyload it when there are 1+ buffers
    tabufline = {
      enabled = true,
      lazyload = true,
      order = { "treeOffset", "buffers", "tabs", "btns" },
      modules = nil,
    },

      },

  term = {
    winopts = { number = true, relativenumber = true, },
    sizes = { sp = 0.3, vsp = 0.2, ["bo sp"] = 0.3, ["bo vsp"] = 0.2 },
    float = {
      relative = "editor",
      row = 0.3,
      col = 0.25,
      width = 0.5,
      height = 0.4,
      border = "single",
    },
  },

  lsp = { signature = true },

  cheatsheet = {
    theme = "grid", -- simple/grid
    excluded_groups = { "terminal (t)", "autopairs", "Nvim", "Opens" }, -- can add group name or with mode
  },

  mason = { cmd = true, pkgs = {} },


  nvdash = {
     load_on_startup = true,

     header = {
       "                            ",
       "     ▄▄         ▄ ▄▄▄▄▄▄▄   ",
       "   ▄▀███▄     ▄██ █████▀    ",
       "   ██▄▀███▄   ███           ",
       "   ███  ▀███▄ ███           ",
       "   ███    ▀██ ███           ",
       "   ███      ▀ ███           ",
       "   ▀██ █████▄▀█▀▄██████▄    ",
       "     ▀ ▀▀▀▀▀▀▀ ▀▀▀▀▀▀▀▀▀▀   ",
       "                            ",
       "     Powered By  eovim    ",
       "                            ",
     },

     buttons = {
       { txt = "  Find File", keys = "Spc f f", cmd = "Telescope find_files" },
       { txt = "  Recent Files", keys = "Spc f o", cmd = "Telescope oldfiles" },
       { txt = "  Change Theme", keys = "Spc t h", cmd = "Telescope changetheme" }
       -- more... check nvconfig.lua file for full list of buttons
     },
   }
}
require("configs.luasnip") -- Load LuaSnip Config


local status, chadrc = pcall(require, "chadrc")
return vim.tbl_deep_extend("force", options, status and chadrc or {})

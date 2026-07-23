return {
  {
    "stevearc/conform.nvim",
    opts = require "configs.conform",
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      input = { enabled = true },
      picker = { enabled = true },
      terminal = { enabled = true },
    },
  },
  {
    "NickvanDyke/opencode.nvim",
    lazy = false,
    dependencies = {
      "folke/snacks.nvim",
    },
    config = function()
      vim.g.opencode_opts = {}
      vim.o.autoread = true
      -- Keymaps removed from here - we'll add them in mappings.lua instead
    end,
  },
}

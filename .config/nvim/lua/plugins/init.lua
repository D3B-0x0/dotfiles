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
    end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "mdx" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      completions = { enabled = true },
    },
  },
  {
    "toppair/peek.nvim",
    ft = { "markdown", "mdx" },
    build = "deno task --quiet build:fast",
    config = function()
      require("peek").setup()
      vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
      vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
    end,
  },
  {
    "bullets-vim/bullets.vim",
    ft = { "markdown", "mdx", "text" },
  },
  {
    "tadmccorkle/markdown.nvim",
    ft = { "markdown", "mdx" },
  },
}

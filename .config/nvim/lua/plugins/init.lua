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
    "iamcco/markdown-preview.nvim",
    ft = { "markdown", "mdx" },
    build = "cd app && npm install",
    config = function()
      vim.g.mkdp_auto_close = 0
      vim.g.mkdp_browser = vim.env.BROWSER or "firefox"
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

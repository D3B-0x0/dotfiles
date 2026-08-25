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
  -- Treesitter: syntax highlighting for everything
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim", "lua", "vimdoc",
        "html", "css", "javascript", "typescript", "jsx", "tsx",
        "json", "yaml", "toml", "markdown", "markdown_inline",
        "bash", "python", "java", "c", "cpp", "go", "rust",
        "dockerfile", "hcl", "sql", "regex",
      },
    },
  },
  -- Debug Adapter Protocol
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
      "jay-babu/mason-nvim-dap.nvim",
    },
    config = function()
      require "configs.dap"
    end,
  },
  -- Diagnostics list
  {
    "folke/trouble.nvim",
    cmd = { "Trouble", "TroubleToggle" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
  },
  -- Quick commenting
  {
    "numToStr/Comment.nvim",
    keys = {
      { "gcc", mode = "n", desc = "Toggle line comment" },
      { "gc", mode = { "n", "v" }, desc = "Toggle comment" },
    },
    config = function()
      require("Comment").setup()
    end,
  },
  -- Which-key labels (loaded after NvChad which-key)
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
    config = function(_, opts)
      require("which-key").setup(opts)
      require("which-key").add {
        { "<leader>f", group = "Find" },
        { "<leader>t", group = "Theme" },
        { "<leader>g", group = "Git" },
        { "<leader>d", group = "Debug" },
        { "<leader>x", group = "Diagnostics" },
        { "<leader>m", group = "Markdown" },
        { "<leader>o", group = "Obsidian" },
        { "<leader>b", group = "Buffer" },
        { "<leader>s", group = "Session" },
      }
    end,
  },
  -- Snacks (keep existing)
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
  -- OpenCode (keep existing)
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
  -- Markdown plugins (keep existing)
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

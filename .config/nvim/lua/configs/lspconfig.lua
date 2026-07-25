require("nvchad.configs.lspconfig").defaults()

local servers = {
  "html",
  "cssls",
  "jsonls",
  "bashls",
  "pyright",
  "clangd",
  "rust_analyzer",
  "gopls",       -- for Go
  "yamlls",      -- for YAML configs (Ansible, k8s, etc.)
  "dockerls",    -- Dockerfile syntax
  "terraformls", -- optional, IaC stuff
  "lua_ls",      -- for Neovim config tweaks
  "marksman",    -- Markdown LSP
}

vim.lsp.enable(servers)

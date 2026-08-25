local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    markdown = { "prettier" },
    mdx = { "prettier" },
    java = { "google-java-format" },
    python = { "black" },
    go = { "gofumpt", "goimports" },
    rust = { "rustfmt" },
    css = { "prettier" },
    html = { "prettier" },
    json = { "prettier" },
    yaml = { "prettier" },
    sh = { "shfmt" },
    bash = { "shfmt" },
    sql = { "sql-formatter" },
    postgres = { "pg_format" },
    sqlite = { "sql-formatter" },
  },

  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

return options

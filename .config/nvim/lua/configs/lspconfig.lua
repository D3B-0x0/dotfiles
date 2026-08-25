require("nvchad.configs.lspconfig").defaults()

local servers = {
  "html",
  "cssls",
  "jsonls",
  "bashls",
  "pyright",
  "clangd",
  "rust_analyzer",
  "gopls",
  "yamlls",
  "dockerls",
  "terraformls",
  "lua_ls",
  "marksman",
  "sqls",       -- SQL / PostgreSQL / SQLite
}

-- Enable standard servers
vim.lsp.enable(servers)

-- jdtls: Java Language Server (needs custom setup via mason)
local mason_registry_ok, mason_registry = pcall(require, "mason-registry")
if mason_registry_ok and mason_registry.is_installed "jdtls" then
  local jdtls_path = mason_registry.get_package("jdtls"):get_install_path()
  local launcher = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
  local config_path = jdtls_path .. "/config_linux"

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "java",
    callback = function()
      local opts = {
        cmd = {
          "java",
          "-Declipse.application=org.eclipse.jdt.ls.core.id1",
          "-Dosgi.bundles.defaultStartLevel=4",
          "-Declipse.product=org.eclipse.jdt.ls.core.product",
          "-Dlog.level=ALL",
          "-noverify",
          "-Xmx1g",
          "--add-modules=ALL-SYSTEM",
          "--add-opens", "java.base/java.util=ALL-UNNAMED",
          "--add-opens", "java.base/java.lang=ALL-UNNAMED",
          "-jar", launcher,
          "-configuration", config_path,
          "-data", vim.fn.stdpath "data" .. "/jdtls/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t"),
        },
        root_dir = require("lspconfig.util").root_pattern(
          "build.gradle",
          "build.gradle.kts",
          "pom.xml",
          ".git"
        ),
        settings = {
          java = {
            eclipse = { downloadSources = true },
            configuration = { updateBuildConfiguration = "interactive" },
            maven = { downloadSources = true },
            referencesCodeLens = { enabled = true },
            inlayHints = { parameterNames = { enabled = "all" } },
            format = { enabled = false }, -- we use google-java-format via conform
          },
        },
        init_options = {
          bundles = {},
        },
      }
      vim.lsp.start(opts)
    end,
  })
end

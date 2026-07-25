require "nvchad.mappings"

local map = vim.keymap.set

-- OpenCode keymaps - just overwrite directly, no deleting needed
map({ "n", "x" }, "<C-a>", function()
  require("opencode").ask("@this: ", { submit = true })
end, { desc = "Ask opencode…" })

map({ "n", "x" }, "<C-x>", function()
  require("opencode").select()
end, { desc = "Execute opencode action…" })

map("n", ",o", function()
  require("opencode").toggle()
end, { desc = "Toggle opencode" })

map({ "n", "x" }, "go", function()
  return require("opencode").operator("@this ")
end, { desc = "Add range to opencode", expr = true })

map("n", "goo", function()
  return require("opencode").operator("@this ") .. "_"
end, { desc = "Add line to opencode", expr = true })

map("n", "<S-C-u>", function()
  require("opencode").command("messages_half_page_up")
end, { desc = "Scroll opencode up" })

map("n", "<S-C-d>", function()
  require("opencode").command("messages_half_page_down")
end, { desc = "Scroll opencode down" })

-- Restore native increment/decrement (bypass opencode mappings on <C-a>/<C-x>)
map("n", "+", function()
  vim.cmd("normal! \\<C-a>")
end, { desc = "Increment under cursor" })
map("n", "-", function()
  vim.cmd("normal! \\<C-x>")
end, { desc = "Decrement under cursor" })

-- Markdown keymaps
map("n", ",mp", function()
  if vim.bo.filetype == "markdown" or vim.bo.filetype == "mdx" then
    require("peek").open()
  end
end, { desc = "Peek markdown preview" })

map("n", ",mc", function()
  if vim.bo.filetype == "markdown" or vim.bo.filetype == "mdx" then
    vim.cmd "ToggleCheckbox"
  end
end, { desc = "Toggle checkbox" })

map("n", ",mt", function()
  if vim.bo.filetype == "markdown" or vim.bo.filetype == "mdx" then
    vim.cmd "RenderMarkdown toggle"
  end
end, { desc = "Toggle render markdown" })

-- Quick access to Obsidian vault
map("n", ",ov", function()
  require("telescope.builtin").find_files { cwd = vim.fn.expand("~/Documents/homelab") }
end, { desc = "Find files in Obsidian vault" })

map("n", ",og", function()
  require("telescope.builtin").live_grep { cwd = vim.fn.expand("~/Documents/homelab") }
end, { desc = "Grep in Obsidian vault" })

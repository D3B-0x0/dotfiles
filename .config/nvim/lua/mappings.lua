require "nvchad.mappings"

local map = vim.keymap.set

-- OpenCode keymaps
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

-- Restore native increment/decrement
map("n", "+", function()
  vim.cmd "normal! \\<C-a>"
end, { desc = "Increment under cursor" })
map("n", "-", function()
  vim.cmd "normal! \\<C-x>"
end, { desc = "Decrement under cursor" })

-- Trouble.nvim (diagnostics list)
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
map("n", "<leader>xb", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer Diagnostics" })
map("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List" })
map("n", "<leader>xl", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List" })

-- DAP (Debugging) keybindings
map("n", "<leader>db", function() require("dap").toggle_breakpoint() end, { desc = "Toggle Breakpoint" })
map("n", "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Condition: ")) end, { desc = "Conditional Breakpoint" })
map("n", "<leader>dc", function() require("dap").continue() end, { desc = "Continue" })
map("n", "<leader>do", function() require("dap").step_over() end, { desc = "Step Over" })
map("n", "<leader>di", function() require("dap").step_into() end, { desc = "Step Into" })
map("n", "<leader>dO", function() require("dap").step_out() end, { desc = "Step Out" })
map("n", "<leader>dr", function() require("dap").repl.toggle() end, { desc = "Toggle REPL" })
map("n", "<leader>dl", function() require("dap").run_last() end, { desc = "Run Last" })
map("n", "<leader>du", function() require("dapui").toggle() end, { desc = "Toggle DAP UI" })
map("n", "<leader>dx", function() require("dap").terminate() end, { desc = "Terminate Debug" })

-- Markdown keymaps
map("n", ",mp", function()
  if vim.bo.filetype == "markdown" or vim.bo.filetype == "mdx" then
    vim.cmd "MarkdownPreviewToggle"
  end
end, { desc = "Toggle markdown preview in browser" })

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

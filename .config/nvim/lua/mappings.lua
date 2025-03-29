require "nvchad.mappings"

local map = vim.keymap.set

-- General mappings
map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>", { desc = "Exit insert mode quickly" })
map("n", "<C-s>", "<cmd> w <cr>", { desc = "Save file" })
map("i", "<C-s>", "<Esc><cmd> w <cr>", { desc = "Save file from insert mode" })

-- Open horizontal split terminal in insert mode
map("n", "<F4>", function()
  vim.cmd("split | terminal")
  vim.cmd("startinsert")
end, { desc = "Open terminal in horizontal split and enter insert mode" })

-- Compile and run C file in terminal
map("n", "<F5>", function()
  vim.cmd("split | terminal gcc % -o %:r && ./%:r")
  vim.cmd("startinsert")
end, { desc = "Compile and run C file in terminal" })

-- Compile and run C++ file in terminal
map("n", "<F6>", function()
  vim.cmd("split | terminal g++ % -o %:r && ./%:r")
  vim.cmd("startinsert")
end, { desc = "Compile and run C++ file in terminal" })

-- Compile and run Rust file in terminal
map("n", "<F7>", function()
  vim.cmd("split | terminal cargo run")
  vim.cmd("startinsert")
end, { desc = "Compile and run Rust project in terminal" })

-- Compile and run Python file in terminal
map("n", "<F8>", function()
  vim.cmd("split | terminal python3 %")
  vim.cmd("startinsert")
end, { desc = "Run Python file in terminal" })

-- Close terminal easily
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })


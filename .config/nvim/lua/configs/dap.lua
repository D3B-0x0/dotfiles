local dap = require "dap"
local dapui = require "dapui"
local dap_virtual_text = require "nvim-dap-virtual-text"

-- DAP UI setup
dapui.setup()

-- Virtual text (shows variable values inline while debugging)
dap_virtual_text.setup()

-- Auto open/close DAP UI when debugging starts/stops
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

-- Java DAP configuration
-- This integrates with jdtls (Java Language Server)
-- When jdtls is running, it provides DAP adapters automatically
dap.configurations.java = {
  {
    type = "java",
    request = "launch",
    name = "Debug Current File",
    javaExec = "java",
    classPaths = "${workspaceFolder}/bin",
    projectName = "${workspaceFolderBasename}",
    mainClass = "${fileBasenameNoExtension}",
  },
  {
    type = "java",
    request = "launch",
    name = "Debug (with args)",
    javaExec = "java",
    classPaths = "${workspaceFolder}/bin",
    projectName = "${workspaceFolderBasename}",
    mainClass = "${fileBasenameNoExtension}",
    args = function()
      local input = vim.fn.input "Arguments (space-separated): "
      return vim.split(input, " ")
    end,
  },
}

-- General DAP signs (icons in the gutter)
vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticError" })
vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "DiagnosticWarn" })
vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DiagnosticInfo" })
vim.fn.sign_define("DapStopped", { text = "", texthl = "DiagnosticHint" })
vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DiagnosticError" })

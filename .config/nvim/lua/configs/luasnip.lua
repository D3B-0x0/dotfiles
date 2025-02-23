local luasnip = require("luasnip")

-- Load snippets from the custom snippets directory
require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/lua/custom/snippets/" })

print("LuaSnip Loaded!")  -- Debugging line to check if it loads


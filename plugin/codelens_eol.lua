-- plugin/linya-codelens.lua

-- plugin/codelens_eol.lua
local group = vim.api.nvim_create_augroup('LinyaCodeLens', { clear = true })
local my_codelens = require('codelens_eol')

local function safe_attach(bufnr)
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  for _, client in ipairs(clients) do
    if client.server_capabilities.codeLensProvider then
      print('DEBUG: Attaching Linya-EOL to ' .. client.name)
      -- 1. Mute Neovim's default renderer
      vim.lsp.codelens.enable(false, { bufnr = bufnr })
      -- 2. Enable your custom renderer
      my_codelens.enable(true, { bufnr = bufnr })
      -- 3. Force a data fetch
      -- M.refresh({ bufnr = bufnr })
    end
  end
end

-- Trigger on every new LSP connection
vim.api.nvim_create_autocmd('LspAttach', {
  group = group,
  callback = function(args)
    vim.schedule(function()
      safe_attach(args.buf)
    end)
  end,
})

-- Trigger for files already open (the "Catch-Up")
vim.schedule(function()
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(bufnr) then
      safe_attach(bufnr)
    end
  end
end)

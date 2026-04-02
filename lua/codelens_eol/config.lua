local M = {}
local defaults = {
  enable = true,
}

M.config = vim.deepcopy(defaults)

function M.setup(opts)
  opts = opts or {}
  for k, v in pairs(opts.sections and opts.sections or {}) do
    if type(v) == 'boolean' and v then
      opts.sections[k] = nil
    end
  end
  M.config = vim.tbl_deep_extend('force', defaults, opts)
end

return M

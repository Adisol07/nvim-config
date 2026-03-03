local M = {
  opts = {
    results_dir = vim.fn.tempname(),
  },
}

local utils = require("adisol.local.flowingvector-code-training.utils")

local function save_training_context()
  local text = utils.get_buffer_context()

  local timestamp = os.date("%Y-%m-%d_%H-%M-%S")
  local filename = M.opts.results_dir .. "/" .. vim.fn.expand("%:t:r") .. "__" .. timestamp .. ".txt"

  local file = io.open(filename, "w")
  if not file then
    vim.notify("Failed to create file.", vim.log.levels.ERROR)
    return
  end
  file:write(text)
  file:close()

  vim.notify("Saved training context to: " .. filename)
end

function M.setup(opts)
  M.opts = vim.tbl_deep_extend("force", M.opts or {}, opts or {})
  utils.opts = M.opts

  vim.keymap.set("n", "<leader>stc", save_training_context, {
    desc = "[S]ave [T]raining [C]ontext",
  })
  vim.api.nvim_create_user_command("SaveToTemp", save_training_context, {})
end

return M

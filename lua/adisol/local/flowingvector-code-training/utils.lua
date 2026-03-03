local M = {}

function M.get_visual_text()
  local s = vim.fn.getpos("'<")
  local e = vim.fn.getpos("'>")
  local srow, scol = s[2], s[3]
  local erow, ecol = e[2], e[3]
  srow, scol, erow, ecol = M.normalize_range(srow, scol, erow, ecol)

  local chunks = vim.api.nvim_buf_get_text(0, srow - 1, math.max(scol - 1, 0), erow - 1, math.max(ecol, 0), {})
  return table.concat(chunks, "\n")
end

function M.get_buffer_text()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  return table.concat(lines, "\n")
end

local function get_line_text(index, line)
  return "<|line:" .. index .. ":line|> " .. line
end

function M.get_buffer_context()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local cursor_x = vim.api.nvim_win_get_cursor(0)[2]
  local cursor_y = vim.api.nvim_win_get_cursor(0)[1]
  local context = {}
  for i, line in ipairs(lines) do
    if i == cursor_y then
      local cursor_line = string.sub(line, 1, cursor_x) .. "<|cursor|> " .. string.sub(line, cursor_x + 1)
      context[i] = get_line_text(i, cursor_line)
    else
      context[i] = get_line_text(i, line)
    end
  end
  return table.concat(context, "\n")
end

return M

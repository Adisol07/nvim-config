local M = {}

function M.normalize_range(srow, scol, erow, ecol)
    if srow > erow or (srow == erow and scol > ecol) then
        return erow, ecol, srow, scol
    end
    return srow, scol, erow, ecol
end

function M.get_visual_text()
    local s = vim.fn.getpos("'<")
    local e = vim.fn.getpos("'>")
    local srow, scol = s[2], s[3]
    local erow, ecol = e[2], e[3]
    srow, scol, erow, ecol = M.normalize_range(srow, scol, erow, ecol)

    local chunks = vim.api.nvim_buf_get_text(
        0,
        srow - 1,
        math.max(scol - 1, 0),
        erow - 1,
        math.max(ecol, 0),
        {}
    )
    return table.concat(chunks, "\n")
end

return M

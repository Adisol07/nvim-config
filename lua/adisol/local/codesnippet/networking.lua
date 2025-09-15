local M = {}

function M.http_post(url, json_t)
    local json_body = vim.json.encode(json_t)
    local cmd = {
        "curl",
        "-s",
        "-X", "POST",
        "-H", "Content-Type: application/json",
        "-d", json_body,
        url,
    }
    local out = vim.fn.systemlist(cmd)
    local code = vim.v.shell_error
    if code ~= 0 then
        return { ok = false, body = table.concat(out, "\n"), err = "curl exited " .. code, }
    end
    return { ok = true, body = table.concat(out, "\n") }
end

return M

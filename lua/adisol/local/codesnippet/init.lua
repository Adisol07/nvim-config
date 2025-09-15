local M = {
    opts = {
        embedding_url = "http://localhost:1234/v1/embeddings",
        embedding_model = "text-embedding-embeddinggemma-300m-qat"
    },
}

local utils = require("adisol.local.codesnippet.utils")
local networking = require("adisol.local.codesnippet.networking")
local window = require("adisol.local.codesnippet.window")

local function create_cmds()
    vim.api.nvim_create_user_command("CodeSnippetCreate", function(cmd)
        M.embed_selection()
    end, { nargs = "?", complete = "file", range = true })
end

function M.setup(opts)
    M.opts = vim.tbl_deep_extend("force", M.opts or {}, opts or {})
    create_cmds()

    vim.keymap.set(
        "x",
        "<leader>cs",
        "<Esc>:'<,'>CodeSnippetCreate<CR>",
        { silent = true, desc = "CodeSnippet: Creates new snippet" }
    )
end

function M.embed_selection()
    local text = utils.get_visual_text()
    if not text or text == "" then
        vim.notify("CodeSnippet: Empty selection", vim.log.levels.WARN)
        return
    end
    vim.notify("Posting selection...", vim.log.levels.INFO)

    local payload = {
        model = M.opts.embedding_model,
        input = text
    }

    local resp = networking.http_post(M.opts.embedding_url, payload)

    if resp.ok then
        vim.notify("Snippet posted (" .. #text .. " chars)", vim.log.levels.INFO)
        window.open_creation_window(text)
    else
        vim.notify("POST failed: " .. (resp.err or resp.body), vim.log.levels.ERROR)
    end
end

return M

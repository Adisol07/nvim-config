local M = {}

function M.open_creation_window(snippetContent)
    local buf     = vim.api.nvim_create_buf(false, true)

    local width   = math.floor(vim.o.columns * 0.8)
    local height  = math.floor(vim.o.lines * 0.8)
    local row     = math.floor((vim.o.lines - height) / 2)
    local col     = math.floor((vim.o.columns - width) / 2)

    local win     = vim.api.nvim_open_win(buf, true, {
        relative  = 'editor',
        width     = width,
        height    = height,
        row       = row,
        col       = col,
        style     = 'minimal',
        border    = { '╔', '═', '╗', '║', '╝', '═', '╚', '║' },
        title     = ' Code Snippet ',
        title_pos = 'center',
    })

    local snippet = vim.split(snippetContent, '\n', { plain = true })
    local midline = #snippet + 3
    local content = vim.list_extend(snippet, {
        '',
        'Snippet Name: '
    })
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)

    vim.api.nvim_buf_attach(buf, false,
        {
            on_lines = function()
                vim.api.nvim_buf_set_option(buf, 'modifiable', (vim.fn.line('.') > 5))
            end
        })

    vim.api.nvim_buf_add_highlight(buf, -1, 'Directory', 0, 0, -1)

    local result, input_done = {}, false

    local collect_textbox = function()
        local lines = vim.api.nvim_buf_get_lines(buf, 5, -1, true)
        local last = #lines
        while last > 1 and lines[last]:match('^%s*$') do last = last - 1 end
        result = vim.list_slice(lines, 1, last)
        input_done = true
        vim.api.nvim_win_close(win, true)
        vim.notify(table.concat(result, '\n'), vim.log.levels.INFO)
    end

    local opts = { buffer = buf }
    vim.keymap.set({ 'n', 'i' }, '<C-s>', collect_textbox, opts)
    vim.keymap.set({ 'n', 'i' }, { '<Esc>', '<C-c>' }, function()
        input_done = true; result = nil;
        vim.api.nvim_win_close(win, true)
    end, opts)
end

return M

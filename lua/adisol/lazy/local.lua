local local_plugins = {
    {
        dir = "/Users/adisol/.config/nvim/lua/adisol/local/codesnippet",
        name = "CodeSnippet",
        config = function()
            require("adisol.local.codesnippet").setup({
            })
        end,
    },
}

return local_plugins

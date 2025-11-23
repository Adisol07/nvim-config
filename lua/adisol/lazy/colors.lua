function SetColorscheme(color)
    color = color or "rose-pine"
    vim.cmd.colorscheme(color)

    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

return {
    {
        "rose-pine/neovim",
        name = "rose-pine",
        config = function()
            require('rose-pine').setup({
                disable_background = true,
                styles = {
                    italic = false,
                },
            })

            -- SetColorscheme("rose-pine");
        end
    },
    {
        "vague-theme/vague.nvim",
        lazy = false,
        config = function()
            require("vague").setup({
                disable_background = true,
            })

            SetColorscheme("vague");
        end
    },
    {
        "uhs-robert/oasis.nvim",
        lazy = false,
        config = function()
            require("oasis").setup()

            -- SetColorscheme("oasis");
        end
    },
    {
        "scottmckendry/cyberdream.nvim",
        lazy = false,
        config = function()
            require("cyberdream").setup({
                disable_background = true,
            })

            -- SetColorscheme("cyberdream");
        end
    }
}

return {
  {
    "supermaven-inc/supermaven-nvim",
    event = "InsertEnter",
    config = function()
      require("supermaven-nvim").setup({
        keymaps = {
          accept_suggestion = "<Tab>",
          clear_suggestion = "<C-,>",
          accept_word = "<C-x>",
        },
        ignore_filetypes = {},
        color = {
          cterm = 244,
        },
        log_level = "off",
        disable_inline_completion = false,
        disable_keymaps = false,
      })
    end,
  },
}

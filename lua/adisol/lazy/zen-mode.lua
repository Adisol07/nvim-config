return {
  {
    "preservim/vim-pencil",
    ft = { "markdown", "text", "gitcommit" },
  },
  {
    "folke/zen-mode.nvim",
    cmd = { "ZenMode" },
    dependencies = {
      {
        "folke/twilight.nvim",
        opts = {},
      },
    },
    opts = {
      window = {
        backdrop = 1,
        width = 0.8,
        height = 0.8,
      },
      plugins = {
        twilight = { enabled = true },
        tmux = { enabled = true },
      },
    },
  },
}

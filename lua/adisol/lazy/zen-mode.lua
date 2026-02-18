return {
  {
    "folke/twilight.nvim",
    opts = {},
  },
  {
    "preservim/vim-pencil",
  },
  {
    "folke/zen-mode.nvim",
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

return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    {
      "<leader>a",
      function()
        local harpoon = require("harpoon")
        harpoon:list():add()
      end,
    },
    {
      "<C-e>",
      function()
        local harpoon = require("harpoon")
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end,
    },
  },
  config = function()
    local harpoon = require("harpoon")
    harpoon.setup()
  end,
}

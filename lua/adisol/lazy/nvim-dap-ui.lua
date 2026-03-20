return {
  "rcarriga/nvim-dap-ui",
  keys = {
    {
      "<leader>dt",
      function()
        require("dapui").toggle()
      end,
    },
  },
  cmd = { "DapUiToggle" },
  dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
  config = function()
    require("dapui").setup()
  end,
}

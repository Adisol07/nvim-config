return {
  "nicholasmata/nvim-dap-cs",
  ft = { "cs", "razor" },
  dependencies = { "mfussenegger/nvim-dap" },
  config = function()
    require("dap-cs").setup({
      dap_configurations = {
        {
          type = "coreclr",
          name = "Attach remote",
          mode = "remote",
          request = "attach",
        },
      },
      netcoredbg = {
        path = vim.fn.expand("~") .. "/netcoredbg/netcoredbg",
      },
    })
  end,
}

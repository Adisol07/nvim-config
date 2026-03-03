return {
  "seblyng/roslyn.nvim",
  ft = { "cs", "razor" },
  init = function()
    vim.lsp.config("roslyn", {
      settings = {
        ["csharp|background_analysis"] = {
          dotnet_analyzer_diagnostics_scope = "fullSolution",
          dotnet_compiler_diagnostics_scope = "fullSolution",
        },
      },
    })
  end,
  opts = {
    filewatching = "roslyn",
    lock_target = true,
    broad_search = false,
    silent = true,
  },
}

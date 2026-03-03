return {
  "seblyng/roslyn.nvim",
  ft = { "cs", "razor" },
  init = function()
    vim.lsp.config("roslyn", {
      flags = { debounce_text_changes = 150 },
      settings = {
        ["csharp|background_analysis"] = {
          dotnet_analyzer_diagnostics_scope = "openFiles",
          dotnet_compiler_diagnostics_scope = "openFiles",
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

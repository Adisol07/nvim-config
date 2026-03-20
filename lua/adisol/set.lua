vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false
vim.opt.wrap = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.cursorline = true
vim.opt.mouse = "a"
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

vim.opt.winborder = "rounded"

vim.g.netrw_banner = 0
vim.g.netrw_preview = 1
vim.g.netrw_winsize = 75

vim.opt.smartindent = true

vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.g.have_nerd_font = true

--  INFO: Using system clipboard:
-- vim.schedule(function()
--   vim.opt.clipboard = 'unnamedplus'
-- end)

vim.opt.scrolloff = 15
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.api.nvim_create_user_command("Sex", function()
  vim.cmd("vsplit")
  vim.cmd("term")
end, { bang = true })

vim.api.nvim_create_user_command("RoslynClients", function()
  local clients = vim.lsp.get_clients({ name = "roslyn" })
  if #clients == 0 then
    vim.notify("roslyn clients: 0", vim.log.levels.INFO)
    return
  end

  local lines = {}
  for _, client in ipairs(clients) do
    lines[#lines + 1] = string.format("%s %s", client.id, client.config.root_dir or "nil")
  end

  vim.notify("roslyn clients:\n" .. table.concat(lines, "\n"), vim.log.levels.INFO)
end, {})

local function formatMegabytes(value)
  return string.format("%.1f MB", value / (1024 * 1024))
end

local function getProcessLines()
  if vim.fn.executable("ps") ~= 1 then
    return { "processes: ps unavailable" }
  end

  local pids = { tostring(vim.uv.os_getpid()) }
  if vim.fn.executable("pgrep") == 1 then
    local child_pids = vim.fn.systemlist({ "pgrep", "-P", pids[1] })
    for _, pid in ipairs(child_pids) do
      if pid ~= "" then
        table.insert(pids, pid)
      end
    end
  end

  local command = { "ps", "-o", "pid=,rss=,comm=" }
  for _, pid in ipairs(pids) do
    table.insert(command, "-p")
    table.insert(command, pid)
  end

  local lines = vim.fn.systemlist(command)
  if vim.v.shell_error ~= 0 then
    return { "processes: unavailable" }
  end

  local process_lines = { "processes:" }
  for _, line in ipairs(lines) do
    local pid, rss, command_name = line:match("^%s*(%d+)%s+(%d+)%s+(.+)$")
    if pid and rss and command_name then
      process_lines[#process_lines + 1] = string.format(
        "  %s  %s  %s",
        pid,
        string.format("%.1f MB", tonumber(rss) / 1024),
        command_name
      )
    end
  end

  return process_lines
end

vim.api.nvim_create_user_command("NvimMemoryReport", function()
  local lines = {
    string.format("nvim rss: %s", formatMegabytes(vim.uv.resident_set_memory())),
  }

  local clients = vim.lsp.get_clients()
  if #clients == 0 then
    lines[#lines + 1] = "lsp clients: none"
  else
    lines[#lines + 1] = "lsp clients:"
    for _, client in ipairs(clients) do
      lines[#lines + 1] = string.format("  %s  %s", client.name, client.config.root_dir or "nil")
    end
  end

  local heavy_plugins = {
    "codecompanion.nvim",
    "supermaven-nvim",
    "nvim-dap",
    "nvim-dap-ui",
    "roslyn.nvim",
    "markdown-preview.nvim",
    "telescope.nvim",
    "oil.nvim",
    "trouble.nvim",
  }
  local ok, lazy_config = pcall(require, "lazy.core.config")
  if ok then
    lines[#lines + 1] = "heavy plugins:"
    for _, plugin_name in ipairs(heavy_plugins) do
      local plugin = lazy_config.plugins[plugin_name]
      local is_loaded = plugin and plugin._ and plugin._.loaded or false
      lines[#lines + 1] = string.format("  %s  %s", plugin_name, is_loaded and "loaded" or "idle")
    end
  end

  vim.list_extend(lines, getProcessLines())
  vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO, { title = "Nvim Memory Report", timeout = 10000 })
end, {})

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank({
      higroup = "YankHighlight",
      timeout = 200,
    })
  end,
})

--  INFO: Hiding commandline:
-- vim.o.laststatus = 3
-- vim.o.cmdheight = 0
-- vim.o.showmode = false
-- vim.o.showcmd = true
-- vim.o.showcmdloc = "statusline"

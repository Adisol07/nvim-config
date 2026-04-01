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

local function countEntries(items)
  local count = 0
  for _ in pairs(items or {}) do
    count = count + 1
  end

  return count
end

local function getBufferName(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  if name == "" then
    return "[No Name]"
  end

  return vim.fn.fnamemodify(name, ":~:.")
end

local function getBufferByteSize(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) or not vim.api.nvim_buf_is_loaded(bufnr) then
    return 0
  end

  local line_count = vim.api.nvim_buf_line_count(bufnr)
  if line_count == 0 then
    return 0
  end

  local ok, byte_size = pcall(vim.api.nvim_buf_get_offset, bufnr, line_count)
  if ok then
    return byte_size
  end

  local name = vim.api.nvim_buf_get_name(bufnr)
  if name == "" then
    return 0
  end

  local stats = vim.uv.fs_stat(name)
  if stats and stats.size then
    return stats.size
  end

  return 0
end

local function getVisibleBuffers()
  local visible_buffers = {}
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    visible_buffers[vim.api.nvim_win_get_buf(win)] = true
  end

  return visible_buffers
end

local function getLoadedBuffers()
  local visible_buffers = getVisibleBuffers()
  local buffers = {}

  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(bufnr) and vim.api.nvim_buf_is_loaded(bufnr) then
      buffers[#buffers + 1] = {
        bufnr = bufnr,
        name = getBufferName(bufnr),
        size = getBufferByteSize(bufnr),
        hidden = not visible_buffers[bufnr],
        modified = vim.bo[bufnr].modified,
        buftype = vim.bo[bufnr].buftype,
      }
    end
  end

  table.sort(buffers, function(left, right)
    if left.size == right.size then
      return left.bufnr < right.bufnr
    end

    return left.size > right.size
  end)

  return buffers
end

local function getEligibleHiddenBuffers()
  local current_buffer = vim.api.nvim_get_current_buf()
  local visible_buffers = getVisibleBuffers()
  local buffers = {}

  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(bufnr) and vim.api.nvim_buf_is_loaded(bufnr) then
      local name = vim.api.nvim_buf_get_name(bufnr)
      if bufnr ~= current_buffer and not visible_buffers[bufnr] and name ~= "" and vim.bo[bufnr].buftype == "" and not vim.bo[bufnr].modified then
        buffers[#buffers + 1] = {
          bufnr = bufnr,
          name = getBufferName(bufnr),
          size = getBufferByteSize(bufnr),
        }
      end
    end
  end

  table.sort(buffers, function(left, right)
    if left.size == right.size then
      return left.bufnr < right.bufnr
    end

    return left.size > right.size
  end)

  return buffers
end

local function getClientRoot(client)
  if client.config and client.config.root_dir and client.config.root_dir ~= "" then
    return client.config.root_dir
  end

  return "nil"
end

local function getClientBufferCount(client)
  return countEntries(client.attached_buffers)
end

local function unloadHiddenBuffers()
  local unloaded_buffers = {}
  local failed_buffers = {}

  for _, buffer in ipairs(getEligibleHiddenBuffers()) do
    local ok, error_message = pcall(vim.api.nvim_buf_delete, buffer.bufnr, { unload = true })
    if ok then
      unloaded_buffers[#unloaded_buffers + 1] = buffer
    else
      failed_buffers[#failed_buffers + 1] = {
        name = buffer.name,
        error = error_message,
      }
    end
  end

  return unloaded_buffers, failed_buffers
end

local function stopIdleLspClients()
  local stopped_clients = {}
  local failed_clients = {}

  for _, client in ipairs(vim.lsp.get_clients()) do
    if getClientBufferCount(client) == 0 and not client:is_stopped() then
      local ok, error_message = pcall(function()
        client:stop()
      end)

      if ok then
        stopped_clients[#stopped_clients + 1] = {
          name = client.name,
          root_dir = getClientRoot(client),
        }
      else
        failed_clients[#failed_clients + 1] = {
          name = client.name,
          error = error_message,
        }
      end
    end
  end

  return stopped_clients, failed_clients
end

vim.api.nvim_create_user_command("NvimMemoryReport", function()
  local loaded_buffers = getLoadedBuffers()
  local total_loaded_bytes = 0
  local hidden_loaded_bytes = 0
  local hidden_loaded_count = 0

  for _, buffer in ipairs(loaded_buffers) do
    total_loaded_bytes = total_loaded_bytes + buffer.size
    if buffer.hidden then
      hidden_loaded_bytes = hidden_loaded_bytes + buffer.size
      hidden_loaded_count = hidden_loaded_count + 1
    end
  end

  local lines = {
    string.format("nvim rss: %s", formatMegabytes(vim.uv.resident_set_memory())),
    string.format(
      "buffers: %d loaded / %d total  (%d hidden loaded)",
      #loaded_buffers,
      #vim.api.nvim_list_bufs(),
      hidden_loaded_count
    ),
    string.format(
      "buffer payload: %s loaded / %s hidden",
      formatMegabytes(total_loaded_bytes),
      formatMegabytes(hidden_loaded_bytes)
    ),
  }

  if #loaded_buffers > 0 then
    lines[#lines + 1] = "largest loaded buffers:"
    for index = 1, math.min(#loaded_buffers, 8) do
      local buffer = loaded_buffers[index]
      local labels = {}
      labels[#labels + 1] = buffer.hidden and "hidden" or "visible"
      if buffer.modified then
        labels[#labels + 1] = "modified"
      end
      if buffer.buftype ~= "" then
        labels[#labels + 1] = buffer.buftype
      end

      lines[#lines + 1] = string.format(
        "  %s  [%s]  %s",
        formatMegabytes(buffer.size),
        table.concat(labels, ", "),
        buffer.name
      )
    end
  end

  local clients = vim.lsp.get_clients()
  if #clients == 0 then
    lines[#lines + 1] = "lsp clients: none"
  else
    table.sort(clients, function(left, right)
      if left.name == right.name then
        return getClientRoot(left) < getClientRoot(right)
      end

      return left.name < right.name
    end)

    lines[#lines + 1] = "lsp clients:"
    for _, client in ipairs(clients) do
      local attached_buffers = getClientBufferCount(client)
      local client_state = attached_buffers == 0 and "idle" or string.format("%d buffers", attached_buffers)
      lines[#lines + 1] = string.format("  %s  %s  %s", client.name, client_state, getClientRoot(client))
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

vim.api.nvim_create_user_command("NvimUnloadHiddenBuffers", function()
  local unloaded_buffers, failed_buffers = unloadHiddenBuffers()
  local lines = {
    string.format("unloaded hidden buffers: %d", #unloaded_buffers),
  }

  for index = 1, math.min(#unloaded_buffers, 8) do
    local buffer = unloaded_buffers[index]
    lines[#lines + 1] = string.format("  %s  %s", formatMegabytes(buffer.size), buffer.name)
  end

  if #failed_buffers > 0 then
    lines[#lines + 1] = string.format("failed to unload: %d", #failed_buffers)
  end

  vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO, { title = "Hidden Buffer Cleanup", timeout = 10000 })
end, {})

vim.api.nvim_create_user_command("NvimStopIdleLsp", function()
  local stopped_clients, failed_clients = stopIdleLspClients()
  local lines = {
    string.format("stopped idle lsp clients: %d", #stopped_clients),
  }

  for index = 1, math.min(#stopped_clients, 8) do
    local client = stopped_clients[index]
    lines[#lines + 1] = string.format("  %s  %s", client.name, client.root_dir)
  end

  if #failed_clients > 0 then
    lines[#lines + 1] = string.format("failed to stop: %d", #failed_clients)
  end

  vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO, { title = "Idle LSP Cleanup", timeout = 10000 })
end, {})

vim.api.nvim_create_user_command("NvimMemoryCleanup", function()
  local unloaded_buffers, failed_buffers = unloadHiddenBuffers()

  vim.schedule(function()
    local stopped_clients, failed_clients = stopIdleLspClients()
    local lines = {
      string.format("unloaded hidden buffers: %d", #unloaded_buffers),
      string.format("stopped idle lsp clients: %d", #stopped_clients),
    }

    if #failed_buffers > 0 then
      lines[#lines + 1] = string.format("buffer unload failures: %d", #failed_buffers)
    end

    if #failed_clients > 0 then
      lines[#lines + 1] = string.format("lsp stop failures: %d", #failed_clients)
    end

    vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO, { title = "Nvim Memory Cleanup", timeout = 10000 })
  end)
end, {})

vim.api.nvim_create_autocmd("LspDetach", {
  group = vim.api.nvim_create_augroup("adisol-lsp-idle-cleanup", { clear = true }),
  callback = function(event)
    if event.data == nil or event.data.client_id == nil then
      return
    end

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client == nil then
      return
    end

    vim.schedule(function()
      if client:is_stopped() then
        return
      end

      if getClientBufferCount(client) == 0 then
        client:stop()
      end
    end)
  end,
})

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

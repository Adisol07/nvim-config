local transparent = true
local appearanceMode = "dark"
local appearanceTimer = nil
local appearanceAuGroup = vim.api.nvim_create_augroup("adisol-appearance", { clear = true })

local themeByMode = {
  dark = "night-owl",
  light = "rose-pine-dawn",
}

local defaultPalettes = {
  dark = {
    background = "#090909",
    statuslineBackground = "#101318",
    statuslineInactiveBackground = "#0b0e14",
    cursorlineBackground = "#202020",
    yank = {
      fg = "#101318",
      bg = "#ecc48d",
      bold = true,
    },
  },
  light = {
    background = "#f7f7f7",
    statuslineBackground = "#ece7de",
    statuslineInactiveBackground = "#f3efe8",
    cursorlineBackground = "#efe9df",
    yank = {
      fg = "#f7f7f7",
      bg = "#907aa9",
      bold = true,
    },
  },
}

local backgroundOverrides = {
  dark = nil,
  light = nil,
}

local function getAppearanceMode()
  return appearanceMode or "dark"
end

local function getPalette(mode)
  local palette = vim.deepcopy(defaultPalettes[mode or getAppearanceMode()])
  local backgroundOverride = backgroundOverrides[mode or getAppearanceMode()]
  if backgroundOverride ~= nil then
    palette.background = backgroundOverride
  end

  return palette
end

local function applyHighlights(mode)
  local palette = getPalette(mode)
  local statusline = vim.api.nvim_get_hl(0, { name = "StatusLine", link = false })
  local statuslineNc = vim.api.nvim_get_hl(0, { name = "StatusLineNC", link = false })
  local normalBackground = transparent and "none" or palette.background

  vim.api.nvim_set_hl(0, "Normal", { bg = normalBackground })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = normalBackground })
  vim.api.nvim_set_hl(0, "SignColumn", { bg = normalBackground })
  vim.api.nvim_set_hl(0, "StatusLine", {
    fg = statusline.fg,
    bg = palette.statuslineBackground,
    bold = statusline.bold,
  })
  vim.api.nvim_set_hl(0, "StatusLineNC", {
    fg = statuslineNc.fg,
    bg = palette.statuslineInactiveBackground,
    bold = statuslineNc.bold,
  })
  vim.api.nvim_set_hl(0, "CursorLine", { bg = palette.cursorlineBackground })
  vim.api.nvim_set_hl(0, "YankHighlight", palette.yank)
end

local function DetectAppearance()
  vim.fn.system({ "defaults", "read", "-g", "AppleInterfaceStyle" })

  if vim.v.shell_error == 0 then
    return "dark"
  end

  return "light"
end

local function ApplyAppearanceTheme(mode)
  local nextMode = mode or DetectAppearance()
  local colorscheme = themeByMode[nextMode] or themeByMode.dark

  appearanceMode = nextMode
  vim.g.AppearanceMode = nextMode
  vim.opt.background = nextMode

  local ok, errorMessage = pcall(vim.cmd.colorscheme, colorscheme)
  if not ok then
    vim.notify(errorMessage, vim.log.levels.ERROR)
    return
  end

  applyHighlights(nextMode)
end

local function SyncAppearanceTheme()
  local nextMode = DetectAppearance()
  if nextMode ~= getAppearanceMode() then
    ApplyAppearanceTheme(nextMode)
    return
  end

  applyHighlights(nextMode)
end

local function StartAppearanceWatcher()
  if appearanceTimer ~= nil then
    return
  end

  appearanceTimer = vim.uv.new_timer()
  if appearanceTimer == nil then
    return
  end

  appearanceTimer:start(5000, 5000, vim.schedule_wrap(SyncAppearanceTheme))

  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = appearanceAuGroup,
    callback = function()
      if appearanceTimer == nil then
        return
      end

      appearanceTimer:stop()
      appearanceTimer:close()
      appearanceTimer = nil
    end,
  })
end

function SetColorscheme(color)
  local nextMode = getAppearanceMode()

  if color == themeByMode.light then
    nextMode = "light"
  elseif color == themeByMode.dark then
    nextMode = "dark"
  end

  appearanceMode = nextMode
  vim.g.AppearanceMode = nextMode
  vim.opt.background = nextMode
  vim.cmd.colorscheme(color or themeByMode[nextMode])
  applyHighlights(nextMode)
end

function ToggleTransparency()
  transparent = not transparent
  applyHighlights(getAppearanceMode())
end

function SetBackground(color)
  backgroundOverrides[getAppearanceMode()] = color
  applyHighlights(getAppearanceMode())
end

function ResetBackground()
  backgroundOverrides[getAppearanceMode()] = nil
  applyHighlights(getAppearanceMode())
end

function Hiroshima()
  transparent = false
  appearanceMode = "dark"
  vim.g.AppearanceMode = "dark"
  vim.opt.background = "dark"
  vim.cmd.colorscheme("tokyonight")
  applyHighlights("dark")
end

return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = true,
    config = function()
      require("rose-pine").setup({
        disable_background = true,
        styles = {
          italic = false,
        },
      })

      -- SetColorscheme("rose-pine");
    end,
  },
  {
    "vague-theme/vague.nvim",
    lazy = true,
    config = function()
      require("vague").setup({
        disable_background = true,
      })

      -- SetColorscheme("vague")
    end,
  },
  {
    "oxfist/night-owl.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("night-owl").setup()
      pcall(vim.api.nvim_del_user_command, "ThemeSync")
      vim.api.nvim_create_user_command("ThemeSync", SyncAppearanceTheme, {})
      ApplyAppearanceTheme(DetectAppearance())
      StartAppearanceWatcher()
    end,
  },
  {
    "uhs-robert/oasis.nvim",
    lazy = true,
    config = function()
      require("oasis").setup()

      -- SetColorscheme("oasis");
    end,
  },
  {
    "scottmckendry/cyberdream.nvim",
    lazy = true,
    config = function()
      require("cyberdream").setup({
        disable_background = true,
      })

      -- SetColorscheme("cyberdream");
    end,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    config = function()
      -- require("catppuccin").setup({
      --   disable_background = true,
      -- })

      -- require("catppuccin").setup({
      --   flavour = "mocha",
      --   disable_background = true,
      --   color_overrides = {
      --     mocha = {
      --       base = "#171721",
      --       mantle = "#1e1e2a",
      --       crust = "#10101a",
      --       text = "#dddde5",
      --       mauve = "#8da4f5",
      --       blue = "#77becf",
      --       sapphire = "#77becf",
      --       green = "#77c599",
      --       peach = "#fc9b6f",
      --       red = "#fc92b4",
      --       overlay1 = "#9d9da8",
      --       overlay2 = "#c3c3cc",
      --     },
      --   },
      -- })

      -- SetColorscheme("catppuccin-mocha")
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = true,
    config = function()
      require("kanagawa").setup({
        theme = "wave",
      })

      -- SetColorscheme("kanagawa")
      -- vim.cmd("KanagawaCompile")
    end,
  },
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = {},
  },
  {
    "mellow-theme/mellow.nvim",
    lazy = true,
    config = function()
      -- SetColorscheme("mellow")
    end,
  },
}

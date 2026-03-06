local transparent = true
local background = "#090909"
local statuslineBackground = "#101318"
local statuslineInactiveBackground = "#0b0e14"

function SetColorscheme(color)
  color = color or "rose-pine"
  vim.cmd.colorscheme(color)

  local statusline = vim.api.nvim_get_hl(0, { name = "StatusLine", link = false })
  local statusline_nc = vim.api.nvim_get_hl(0, { name = "StatusLineNC", link = false })

  if transparent then
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
    vim.api.nvim_set_hl(0, "StatusLine", { fg = statusline.fg, bg = statuslineBackground, bold = statusline.bold })
    vim.api.nvim_set_hl(0, "StatusLineNC", { fg = statusline_nc.fg, bg = statuslineInactiveBackground, bold = statusline_nc.bold })
  else
    vim.api.nvim_set_hl(0, "Normal", { bg = background })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = background })
    vim.api.nvim_set_hl(0, "SignColumn", { bg = background })
    vim.api.nvim_set_hl(0, "StatusLine", { fg = statusline.fg, bg = statuslineBackground, bold = statusline.bold })
    vim.api.nvim_set_hl(0, "StatusLineNC", { fg = statusline_nc.fg, bg = statuslineInactiveBackground, bold = statusline_nc.bold })
  end

  vim.api.nvim_set_hl(0, "CursorLine", {
    bg = "#202020",
  })
  vim.api.nvim_set_hl(0, "YankHighlight", {
    fg = "#101318",
    bg = "#ecc48d",
    bold = true,
  })
end

function ToggleTransparency()
  transparent = not transparent

  if transparent then
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
    vim.api.nvim_set_hl(0, "StatusLine", { bg = statuslineBackground })
    vim.api.nvim_set_hl(0, "StatusLineNC", { bg = statuslineInactiveBackground })
  else
    vim.api.nvim_set_hl(0, "Normal", { bg = background })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = background })
    vim.api.nvim_set_hl(0, "SignColumn", { bg = background })
    vim.api.nvim_set_hl(0, "StatusLine", { bg = statuslineBackground })
    vim.api.nvim_set_hl(0, "StatusLineNC", { bg = statuslineInactiveBackground })
  end
end

function SetBackground(color)
  background = color
  vim.api.nvim_set_hl(0, "Normal", { bg = background })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = background })
  vim.api.nvim_set_hl(0, "SignColumn", { bg = background })
  vim.api.nvim_set_hl(0, "StatusLine", { bg = statuslineBackground })
  vim.api.nvim_set_hl(0, "StatusLineNC", { bg = statuslineInactiveBackground })
end

function ResetBackground()
  background = "#090909"
  vim.api.nvim_set_hl(0, "Normal", { bg = background })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = background })
  vim.api.nvim_set_hl(0, "SignColumn", { bg = background })
  vim.api.nvim_set_hl(0, "StatusLine", { bg = statuslineBackground })
  vim.api.nvim_set_hl(0, "StatusLineNC", { bg = statuslineInactiveBackground })
end

function Hiroshima()
  transparent = false
  vim.cmd.colorscheme("tokyonight")
  local normal_hl = vim.api.nvim_get_hl(0, { name = "Normal" })
  if normal_hl.bg then
    background = string.format("#%06x", normal_hl.bg)
    vim.api.nvim_set_hl(0, "Normal", { bg = background })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = background })
    vim.api.nvim_set_hl(0, "SignColumn", { bg = background })
    vim.api.nvim_set_hl(0, "StatusLine", { bg = statuslineBackground })
    vim.api.nvim_set_hl(0, "StatusLineNC", { bg = statuslineInactiveBackground })
  end
end

return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
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
    lazy = false,
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

      SetColorscheme("night-owl")
    end,
  },
  {
    "uhs-robert/oasis.nvim",
    lazy = false,
    config = function()
      require("oasis").setup()

      -- SetColorscheme("oasis");
    end,
  },
  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
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
    lazy = false,
    config = function()
      require("catppuccin").setup({
        disable_background = true,
      })

      -- SetColorscheme("catppuccin-mocha")
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
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
    lazy = false,
    opts = {},
  },
  {
    "mellow-theme/mellow.nvim",
    lazy = false,
    config = function()
      -- SetColorscheme("mellow")
    end,
  },
}

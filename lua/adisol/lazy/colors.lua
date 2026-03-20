local transparent = true
local background = "#090909"
-- local background = "#05041A"
local statuslineBackground = "#101318"
-- local statuslineBackground = "#0B0E37"
local statuslineInactiveBackground = "#0b0e14"
-- local statuslineInactiveBackground = "#050336"
local cursorlineBackground = "#202020"
-- local cursorlineBackground = "#050336"

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
    vim.api.nvim_set_hl(
      0,
      "StatusLineNC",
      { fg = statusline_nc.fg, bg = statuslineInactiveBackground, bold = statusline_nc.bold }
    )
  else
    vim.api.nvim_set_hl(0, "Normal", { bg = background })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = background })
    vim.api.nvim_set_hl(0, "SignColumn", { bg = background })
    vim.api.nvim_set_hl(0, "StatusLine", { fg = statusline.fg, bg = statuslineBackground, bold = statusline.bold })
    vim.api.nvim_set_hl(
      0,
      "StatusLineNC",
      { fg = statusline_nc.fg, bg = statuslineInactiveBackground, bold = statusline_nc.bold }
    )
  end
  ResetBackground()

  vim.api.nvim_set_hl(0, "CursorLine", {
    bg = cursorlineBackground,
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
  -- background = "#05041A"
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

      SetColorscheme("night-owl")
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

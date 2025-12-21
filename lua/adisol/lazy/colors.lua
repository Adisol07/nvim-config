local transparent = false
local colormode = true

function SetColorscheme(color)
  color = color or "rose-pine"
  vim.cmd.colorscheme(color)

  if transparent then
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
  else
    if colormode then
      vim.api.nvim_set_hl(0, "Normal", { bg = "#000000" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#000000" })
      vim.api.nvim_set_hl(0, "SignColumn", { bg = "#000000" })
    else
      vim.api.nvim_set_hl(0, "Normal", { bg = "#FFFFFF" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#FFFFFF" })
      vim.api.nvim_set_hl(0, "SignColumn", { bg = "#FFFFFF" })
    end
  end
end

function ToggleTransparency()
  transparent = not transparent

  if transparent then
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
  else
    if colormode then
      vim.api.nvim_set_hl(0, "Normal", { bg = "#000000" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#000000" })
      vim.api.nvim_set_hl(0, "SignColumn", { bg = "#000000" })
    else
      vim.api.nvim_set_hl(0, "Normal", { bg = "#FFFFFF" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#FFFFFF" })
      vim.api.nvim_set_hl(0, "SignColumn", { bg = "#FFFFFF" })
    end
  end
end

function ToggleColormode()
  colormode = not colormode
  if colormode then
    SetColorscheme("vague")
  else
    SetColorscheme("catppuccin-latte")
  end
  ToggleTransparency()
  ToggleTransparency()
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

      SetColorscheme("vague")
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
    end,
  },
}

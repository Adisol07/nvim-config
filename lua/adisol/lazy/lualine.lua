return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local palette = {
        background = '#101318',
        inactive = '#0b0e14',
        surface = '#171b24',
        surface_alt = '#1d2330',
        text = '#d6deeb',
        muted = '#7f8c98',
        blue = '#82aaff',
        cyan = '#7fdbca',
        green = '#22da6e',
        yellow = '#ecc48d',
        red = '#ff5874',
        purple = '#c792ea',
      }

      local function getHighlight(name)
        local ok, highlight = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
        if not ok then
          return {}
        end

        return highlight
      end

      local function toHex(value)
        if type(value) ~= 'number' then
          return nil
        end

        return string.format('#%06x', value)
      end

      local function makeSection(highlight, background, foreground)
        return {
          fg = foreground or toHex(highlight.fg),
          bg = toHex(background),
          gui = highlight.bold and 'bold' or nil,
        }
      end

      local function makeTheme()
        local active = makeSection(getHighlight('StatusLine'), palette.background, palette.text)
        local inactive = makeSection(getHighlight('StatusLineNC'), palette.inactive, palette.muted)

        return {
          normal = {
            a = { fg = palette.background, bg = palette.blue, gui = 'bold' },
            b = { fg = palette.text, bg = palette.surface },
            c = active,
            x = { fg = palette.text, bg = palette.surface },
            y = { fg = palette.background, bg = palette.cyan, gui = 'bold' },
            z = { fg = palette.background, bg = palette.yellow, gui = 'bold' },
          },
          insert = {
            a = { fg = palette.background, bg = palette.green, gui = 'bold' },
            b = { fg = palette.text, bg = palette.surface },
            c = active,
            x = { fg = palette.text, bg = palette.surface },
            y = { fg = palette.background, bg = palette.cyan, gui = 'bold' },
            z = { fg = palette.background, bg = palette.yellow, gui = 'bold' },
          },
          visual = {
            a = { fg = palette.background, bg = palette.purple, gui = 'bold' },
            b = { fg = palette.text, bg = palette.surface },
            c = active,
            x = { fg = palette.text, bg = palette.surface },
            y = { fg = palette.background, bg = palette.cyan, gui = 'bold' },
            z = { fg = palette.background, bg = palette.yellow, gui = 'bold' },
          },
          replace = {
            a = { fg = palette.background, bg = palette.red, gui = 'bold' },
            b = { fg = palette.text, bg = palette.surface },
            c = active,
            x = { fg = palette.text, bg = palette.surface },
            y = { fg = palette.background, bg = palette.cyan, gui = 'bold' },
            z = { fg = palette.background, bg = palette.yellow, gui = 'bold' },
          },
          command = {
            a = { fg = palette.background, bg = palette.yellow, gui = 'bold' },
            b = { fg = palette.text, bg = palette.surface },
            c = active,
            x = { fg = palette.text, bg = palette.surface },
            y = { fg = palette.background, bg = palette.cyan, gui = 'bold' },
            z = { fg = palette.background, bg = palette.yellow, gui = 'bold' },
          },
          terminal = {
            a = { fg = palette.background, bg = palette.cyan, gui = 'bold' },
            b = { fg = palette.text, bg = palette.surface },
            c = active,
            x = { fg = palette.text, bg = palette.surface },
            y = { fg = palette.background, bg = palette.cyan, gui = 'bold' },
            z = { fg = palette.background, bg = palette.yellow, gui = 'bold' },
          },
          inactive = {
            a = inactive,
            b = { fg = palette.muted, bg = palette.inactive },
            c = inactive,
            x = { fg = palette.muted, bg = palette.inactive },
            y = { fg = palette.muted, bg = palette.inactive },
            z = { fg = palette.muted, bg = palette.inactive },
          },
        }
      end

      local function setup()
        require('lualine').setup({
          options = {
            icons_enabled = vim.g.have_nerd_font,
            theme = makeTheme(),
            component_separators = { left = '░', right = '░' },
            section_separators = { left = '░', right = '░' },
            globalstatus = true,
          },
          sections = {
            lualine_a = {
              {
                'mode',
                separator = { right = '▓' },
                padding = { left = 1, right = 1 },
              },
            },
            lualine_b = {
              {
                'branch',
                icon = '',
                separator = { right = '▒' },
              },
              {
                'diff',
                symbols = { added = '+', modified = '~', removed = '-' },
                diff_color = {
                  added = { fg = palette.green },
                  modified = { fg = palette.yellow },
                  removed = { fg = palette.red },
                },
              },
            },
            lualine_c = {
              {
                'filename',
                icon = '󰈔',
                file_status = true,
                newfile_status = true,
                path = 0,
                separator = '',
              },
              {
                'diagnostics',
                sources = { 'nvim_diagnostic' },
                sections = { 'error', 'warn', 'info', 'hint' },
                symbols = vim.g.have_nerd_font
                    and { error = ' ', warn = ' ', info = ' ', hint = '󰌵 ' }
                  or { error = 'E:', warn = 'W:', info = 'I:', hint = 'H:' },
                always_visible = false,
                colored = true,
                update_in_insert = false,
                separator = '',
                diagnostics_color = {
                  error = { fg = palette.red },
                  warn = { fg = palette.yellow },
                  info = { fg = palette.blue },
                  hint = { fg = palette.cyan },
                },
              },
            },
            lualine_x = {
              {
                'filetype',
                icon_only = false,
                separator = { left = '▒' },
              },
              {
                'encoding',
                fmt = string.upper,
              },
            },
            lualine_y = {
              {
                'progress',
                separator = { left = '▒' },
              },
            },
            lualine_z = {
              {
                'location',
                separator = { left = '▓' },
              },
            },
          },
          inactive_sections = {
            lualine_a = {},
            lualine_b = {
              {
                'filename',
                file_status = true,
                newfile_status = true,
                path = 0,
              },
            },
            lualine_c = {},
            lualine_x = { 'filetype' },
            lualine_y = {},
            lualine_z = { 'location' },
          },
        })
      end

      setup()

      vim.api.nvim_create_autocmd('ColorScheme', {
        callback = setup,
      })
    end,
}

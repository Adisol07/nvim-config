return {
    "olimorris/codecompanion.nvim",
    opts = {
        cmd = { 'CodeCompanion', 'CodeCompanionActions', 'CodeCompanionChat' },

        adapters = {
            http = {
                anthropic = function()
                    return require("codecompanion.adapters").extend("anthropic", {
                        env = {
                            api_key = "cmd: echo $CODECOMPANION_ANTHROPIC_API_KEY",
                        },
                        schema = {
                            model = {
                                default = 'claude-3-5-sonnet-20241022',
                            },
                        },
                    })
                end,
                openai = function()
                    return require("codecompanion.adapters").extend("openai", {
                        env = {
                            api_key = "cmd: echo $CODECOMPANION_OPENAI_API_KEY",
                        },
                        schema = {
                            model = {
                                default = 'gpt-5-mini',
                            },
                            reasoning_effort = {
                                default = 'low',
                            },
                        },
                    })
                end,
                tavily = function()
                    return require('codecompanion.adapters').extend('tavily', {
                        env = {
                            api_key = 'cmd: echo $CODECOMPANION_TAVILY_API_KEY',
                        },
                        opts = {
                            topic = 'general',
                            search_depth = 'advanced',
                            chunks_per_source = 3,
                            max_results = 15,
                            include_answer = true,
                            include_raw_content = true,
                        },
                    })
                end,
                openrouter = function()
                    return require("codecompanion.adapters").extend("openai_compatible", {
                        name = 'openrouter',
                        env = {
                            url = "https://openrouter.ai/api",
                            api_key = "cmd: echo $CODECOMPANION_OPENROUTER_API_KEY",
                            chat_url = "/v1/chat/completions",
                        },
                        schema = {
                            model = {
                                default = "x-ai/grok-3-mini",
                            },
                        },
                    })
                end,
            }
        },

        strategies = {
            chat = {
                adapter = 'openai',
            },
            -- inline = {
            --     adapter = "copilot",
            -- },
            -- cmd = {
            --     adapter = "deepseek",
            -- }
        },

        display = {
            chat = {
                window = {
                    position = "right",
                }
            }
        },

        extensions = {
            history = {
                enabled = true,
                opts = {
                    keymap = 'gh',
                    save_chat_keymap = 'sc',
                    auto_save = true,
                    expiration_days = 0,
                    picker = 'telescope',
                    auto_generate_title = true,
                    title_generation_opts = {
                        adapter = nil,
                        model = nil,
                    },
                    continue_last_chat = false,
                    delete_on_clearing_chat = false,
                    dir_to_save = vim.fn.stdpath 'data' .. '/codecompanion-history',
                    enable_logging = false,
                },
            },
        },
    },
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-treesitter/nvim-treesitter',
        'ravitemer/codecompanion-history.nvim',
        'nvim-cmp',
    },
}

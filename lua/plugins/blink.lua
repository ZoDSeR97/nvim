return {
    {
        "saghen/blink.cmp",
        lazy = false,
        version = "*", -- use a release tag for pre-built binaries
        dependencies = {
            "rafamadriz/friendly-snippets",
        },

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            -- Keymap preset: use Tab/S-Tab to navigate, Enter to confirm
            keymap = {
                preset = "default",
                ["<Tab>"]   = { "select_next", "snippet_forward", "fallback" },
                ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
                ["<CR>"]    = { "accept", "fallback" },
                ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
                ["<C-e>"]   = { "hide" },
                ["<C-b>"]   = { "scroll_documentation_up", "fallback" },
                ["<C-f>"]   = { "scroll_documentation_down", "fallback" },
            },

            appearance = {
                -- Use Nerd Font icons
                use_nvim_cmp_as_default = false,
                nerd_font_variant = "mono",
            },

            completion = {
                -- Show documentation popup automatically
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 200,
                },
                -- Ghost text (inline preview)
                ghost_text = {
                    enabled = true,
                },
                menu = {
                    border = "rounded",
                    draw = {
                        treesitter = { "lsp" },
                        columns = {
                            { "label", "label_description", gap = 1 },
                            { "kind_icon", "kind" },
                        },
                    },
                },
            },

            -- Sources: LSP, snippets, path, buffer
            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
                providers = {
                lsp = {
                    name = "LSP",
                    module = "blink.cmp.sources.lsp",
                    score_offset = 5,
                },
                path = {
                    name = "Path",
                    module = "blink.cmp.sources.path",
                    score_offset = 3,
                    opts = {
                        -- Windows uses backslash; blink handles this automatically
                        get_cwd = function(_) 
                            return vim.fn.getcwd()
                        end,
                    },
                },
                snippets = {
                    name = "Snippets",
                    module = "blink.cmp.sources.snippets",
                    score_offset = 2,
                },
                buffer = {
                    name = "Buffer",
                    module = "blink.cmp.sources.buffer",
                    score_offset = 0,
                },
                },
            },

            -- Let blink handle LSP capabilities for you
            signature = { enabled = true },
        },

        -- Wire blink into nvim-lspconfig
        opts_extend = { "sources.default" },
    },
}
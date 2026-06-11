return {
    {
        "windwp/nvim-ts-autotag",
        enabled = true,
        ft = { "html", "xml", "javascript", "typescript", "javascriptreact", "typescriptreact", "svelte" },
        config = function()
            require("nvim-ts-autotag").setup({
                opts = {
                    enable_close = true,           -- Auto-close tags
                    enable_rename = true,          -- Auto-rename pairs
                    enable_close_on_slash = false, -- Disable auto-close on trailing `</`
                },
                per_filetype = {
                    ["html"] = {
                        enable_close = true,
                    },
                    ["typescriptreact"] = {
                        enable_close = true,
                    },
                },
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        dependencies = {
            "windwp/nvim-ts-autotag",
        },
        lazy = false,
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter").setup({
                highlight = { enable = true },
                indent = { enable = true },
                autotag = { enable = true },
                ensure_installed = {
                    "json", "python", "ron", "javascript", "haskell", "d", "query",
                    "typescript", "tsx", "rust", "zig", "php", "yaml", "html", "css",
                    "markdown", "markdown_inline", "bash", "lua", "vim", "vimdoc", "c",
                    "dockerfile", "gitignore", "astro", "go", "templ"
                },
                auto_install = false,
            })

            -- Safe FileType autocmd for highlighting + indentation
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "*",
                callback = function(args)
                    local buf = args.buf
                    local ft = vim.bo[buf].filetype

                    local lang = vim.treesitter.language.get_lang(ft)
                    if not lang then
                        return
                    end

                    -- start treesitter safely
                    pcall(vim.treesitter.start, buf, lang)

                    -- enable indentation (skip yaml/markdown)
                    if ft ~= "yaml" and ft ~= "markdown" then
                        vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                        vim.bo[buf].smartindent = false
                        vim.bo[buf].cindent = false
                    end
                end,
            })
        end
    }
}

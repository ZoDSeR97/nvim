return {
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
    end,
}
vim.pack.add({
    "https://github.com/mason-org/mason.nvim",
    "https://github.com/mason-org/mason-lspconfig.nvim",
    "https://github.com/neovim/nvim-lspconfig", -- Still needed for baseline metadata mappings
    "https://github.com/mrcjkb/rustaceanvim"
})

local servers = {
    "bashls",
    "gopls",
    "lua_ls",
    "texlab",
    "ts_ls",
    "helm_ls",
    "rust_analyzer", -- Note: internal mason name uses underscore, not hyphen
    "clangd"
}

-- Mason
require("mason").setup({
    ui = {
        border = "rounded",
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    },
})

-- Mason lspconfig bridge
require("mason-lspconfig").setup({
    ensure_installed = servers,
    automatic_installation = true,
})

-- Global LSP Diagnostic UI Tweaks
vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = { border = "rounded" },
})

vim.lsp.config("*", {
    capabilities = vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(),
        require("mini.completion").get_lsp_capabilities())
})

-- C / C++
vim.lsp.config("clangd", {
    -- Override encoding arrays to prevent common system console rendering encoding conflicts
    capabilities = {
        offsetEncoding = { "utf-16" },
    },
})

-- BASH
vim.lsp.config("bashls", {})

-- GO
vim.lsp.config("gopls", {
    settings = {
        gopls = {
            analyses = {
                unusedparams = true, -- Warn about unused parameters
                shadow = true,       -- Warn about variable shadowing
            },
            staticcheck = true,      -- Enables advanced static analysis
            gofumpt = true,          -- Uses stricter standard formatting rules
        },
    },
})

-- LUA
vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" },
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            },
            telemetry = { enable = false },
        },
    },
})

-- LATEX
vim.lsp.config("texlab", {})

-- TYPESCRIPT / JAVASCRIPT
vim.lsp.config("ts_ls", {})

-- HELM KUBERNETES
vim.lsp.config("helm_ls", {})

-- RUST (Handled individually via its dedicated plugin layer)
vim.g.rustaceanvim = function()
    return {
        server = {
            default_settings = {
                ["rust-analyzer"] = {
                    checkOnSave = { command = "clippy" },
                },
            },
        },
    }
end

vim.lsp.enable(servers)

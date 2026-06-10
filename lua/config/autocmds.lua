-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Hightlight when yanking text",
    callback = function()
        vim.hl.on_yank()
    end,
})

vim.api.nvim_create_autocmd("LspAttach", {
    desc = "LSP actions and keymaps",
    callback = function(event)
        local opts = { buffer = event.buf, silent = true }
        local keymap = vim.keymap.set

        keymap("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to Definition" }))
        keymap("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "Show References" }))
        keymap("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Go to Implementation" }))
        keymap("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover Documentation" }))
        keymap("n", "df", vim.diagnostic.open_float, { desc = "Show line diagnostics" })
        keymap("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename Symbol" }))
        keymap(
            { "n", "v" },
            "<leader>ca",
            vim.lsp.buf.code_action,
            vim.tbl_extend("force", opts, { desc = "Code Actions" })
        )
        keymap("n", "<leader>f", vim.lsp.buf.format, { desc = "Format Local buffer" })
        keymap("n", "<leader>d", vim.diagnostic.open_float, vim.tbl_extend("force", opts, { desc = "Line Diagnostic" }))
    end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.c", "*.cpp", "*.h", "*.hpp", "*.go", "*.rs", "*.ts", "*.js", "*.lua", "*.sh" },
    callback = function()
        vim.lsp.buf.format({ async = false })
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = {
        -- bashls
        "sh", "bash",
        -- gopls
        "go", "gomod", "gowork", "gotmpl",
        -- lua_ls
        "lua",
        -- texlab
        "tex", "bib", "plaintext",
        -- ts_ls
        "js", "ts", "jsx", "tsx",
        -- helm_ls
        "helm",
        -- rust_analyzer
        "rs",
        -- clangd
        "c", "cpp", "cc", "h", "hh", "hpp", "objc", "objcpp", "cuda", "proto",
    },
    callback = function(ev)
        -- Enable native syntax highlighting
        vim.treesitter.start(ev.buffer)

        -- Use native Tree-sitter code folding
        vim.wo.foldmethod = "expr"
        vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.wo.foldlevel = 99
    end,
})

vim.pack.add({
    "https://github.com/bluz71/vim-moonfly-colors",
    "https://github.com/nvim-mini/mini.nvim"
})

-- mini files
require("mini.files").setup({
    mappings = {
        go_in = "<CR>",
        go_in_plus = "L",
        go_out = "_",
        go_out_plus = "H",
    },
})

vim.keymap.set("n", "-", "<cmd>lua MiniFiles.open()<CR>", { desc = "Toggle mini file explorer" })
vim.keymap.set("n", "<leader>-", function()
    local current_file = vim.api.nvim_buf_get_name(0)
    -- If buffer has no file name, default to opening current working directory
    if current_file == "" then current_file = nil end

    require("mini.files").open(current_file, false)

    vim.schedule(function()
        require("mini.files").reveal_cwd()
    end)
end, { desc = "Toggle into currently opened file" })

-- mini notify
require("mini.notify").setup({
    -- only show messages
    content = {
        format = function(notif)
            return notif.msg
        end,
    },
})

--- mini cmdline completion
require("mini.cmdline").setup({
    autocorrect = { enable = false }
})

--- mini surround
require("mini.surround").setup()
-- Default Keymaps
-- | `sa` | Add surrounding or Direct with 'saiw' |
-- | `sd` | Delete surrounding |
-- | `sr` | Replace surrounding |
-- | `sf` | Find surrounding (right) |
-- | `sF` | Find surrounding (left) |
-- | `sh` | Highlight surrounding |
-- | `sn` | Update n_lines |
-- | `l` / `n` | as suffix for prev/next |

--- mini picker
require("mini.pick").setup()
require("mini.extra").setup()

vim.keymap.set("n", "<leader>pf", require("mini.pick").builtin.files, { desc = "Mini File Picker" })
vim.keymap.set("n", "<leader>vh", require("mini.pick").builtin.help, { desc = "Mini Help" })

vim.keymap.set("n", "<leader>ps",
    function()
        require("mini.pick").builtin.grep({ pattern = vim.fn.expand("<cword>") })
    end,
    { desc = "Grep word/Search word" })

vim.keymap.set("n", "<leader>xx", require("mini.extra").pickers.diagnostic, { desc = "Mini Picker Diagnostics" })
vim.keymap.set("n", "<leader>pk", require("mini.extra").pickers.keymaps, { desc = 'Search keymaps' })

--- mini completions
require("mini.completion").setup({
    lsp_completion = {
        auto_setup = true,
    }
})

--- mini snippets
require("mini.snippets").setup({
    snippets = {
        require("mini.snippets").gen_loader.from_lang(),
    },
})
require("mini.snippets").start_lsp_server({ match = false })

--- mini diff and fugitive
require("mini.diff").setup({
    source = require("mini.diff").gen_source.git({ index = false }),
})

vim.keymap.set("n", "<leader>gg", "<cmd>tabnew | Git | only<cr>", { desc = "Fugitive Full Page New Tab" })
vim.keymap.set("n", "<leader>gd", "<cmd>Gvdiffsplit<CR>", { desc = "Git diff split", })

-- lua/plugins/harpoon.lua
return {
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local harpoon = require("harpoon")

            harpoon:setup({
                settings = {
                    save_on_toggle = true,
                    sync_on_ui_close = true,
                },
            })

            -- ── Core keymaps ──────────────────────────────────────────────
            local map = vim.keymap.set

            -- Add current file to harpoon list
            map("n", "<leader>a", function()
                harpoon:list():add()
            end, { desc = "Harpoon: Add file" })

            -- Toggle the harpoon quick menu
            map("n", "<C-e>", function()
                harpoon.ui:toggle_quick_menu(harpoon:list())
            end, { desc = "Harpoon: Toggle menu" })

            -- Navigate to files 1–4
            map("n", "<C-h>", function() harpoon:list():select(1) end, { desc = "Harpoon: File 1" })
            map("n", "<C-t>", function() harpoon:list():select(2) end, { desc = "Harpoon: File 2" })
            map("n", "<C-n>", function() harpoon:list():select(3) end, { desc = "Harpoon: File 3" })
            map("n", "<C-s>", function() harpoon:list():select(4) end, { desc = "Harpoon: File 4" })

            -- Cycle prev/next in list
            map("n", "<C-S-P>", function()
                harpoon:list():prev()
            end, { desc = "Harpoon: Prev file" })

            map("n", "<C-S-N>", function()
                harpoon:list():next()
            end, { desc = "Harpoon: Next file" })

            map("n", "<leader>fh", function()
                local conf = require("telescope.config").values
                local file_paths = {}
                for _, item in ipairs(harpoon:list().items) do
                    table.insert(file_paths, item.value)
                end
                require("telescope.pickers").new({}, {
                    prompt_title = "Harpoon",
                    finder = require("telescope.finders").new_table({ results = file_paths }),
                    previewer = conf.file_previewer({}),
                    sorter = conf.generic_sorter({}),
                }):find()
            end, { desc = "Harpoon: Telescope picker" })
        end,
    }
}
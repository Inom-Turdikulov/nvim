require("Personal.set")
require("Personal.remap")

local augroup = vim.api.nvim_create_augroup
local PersonalGroup = augroup('Personal', {})
local PersonalViewGroup = augroup('PersonalView', {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})

function R(name)
    require("plenary.reload").reload_module(name)
end

-- reload nvim config
function _G.ReloadConfig()
    local files_reloaded = 0
    for name, _ in pairs(package.loaded) do
        if name:match('^Personal') then
            package.loaded[name] = nil
            files_reloaded = files_reloaded + 1
        end
    end

    -- reload all from ~/.config/nvim/after/plugin/*.lua
    for _, file in pairs(vim.fn.globpath(vim.fn.stdpath("config") .. "/after/plugin", "*.lua", false, true)) do
        dofile(file)
        files_reloaded = files_reloaded + 1
    end

    dofile(vim.env.MYVIMRC)
    vim.notify("Reloaded " .. files_reloaded .. " files")
end

autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})

-- Remove trailing whitespace on save
autocmd({ "BufWritePre" }, {
    group = PersonalGroup,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

-- Set listchars for specific filetypes
autocmd({ "BufRead" }, {
    group = PersonalViewGroup,
    pattern = "*",
    callback = function()
        vim.wo.listchars = GLOBAL_LISTCHARS
    end,
})


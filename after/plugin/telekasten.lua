local has_telekasten, telekasten = pcall(require, "telekasten")
if not has_telekasten then return end

if not pcall(require, "telescope") then
    print("Telekasten: telescope not found")
    return
end

-- Function to map keys, with [Telekasten] prefix for description
local map = function(lhs, rhs, desc)
    if desc then desc = "[Telekasten] " .. desc end
    vim.keymap.set("n", lhs, rhs, { silent = true, desc = desc })
end

local wiki_home = vim.fn.expand("~/Wiki")
if vim.fn.isdirectory(wiki_home) == 0 then return end

telekasten.setup({
    -- Main paths
    home = wiki_home,
    templates = wiki_home .. '/templates',
    template_new_note = wiki_home .. '/templates/permanent_note.md',
    image_subdir = 'img',
    plug_into_calendar = true,
    sort = "modified",
    auto_set_filetype = false,
    new_note_filename = "title",
    media_previewer = "telescope-media-files",
    enable_create_new = false, -- I use C-n to navigate files
    media_extensions = {
        ".png",
        ".jpg",
        ".bmp",
        ".gif",
        ".webm",
        ".webp",
        ".svg",
        ".pdf",
        ".mp4",
        ".ico"
    },
})

map("<leader>tf", function() telekasten.find_notes() end, "find notes")

map("<leader>t#", telekasten.show_tags, "show tags")

map("<leader>tg", telekasten.search_notes, "search notes")

map("<leader>ti", telekasten.insert_link, "insert link")

map("<leader>tI", telekasten.insert_img_link, "insert image link")

map("<leader>tL", telekasten.paste_img_and_link, "paste image and link")

map("<leader>tl", function()
    telekasten.follow_link()
end, "follow link")

map("<leader>tn", telekasten.new_note, "create new note")

map("<leader>tN", telekasten.new_templated_note, "create new note from template")

map("<leader>ty", telekasten.yank_notelink, "yank notelink")

map("<leader>tc", telekasten.show_calendar, "show calendar")

vim.keymap.set("n", "<leader>tz",
    function() telekasten.toggle_todo({ onlyTodo = true }) end,
    { silent = true, desc = "[Telekasten] toggle TODO (only TODO)" })

vim.keymap.set("v", "<leader>tz", function()
    telekasten.toggle_todo({ onlyTodo = true, v = true })
end, { silent = true, desc = "[Telekasten] toggle TODO (only TODO)" })

map("<leader>tt", telekasten.toggle_todo, "toggle TODO")
vim.keymap.set("v", "<leader>tT",
    function() telekasten.toggle_todo({ v = true }) end,
    { silent = true, desc = "[Telekasten] toggle TODO" })

map("<leader>tb", telekasten.show_backlinks, "show backlinks")

map("<leader>tB", telekasten.find_friends, "find friends")

map("<leader>tp", telekasten.preview_img, "preview image")

map("<leader>tm", telekasten.browse_media, "browse media")

map("<leader>tr", telekasten.rename_note, "rename note")

-- Open file in obsidian, file is current buffer name without .md extension
map("<leader>to", function()
    local bufname = vim.fn.expand("%:t:r")
    local current_line = vim.fn.line(".")
    local obsidian_url =
        "obsidian://advanced-uri?vault=Wiki&viewmode=preview&filepath=" ..
        bufname .. "&line=" .. current_line
    vim.fn.jobstart({ 'xdg-open', obsidian_url })
end, "open in obsidian")

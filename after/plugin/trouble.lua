local ok, trouble = pcall(require, "trouble")
if not ok then
  return
end

trouble.setup {
    icons = true,
}
vim.keymap.set("n", "<leader>xq", "<cmd>TroubleToggle document_diagnostics<cr>",
    { silent = true, noremap = true }
)
vim.keymap.set("n", "<leader>xQ", "<cmd>TroubleToggle workspace_diagnostics<cr>",
    { silent = true, noremap = true }
)

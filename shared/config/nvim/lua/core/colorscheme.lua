local colorscheme = "habamax"

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    for _, group in ipairs({ "Normal", "NormalNC", "NormalFloat", "SignColumn" }) do
      vim.api.nvim_set_hl(0, group, { bg = "none" })
    end
  end,
  desc = "Keep the background transparent across colorscheme changes",
})

local ok, err = pcall(vim.cmd.colorscheme, colorscheme)
if not ok then
  vim.notify("colorscheme " .. colorscheme .. " failed: " .. err, vim.log.levels.WARN)
end

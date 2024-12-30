-- Local variable for conciseness
local keymap = vim.keymap

-- Exit from insert mode 
ketmap.set("i", "jk", "<ESC>", { desc = "Exit from insert mode" })
ketmap.set("i", "hj", "<ESC>", { desc = "Exit from insert mode" })

-- CLear search highlights
keymap.set("n", "<leader>h", ":nohl<CR>", { desc = "Clear Search Highlights" })

-- Move the select block of code up and down
keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move the select block of code down" })
keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move the select block of code up" })

-- Page movement and searched word movement
keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Move Down the Page and Center it" })
keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Move Up the Page and Center it" })
keymap.set("n", "n", "nzzzv", { desc = "Move to Next Word and Center it" })
keymap.set("n", "N", "Nzzzv", { desc = "Move to Previous Word and Center it" })

-- Keymap to delete to blackhole register and past the previously yanked text
keymap.set("x", "<leader>p", [["_dP]], { desc = "Delete the Selected Text and Paste the Previous Text" })
keymap.set({"n", "v"}, "<leader>d", "\"_d", { desc = "Delete the Text into the Blackhole Register" })

-- Copy to clipboard
keymap.set({"n", "v"}, "<leader>y", [["+y]], desc = { "Copy the Selected Block into Clipboard" })
keymap.set("n", "<leader>Y", [["+Y]], desc = { "Copy the Line the Cursor is on into Clipboard" })

-- Convenient Keymap
keymap.set("n", "Q", "<nop>")

-- Find and Replace shortcut
keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], desc = { "Find the Term and Replace" })
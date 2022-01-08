-----------------------------------------------------------
-- Keymaps configuration file: keymaps of neovim
-- and plugins.
-----------------------------------------------------------

local opts = { noremap = true, silent = true }
local term_opts = { silent = true }
local map = vim.api.nvim_set_keymap

-----------------------------------------------------------
-- Neovim shortcuts:
-----------------------------------------------------------

map("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- map Esc to kk
map("i", "jj", "<Esc>", { noremap = true })

-- clear search highlighting
map("n", "<leader>c", ":nohl<CR>", opts)

-- fast format + saving with <leader> and s
map("n", "<leader>s", ":w<CR>", opts)

-- close all windows and exit from neovim
map("n", "<leader>q", ":qa!<CR>", opts)

-- Better window navigation
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Navigate buffers

map("n", "<S-l>", ":bnext<CR>", opts)
map("n", "<S-h>", ":bprevious<CR>", opts)

-- Move text up and down
map("n", "<A-j>", "<Esc>:move .+1<CR>==g", opts)
map("n", "<A-k>", "<Esc>:move .-2<CR>==g", opts)
map("v", "<A-j>", ":move .+1<CR>==", opts)
map("v", "<A-k>", ":move .-2<CR>==", opts)
map("v", "p", '"_dP', opts)
map("x", "J", ":move '>+1<CR>gv-gv", opts)
map("x", "K", ":move '<-2<CR>gv-gv", opts)

-----------------------------------------------------------
-- Applications & Plugins shortcuts:
-----------------------------------------------------------
-- open terminal
map("n", "<C-t>", ":Term<CR>", { noremap = true })
-- Better terminal navigation
-- map("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
-- map("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
-- map("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
-- map("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)

-- keymap("n", "<leader>f", "<cmd>Telescope find_files<cr>", opts)
map(
	"n",
	"<leader>f",
	"<cmd>lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({ previewer = false }))<cr>",
	opts
)
map("n", "<C-t>", "<cmd>Telescope live_grep<cr>", opts)

-- Nvimtree
map("n", "<leader>e", ":NvimTreeToggle<cr>", opts)

-- Null-ls
-- map("n", "<leader>p", ":Format<cr>", opts)

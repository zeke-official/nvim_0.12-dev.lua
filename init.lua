vim.pack.add({
  {src='https://github.com/neovim/nvim-lspconfig'},
  {src='https://github.com/catppuccin/nvim'},
  {src='https://github.com/mason-org/mason.nvim'},
  {src='https://github.com/mason-org/mason-lspconfig.nvim'},
  {src='https://github.com/romgrk/barbar.nvim'},
  {src='https://github.com/nvim-tree/nvim-web-devicons'},
  {src='https://github.com/nvim-neo-tree/neo-tree.nvim'},
  {src='https://github.com/nvim-lua/plenary.nvim'},
  {src='https://github.com/MunifTanjim/nui.nvim'},
  {src='https://github.com/windwp/nvim-autopairs'},
  {src='https://github.com/onsails/lspkind.nvim'},
  {src='https://github.com/L3MON4D3/LuaSnip'},
  {src='https://github.com/rafamadriz/friendly-snippets'},
  {src='https://github.com/hrsh7th/nvim-cmp'},
  {src='https://github.com/hrsh7th/cmp-nvim-lsp'},
  {src='https://github.com/hrsh7th/cmp-path'},
  {src='https://github.com/hrsh7th/cmp-buffer'},
  {src='https://github.com/dgagn/diagflow.nvim'},
  {src='https://github.com/nvim-telescope/telescope.nvim'},
  {src='https://github.com/nvim-telescope/telescope-ui-select.nvim'},
  {src='https://github.com/anurag3301/nvim-platformio.lua'},
  {src='https://github.com/nvim-lualine/lualine.nvim'},
  {src='https://github.com/akinsho/toggleterm.nvim'},
  {src='https://github.com/numToStr/Comment.nvim'},
  {src='https://github.com/seblyng/roslyn.nvim'},
})

vim.g.mapleader = " "
vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = false
vim.o.cursorline = true
vim.o.swapfile = false
vim.o.confirm = true
vim.o.colorcolumn = "80"
vim.o.mouse = "a"
vim.o.encoding = "utf-8"
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.autoindent = true
vim.o.syntax = "on"
vim.o.clipboard = "unnamedplus"
vim.o.background = "dark"

vim.lsp.enable("lua_ls")
vim.lsp.enable("basedpyright")
vim.lsp.enable("clangd")

require("catppuccin").setup({
  flavour = "macchiato",
  integrations = { cmp = true, barbar = true, neotree = true, },
})
vim.cmd.colorscheme "catppuccin"

require("nvim-web-devicons").setup()

require('barbar').setup {
  animation = true, tabpages = true,
  icons = {
    modified = {button = '●'}, visible = {modified = {buffer_number = false}},
    inactive = {button = '×'}, alternate = {filetype = {enabled = false}},
    separator_at_end = true, pinned = {button = '', filename = true},
    separator = {left = '', right = ''},
  },
}

require('neo-tree').setup {
  window = {width = 25}, source_selector = {winbar = false, statusline = false}
}

require('diagflow').setup({
  enable = true, max_width = 35, max_height = 10, show_borders = true,
  border_chars = {
    top_left = "╭", top_right = "╮", bottom_left = "╰",
    bottom_right = "╯", horizontal = "─", vertical = "│"
  },
})
require('Comment').setup {
  toggler = { line = '<leader>cc' },
  opleader = { line = '<leader>cc', block = '<leader>bc' },
}

require('lualine').setup {
  options = {
    icons_enabled = true, theme = 'auto', ignore_focus = { 'neo-tree' },
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    disabled_filetypes = { statusline = {}, winbar = {}, },
    always_divide_middle = true, always_show_tabline = true,
  },
  sections = {
    lualine_a = {'mode'}, lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_x = {'encoding', 'fileformat', 'lsp_progress', 'filetype'},
    lualine_c = {'filename'}, lualine_y = {'progress'}, lualine_z = {'location'}
  },
  inactive_sections = { lualine_c = {'filename'}, lualine_x = {'location'}, },
}

require("nvim-autopairs").setup()


local pok, platformio = pcall(require, 'platformio')
if pok then platformio.setup({lsp = 'clangd', clangd_source = "compiledb"}) end

require("mason").setup({
  registries = {
    "github:mason-org/mason-registry", "github:Crashdummyy/mason-registry",
  },
})

require("mason-lspconfig").setup({
  ensure_installed = {"lua_ls", "basedpyright", "clangd"}
})

require("roslyn").setup()

require("luasnip.loaders.from_vscode").lazy_load()

local cmp = require("cmp")
cmp.setup({
  completion = { autocomplete = false, },
  sources = {
    {name = "nvim_lsp"}, {name = "luasnip"}, {name = 'buffer'}, {name = 'path'}
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-s>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({select = true}),
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
  }),
  window = {
    completion = cmp.config.window.bordered({
      scrollbar = false, winhighlight = 'Normal:NormalFloat',
      border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
    }),
    documentation = cmp.config.window.bordered({
      scrollbar = false, winhighlight = 'Normal:NormalFloat',
      border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
    }),
  },
  formatting = {
    format = require('lspkind').cmp_format({
      mode = 'symbol_text', maxwidth = 50, ellipsis_char = ' ...',
    })
  },
})

require("toggleterm").setup {size=7, open_mapping=[[<c-j>]], direcrion='float'}
require("telescope").load_extension("ui-select")

local opts = { noremap = true, silent = true }
local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
vim.keymap.set("n", "<C-e>", ":Neotree filesystem reveal left<CR>")
vim.keymap.set('n', '<A-,>', '<Cmd>BufferPrevious<CR>', opts)
vim.keymap.set('n', '<A-.>', '<Cmd>BufferNext<CR>', opts)
vim.keymap.set('n', '<A-1>', '<Cmd>BufferGoto 1<CR>', opts)
vim.keymap.set('n', '<A-2>', '<Cmd>BufferGoto 2<CR>', opts)
vim.keymap.set('n', '<A-3>', '<Cmd>BufferGoto 3<CR>', opts)
vim.keymap.set('n', '<A-4>', '<Cmd>BufferGoto 4<CR>', opts)
vim.keymap.set('n', '<A-5>', '<Cmd>BufferGoto 5<CR>', opts)
vim.keymap.set('n', '<A-6>', '<Cmd>BufferGoto 6<CR>', opts)
vim.keymap.set('n', '<A-7>', '<Cmd>BufferGoto 7<CR>', opts)
vim.keymap.set('n', '<A-8>', '<Cmd>BufferGoto 8<CR>', opts)
vim.keymap.set('n', '<A-9>', '<Cmd>BufferGoto 9<CR>', opts)
vim.keymap.set('n', '<A-0>', '<Cmd>BufferLast<CR>', opts)
vim.keymap.set('n', '<A-p>', '<Cmd>BufferPin<CR>', opts)
vim.keymap.set('n', '<A-c>', '<Cmd>BufferClose<CR>', opts)
vim.keymap.set("v", "<leader>c", '"+y')
vim.keymap.set("v", "<A-Down>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<A-Up>", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "<Tab>", ">gv")
vim.keymap.set("v", "<S-Tab>", "<gv")
vim.keymap.set("n", "<Esc><Esc>", ":noh<CR>")

vim.api.nvim_create_augroup('s2_tab', { clear = true })
vim.api.nvim_create_augroup('mk_tab', { clear = true })

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  group = 's2_tab', pattern = { '*.lua' },
  callback = function()
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
    vim.bo.softtabstop = 2
  end
})

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  group = 'mk_tab', pattern = { '[Mm]akefile', '*.mk' },
  callback = function()
    vim.bo.expandtab = false
    vim.bo.tabstop = 8
    vim.bo.shiftwidth = 8
    vim.bo.softtabstop = 0
  end
})

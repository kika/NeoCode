-- mason is an improvement on lsp-installer
-- it keeps the language servers seperate from your system
local mason_ok, mason = pcall(require, "mason")
if not mason_ok then
  return
end

require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "sumneko_lua",
    "rust_analyzer",
    "tsserver",
    "cssls",
    "eslint",
    "html",
    "marksman",
  },
  automatic_installation = true,
})

local null_ls = require("null-ls")

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.prettier,
  },
})

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(_, bufnr)
  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set("n", "<space>D", vim.lsp.buf.declaration, bufopts)
  vim.keymap.set("n", "<space>d", vim.lsp.buf.definition, bufopts)
  vim.keymap.set("n", "<space>h", vim.lsp.buf.hover, bufopts)
  vim.keymap.set("n", "<space>i", vim.lsp.buf.implementation, bufopts)
  vim.keymap.set("n", "<C-i>", vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)
  vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
  vim.keymap.set("n", "<space>gr", vim.lsp.buf.references, bufopts)
  vim.keymap.set("n", "<space>f", function()
    vim.lsp.buf.format({ async = true })
  end, bufopts)
end

local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}

require("lspconfig")["pyright"].setup({
  on_attach = on_attach,
  flags = lsp_flags,
})

local rt = require("rust-tools")

rt.setup({
  server = {
    on_attach = function(_, bufnr)
      -- Hover actions
      vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
      -- Code action groups
      vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
    end,
  },
})

require("typescript").setup({
  disable_commands = false, -- prevent the plugin from creating Vim commands
  debug = false, -- enable debug logging for commands
  go_to_source_definition = {
    fallback = true, -- fall back to standard LSP definition on failure
  },
  server = { -- pass options to lspconfig's setup method
    on_attach = on_attach,
    flags = lsp_flags,
  },
})

require("lspconfig").sumneko_lua.setup({
  on_attach = on_attach,
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      -- library = { } tells the lua server where some external libs that neovim uses are.
      -- It's VERY useful for hacking on Neovim
      -- You'll get completion on vim. !
      workspace = {
        library = {
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          [vim.fn.stdpath("config") .. "/lua"] = true,
          ["/usr/share/awesome/lib/awful"] = true,
          ["/usr/share/awesome/lib/beautiful"] = true,
          ["/usr/share/awesome/lib/gears"] = true,
          ["/usr/share/awesome/lib/naughty"] = true,
          ["/usr/share/awesome/lib/wibox"] = true,
        },
      },
    },
  },
})

require("nvim-lightbulb").setup({ autocmd = { enabled = true } })
require("lsp.cmp")

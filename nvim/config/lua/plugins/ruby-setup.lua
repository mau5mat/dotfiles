-- Ruby LSP Configuration
-- Uses solargraph for Ruby 2.7.8+ projects
-- rbenv shims automatically select the correct Ruby version per project
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        solargraph = {
          mason = false, -- Don't use Mason, use rbenv gems instead
          cmd = { vim.fn.expand("~/.rbenv/shims/solargraph"), "stdio" },
          filetypes = { "ruby" },
          root_dir = require("lspconfig.util").root_pattern("Gemfile", ".git"),
          settings = {
            solargraph = {
              diagnostics = true,
              formatting = true,
            },
          },
        },
      },
      -- Tell LazyVim to setup solargraph
      setup = {
        solargraph = function(_, opts)
          require("lspconfig").solargraph.setup(opts)
        end,
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = { ruby = { "rubocop" } },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = { ruby = { "rubocop" } },
    },
  },
}

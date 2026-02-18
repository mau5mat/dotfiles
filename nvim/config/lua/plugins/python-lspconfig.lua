return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      pyright = {},
      ruff = {
        keys = {
          {
            "<leader>co",
            function()
              vim.lsp.buf.code_action({
                apply = true,
                context = {
                  only = { "source.organizeImports" },
                  diagnostics = {},
                },
              })
            end,
            desc = "Organize Imports",
          },
        },
      },
    },
    setup = {
      ruff = function()
        vim.api.nvim_create_autocmd("LspAttach", {
          callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if client and client.name == "ruff" then
              -- Disable hover in favor of Pyright
              client.server_capabilities.hoverProvider = false
            end
          end,
        })
      end,
    },
  },
}

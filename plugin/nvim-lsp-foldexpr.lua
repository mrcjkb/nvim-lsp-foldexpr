local util = require("lsp-foldexpr.util")

if vim.g.loaded_nvim_lsp_foldexpr then
  return
end
vim.g.loaded_nvim_lsp_foldexpr = true

-- @param table?: LSP client capabilities
local function update_capabilities(capabilities)
  vim.validate({ capabilities = { capabilities, "table", true } })
  capabilities = capabilities or {}

  capabilities.textDocument = vim.tbl_deep_extend("keep", capabilities.textDocument or {}, {
    foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true,
    },
  })
  return capabilities
end

vim.lsp.handlers["textDocument/foldingRange"] = function(_, result, ctx, _)
  if not result then
    return
  end
  util.update_folds(ctx.bufnr, result)
end

-- Override resalve_capabilities to add foldingRrangeProvider
local orig_resolve_capabilities = vim.lsp.protocol.resolve_capabilities
vim.lsp.protocol.resolve_capabilities = function(server_capabilities)
  local general_properties = {}
  general_properties.document_fold = server_capabilities.foldingRangeProvider or false
  return vim.tbl_extend("error", orig_resolve_capabilities(server_capabilities), general_properties)
end

-- Override resalve_capabilities to add foldingRange
local orig_make_capabilities = vim.lsp.protocol.make_client_capabilities
vim.lsp.protocol.make_client_capabilities = function()
  return update_capabilities(orig_make_capabilities())
end

vim.lsp._request_name_to_capability["textDocument/foldingRange"] = "document_fold"

--- Creates |folds| for the current buffer.
---
--- This will also set 'foldmethod' to "expr" and use |vim.lsp.buf.foldexpr()|
--- for 'foldexpr'.
---
--- Note: The folds are not updated automatically after subsequent changes.
--- To update them whenever leaving insert mode, use
---
--- <pre>
--- vim.api.nvim_command[[autocmd InsertLeave <buffer> lua vim.lsp.buf.document_fold()]]
--- </pre>
--@see https://microsoft.github.io/language-server-protocol/specifications/specification-current/#textDocument_foldingRange
function vim.lsp.buf.document_fold()
  local params = { textDocument = vim.lsp.util.make_text_document_params() }
  vim.lsp.buf_request("textDocument/foldingRange", params)
end

--- Returns the fold level for a line in the current buffer as determined
--- by a server.
---
--- Can be used as 'foldexpr', see |fold-expr|.
---
--- Note: To update the folds it is necessary to call |vim.lsp.buf.document_fold()|.
--@param lnum line number |v:lnum|
--@returns fold level
function vim.lsp.buf.foldexpr(lnum)
  local bufnr = vim.api.nvim_get_current_buf()
  return util.get_fold_level(bufnr, lnum)
end

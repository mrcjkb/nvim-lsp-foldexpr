local M = {}

do
  local foldlevels = {}

  --- Applies a list of fold ranges to a certain buffer.
  ---
  --@param bufnr buffer id
  --@param ranges list of `FoldingRange` objects
  function M.update_folds(bufnr, ranges)
    foldlevels[bufnr] = {}
    local endlevels = {}
    for _, range in ipairs(ranges) do
      if range.startLine ~= range.endLine then
        for linenr = range.startLine + 1, range.endLine + 1 do
          foldlevels[bufnr][linenr] = (foldlevels[bufnr][linenr] or 0) + 1
        end
        -- Need to make sure to mark the last line in the range
        -- with the lowest fold level ending on that line
        local _el = endlevels[range.endLine + 1] or math.huge
        local el_ = foldlevels[bufnr][range.endLine + 1]
        endlevels[range.endLine + 1] = math.min(_el, el_)
      end
    end

    for linenr, level in pairs(endlevels) do
      foldlevels[bufnr][linenr] = '<' .. level
    end

    -- Force refresh by setting folding options
    for _, winid in ipairs(vim.fn.win_findbuf(bufnr)) do
      vim.api.nvim_win_set_option(winid, 'foldexpr',
        "luaeval('vim.lsp.buf.foldexpr('..v:lnum..')')")
      vim.api.nvim_win_set_option(winid, 'foldmethod', "expr")
    end
  end

  --- Returns the fold level for a line in a buffer.
  --@param bufnr buffer id
  --@param linenr line number (1-indexed)
  --@returns fold level
  function M.get_fold_level(bufnr, linenr)
    if not foldlevels[bufnr] then return 0 end
    return foldlevels[bufnr][linenr]
  end
end

return M

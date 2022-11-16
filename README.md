# nvim-lsp-foldexpr

This plugin is extracted from [neovim/#14306](https://github.com/neovim/neovim/pull/14306).
It adds experimental LSP support for [`textDocument/foldingRange`](https://learn.microsoft.com/en-us/dotnet/api/microsoft.visualstudio.languageserver.protocol.foldingrange?view=visualstudiosdk-2022).

> :warning: The implementation of neovim/#14306 will likely change by the time it is merged.
> *Use this plugin at your own risk!*

## Installation

e.g. using [`packer.nvim`](https://github.com/wbthomason/packer.nvim):

```lua
use {
  'MrcJkb/nvim-lsp-foldexpr',
  config = function()
    require('lsp-foldexpr').setup()
  end,
}
```

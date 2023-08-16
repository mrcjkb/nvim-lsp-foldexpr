# nvim-lsp-foldexpr

This plugin is extracted from [neovim/#14306](https://github.com/neovim/neovim/pull/14306).
It adds experimental LSP support for [`textDocument/foldingRange`](https://learn.microsoft.com/en-us/dotnet/api/microsoft.visualstudio.languageserver.protocol.foldingrange?view=visualstudiosdk-2022).

> :warning: The implementation of neovim/#14306 will likely change by the time it is merged.
> *Use this plugin at your own risk!*
>
> For a more feature-rich plugin, consider [nvim-ufo](https://github.com/kevinhwang91/nvim-ufo) instead.

## Installation

e.g. using [`lazy.nvim`](https://github.com/folke/lazy.nvim):

```lua
{
  'mrcjkb/nvim-lsp-foldexpr',
  lazy = false,
}
```

This plugin **does not** support lazy loading.

## Usage

To enable LSP-based folding, put the following in your `ftplugin` or `FileType` autocommand:

```lua
vim.wo.foldexpr = 'v:lua.vim.lsp.buf.foldexpr()'
```

https://www.reddit.com/r/neovim/comments/1jw0zav/psa_heres_a_quick_guide_to_using_the_new_built_in/

Neovim 0.11 automatically checks the root directory for a directory called "lsp" and assumes that it will find lsp configs in there. The lsp name that you call in the `vim.lsp.enable()` function has to have the same name of the file that contains the lsp configuration.

As long as you only set up one LSP per file, you don't have to worry about the vim.lsp.enable() command. Neovim will just the name of the file as the name of the lsp.

Additionally, your lsp enable commands don't have to be in init.lua. they can be anywhere in your config. I take advantage of this to keep all of my settings for any particular language together in one file. This include some auto command configs that change indenting and other formatting for a specific language.

helpful commands:
1. :checkhealth vim.lsp to check the status of an lsp attached to the buffer
2.
# vim-templates
VIM plugin to generate new files from templates.

## Overview

If you try to open a file in vim that does not exist, vim will ask you for whether you want to generate it.
The plugin now takes the file extension and tries to find a suitable template and loads it into the new file.
The template might contain special strings like `%%YEAR%%` .Those are replaced with certain data, in the case of %%YEAR%% with the current year.

## Functionality

Templates are just ordinary files living in `vimrc/templates` by default (the directory can be configured).
They are called `template.EXTENSION` .
The appropriate template is found by looking at the file ending, e.g. if the new file is called `my-new-rust-file.rs`, the plugin looks for a template `template.rs` and if found, uses this template to generate the `my-new-rust-file.rs` .

Currently the implementation demands for each file type to set up an autocommand to link the file type to the plugin:

```
autocmd BufNewFile *.rs :call NewFileFromTemplate("/template.rs")
```

## Installation

Just check out this repo into your local `.vim` dir. Alternatively, copy `plugin/templates.vim` into `.vim/plugin`  and the `templates` folder into `.vim` as well.

## Configuation

The directory containing the templates is `.vim/templates` by default.
This directory can be changed at any point in time (at startup, during a vim session ...) by setting the global variable `g:Templatedir` like
`let g:Templatedir = /my/project/path/project_specific_templates` .

The templates can contain any text.
Special strings are replaced by data:

`%%YEAR%%` - Current year
`%%DATE%%` - Current date
`%%FILENAME_BASE%%` - The base filename (see `basename(1)` in your shell)
`%%FILENAME%%` - The actual full filename

The cursor position in the new file can be set using the special string `%%START_POINT%%` .

## Example

For a c header, a suitable template would be 

```
/***
        ------------------------------------------------------------------------

        Copyright (c) %%YEAR%% Me Myself

        Fancy C module.

        ------------------------------------------------------------------------
*//**

        @author Me Myself
        @copyright (c) %%YEAR%% Me Myself

        ------------------------------------------------------------------------
*/
#ifndef %%FILENAME_BASE%%_H
#define %%FILENAME_BASE%%_H
/*----------------------------------------------------------------------------*/
%%START_POINT%%
/*----------------------------------------------------------------------------*/
#endif
```

Place it as `template.h` in your templates directory and link the template to the file type by adding a 

```
autocmd BufNewFile *.h :call NewFileFromTemplate("/template.h")
```

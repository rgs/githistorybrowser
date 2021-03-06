## git history browser for vim

### Installation

Put githistorybrowser.vim in your `~/.vim` directory,
and load it (by hand or in your `.vimrc`) with

    :run githistorybrowser.vim

For nicer output you can also copy the `syntax/*` files in your
`~/.vim/syntax` directory.

### Usage

The new macros installed are (assuming for this example that
your map local leader is `_`) :

In normal mode :

- `_b` will open a blame window
- `_l` will open a log window
- `_r` will mark recent lines in the current file with ++ in the margin
  (with the `:sign` command)

In visual mode :

- `_b` will open a blame window, restricted to the lines currently selected

In the blame window:

- `_g` or a double click will display blame for the file at the time of the
  penultimate (or first) change for the current line
- `_h` will go back to displaying blame up until HEAD
- `_d` will open a new window with the change responsible for the current line
- `_l` will open a log window (with the full log for the file)

In a diff window:

- `_g` or a double-click will go to the blame of the file whose path is under
  the cursor, at the time of the diff. (this will work better if your repo's
  root dir is listed in the `path` option)

In a log window:

- `_d` or a double click will jump to the diff where the cursor currently is

### TODO

Make the visual line selection sticky, but keep 1,$ ranges
always until $, and make a new macro to reset to 1,$.

Navigation in the log window should be easier.

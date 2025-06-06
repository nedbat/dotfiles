if exists('+colorcolumn')
    " Standard widths.  .editorconfig puts them one-past, so the project's
    " desired width will appear as a double-width line.
    setlocal colorcolumn=80,100,120,140
endif

setlocal textwidth=79
setlocal formatoptions+=corq
setlocal formatoptions-=t
if v:version >= 704
    setlocal formatoptions+=j
endif

" Helper for re-ordering changelog data for coverage.py
" Written by Claude, 2026-11-12.
"
" Move all `.. _name: url` references in a range to the end of the range,
" sorted by the last number in their names.

func! gatherrefs#gather() range abort
    let ref_pat = '^\.\. _[^:]\+:\s'
    let lines = getline(a:firstline, a:lastline)
    let refs = uniq(sort(filter(copy(lines), 'v:val =~ ref_pat'), 'gatherrefs#compare'))
    let body = []
    for line in filter(copy(lines), 'v:val !~ ref_pat')
        " Removing references leaves runs of blank lines: collapse them.
        if line =~ '^\s*$' && (empty(body) || body[-1] =~ '^\s*$')
            continue
        endif
        call add(body, line)
    endfor
    if !empty(body) && body[-1] =~ '^\s*$'
        call remove(body, -1)
    endif
    let result = body + (empty(body) ? [] : ['']) + refs
    if lines[-1] =~ '^\s*$'
        call add(result, '')
    endif
    let whole_buffer = a:firstline == 1 && a:lastline == line('$')
    silent execute a:firstline . ',' . a:lastline . 'delete _'
    call append(a:firstline - 1, result)
    if whole_buffer
        " Deleting every line leaves one empty line behind.
        silent $delete _
    endif
endfunc

func! gatherrefs#num(ref)
    let num = matchstr(matchstr(a:ref, '^\.\. _[^:]\+'), '\d\+\ze\D*$')
    return empty(num) ? 0 : str2nr(num)
endfunc

func! gatherrefs#compare(a, b)
    let diff = gatherrefs#num(a:a) - gatherrefs#num(a:b)
    return diff != 0 ? diff : (a:a ==# a:b ? 0 : a:a ># a:b ? 1 : -1)
endfunc

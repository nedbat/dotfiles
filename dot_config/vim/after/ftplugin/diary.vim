" Diary files

augroup DiaryFiles
    autocmd!
    " the zv here doesn't seem to work...
    autocmd BufWinEnter <buffer> normal zMzv
augroup end

" Append to a line at column 80.
command! -nargs=1 ExtendLine execute 'normal! '.(<q-args>-strdisplaywidth(getline('.'))).'A '
nnoremap <silent> <buffer> <Leader><Leader>` :<c-u>exe 'ExtendLine '.(v:count ? v:count : 80)<CR>A

" Jump to the end of the top-most day.
nnoremap <silent> <buffer> [` zvzzzMgg/\v\= \d+\/\d+\/\d+<CR>zo/<CR>:nohl<CR>{{}

" Jump to agendas
nnoremap <silent> <buffer> [a gg/^= agendas<CR>zo:nohl<CR>

" Jump to the next/prev todo marker.
nnoremap <silent> <buffer> ]t /\v- (todo\|prog):<CR>:nohl<CR>zvzz
nnoremap <silent> <buffer> [t ?\v- (todo\|prog):<CR>:nohl<CR>zvzz

" Jump to the next/prev day.
nnoremap <silent> <buffer> ]d /\v^\= \d<CR>:nohl<CR>zvzz
nnoremap <silent> <buffer> [d ?\v^\= \d<CR>:nohl<CR>zvzz

" Insert a new date heading for today.
function! Today()
    let line = strftime("= %m/%d/%Y, %A")
    let line = substitute(substitute(line, ' 0', ' ', 'g'), '/0', '/', 'g')
    call feedkeys("gg]dO" . line . "\n- today:\n\<ESC>kA")
endfunction
command! Today :call Today()

" Move the todo on the current line into today's "- today:" section,
" leaving a "push:" marker behind so the history still shows it happened.
function! MoveTodoToToday()
    let text = getline('.')
    if text !~ '\v- todo:'
        echo "Not a todo line"
        return
    endif
    call setline('.', substitute(text, '- todo:', '- push:', ''))

    let saved = getpos('.')
    call cursor(1, 1)
    let today_line = search('^- today:$', 'cW')
    call setpos('.', saved)
    if today_line == 0
        echoerr "No '- today:' section found"
        return
    endif

    let insert_after = today_line
    let next = today_line + 1
    while next <= line('$') && getline(next) =~ '\v^\s+\- '
        let insert_after = next
        let next += 1
    endwhile

    call append(insert_after, '    - ' . matchstr(text, 'todo:.*'))
endfunction
nnoremap <silent> <buffer> [k :call MoveTodoToToday()<CR>


" awk '/todo:/{if (hdr) print hdr; hdr="";sub(/^ +/, "");printf "%s:%s:%s\n", FILENAME, FNR, $0} /^=/{hdr=sprintf("%s:%s:%s", FILENAME, FNR, $0)}' ~/work/edx/diary-edx.txt

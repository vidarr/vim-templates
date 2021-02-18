" Author Michael J. Beer
" Licensed under the MIT License - see LICENSE for more details.
"
" Simple templates plugin
"
" Its very very basic:
" Its all file extension based:
" If a new file file.EXTENSION is added,
" the template underneath $HOME/.vim/templates/template.EXTENSION is loaded
" and certain variables replaced, e.g. '%%YEAR%%' by the current year.
"
" Currently new templates must be registered herein by adding a new
" autocmd line at the bottom of this file.
"
" The variables to replace are defined in NewFileFromTemplate function in the
" list regexes

" Function that performs the template insertion & replacement
"
function! NewFileFromTemplate(template)

    let l:templatedir="$HOME/.vim/templates"

    if exists("g:Templatedir")

        let l:templatedir = g:Templatedir

    endif

    let l:templatepath= l:templatedir . "/" . a:template

    let regexes = [["YEAR", strftime("%Y")], ["DATE", strftime("%Y-%m-%d")], ["FILENAME_BASE", toupper(expand("%:t:r"))], ["FILENAME", expand("%")]]

    execute "0r " . l:templatepath

    let start_point = 0
    let l = 1
    for line in getline(1, '$')
        let new_line = line
        if (start_point == 0) && (line =~ '%%START_POINT%%')
            let start_point = l
        endif
        for regex in regexes
            let new_line = substitute(new_line, "%%" . regex[0] . "%%", regex[1], "g")
        endfor
        call setline(l, new_line)
        let l = l + 1
    endfor

    if start_point != 0
        call setline(start_point, "")
        call cursor(start_point, 0)
    endif



endfunction

" Template registrations
if has("autocmd")
    augroup templates
        autocmd BufNewFile *.md :call NewFileFromTemplate("/template.md")
        autocmd BufNewFile *.sh :call NewFileFromTemplate("/template.sh")
        autocmd BufNewFile *.rs :call NewFileFromTemplate("/template.rs")
        autocmd BufNewFile *.c :call NewFileFromTemplate("/template.c")
        autocmd BufNewFile *.h :call NewFileFromTemplate("/template.h")
        autocmd BufNewFile *.py :call NewFileFromTemplate("/template.py")
    augroup END
endif

" git history browser
"
" _b will open a blame window
" _l will open a log window
"
" In the blame window:
" _g or a double click will display blame for the file at the time of the
" penultimate (or first) change for the current line
" _h will go back to displaying blame up until HEAD
" _d will open a new window with the change responsible for the current line
" _l will open a log window (with the full log for the file)
"
" In a diff window:
" _g or a double click will go to the blame of the file whose path is under
" the cursor, at the time of the diff. (this will work better if your repo's
" root dir is in the 'path' option)
"
" In a log window:
" _d or a double click will jump to the diff where the cursor currently is

nmap <LocalLeader>b :call GitHBAnnotate()<CR>
nmap <LocalLeader>l :call GitHBShowLog()<CR>

" sets up mappings and settings for a gitblame window
function GitHBSetupAnnotateBuffer()
    nmap <buffer> <LocalLeader>g :call GitHBBackInTime()<CR>
    nmap <buffer> <2-LeftMouse> :call GitHBBackInTime()<CR>
    nmap <buffer> <LocalLeader>h :call GitHBGoToHEAD()<CR>
    nmap <buffer> <LocalLeader>d :call GitHBShowDiff()<CR>
    nmap <buffer> <LocalLeader>l :call GitHBShowLog()<CR>
    set ro nomod nowrap ft=gitblame
endfunc

" called from an edition window
function GitHBAnnotate()
    new
    r!git blame #
    let b:basefilename=expand("#")
    1d
    call GitHBSetupAnnotateBuffer()
endfunc

" called from a gitblame window
function GitHBBackInTime()
    normal ^"sye
    let l = line(".") - 1
    set noro
    %d
    exec "r!git blame" b:basefilename @s."^" "2>/dev/null || git blame" b:basefilename @s
    1d
    exec "normal" l . "j"
    set ro nomod
endfunc

" called from a gitblame window
function GitHBGoToHEAD()
    let l = line(".") - 1
    set noro
    %d
    exec "r!git blame" b:basefilename "HEAD"
    1d
    exec "normal" l . "j"
    set ro nomod
endfunc

" called from a gitblame or a gitlog window
function GitHBShowDiff()
    if &ft == "gitblame"
	normal ^"sye
    else
	normal $
	?^commit?
	normal W"syaw
	noh
    endif
    new
    exec "r!git show -p --stat" @s
    let b:commitsha1=@s
    1d
    set ro nomod ft=diff
    nmap <buffer> <LocalLeader>g :call GitHBGoToFile()<CR>
    nmap <buffer> <2-LeftMouse> :call GitHBGoToFile()<CR>
endfunc

" called from a gitblame or an edition window
function GitHBShowLog()
    if &ft == "gitblame"
	let bfn = b:basefilename
	new
	exec "r!git log --stat" bfn
	let b:basefilename=bfn
    else
	new
	r!git log --stat #
	let b:basefilename=expand("#")
    endif
    1d
    set ro nomod ft=gitlog
    nmap <buffer> <LocalLeader>d :call GitHBShowDiff()<CR>
    nmap <buffer> <2-LeftMouse> :call GitHBShowDiff()<CR>
endfunc

" called from a diff window
function GitHBGoToFile()
    let b:basefilename=expand("<cWORD>")
    if b:basefilename =~ '^[ab]/'
	let b:basefilename = b:basefilename[2:]
    endif
    let b:basefilename = findfile(b:basefilename)
    if b:basefilename != ''
	set noro
	%d
	exec "r!git blame" b:basefilename b:commitsha1
	1d
	call GitHBSetupAnnotateBuffer()
    else
	throw "File not found"
    endif
endfunc

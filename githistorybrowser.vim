" git history browser
" http://github.com/rgs/githistorybrowser

nmap <LocalLeader>b :%call GitHBAnnotate()<CR>
vmap <LocalLeader>b :call GitHBAnnotate()<CR>
nmap <LocalLeader>l :call GitHBShowLog()<CR>

let s:blameopt="-w"

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
function GitHBAnnotate() range
    new
    let b:basefilename=expand("#")
    exec "r!git blame" s:blameopt "-L" a:firstline . "," . a:lastline b:basefilename
    1d
    call GitHBSetupAnnotateBuffer()
endfunc

" called from a gitblame window
function GitHBBackInTime()
    normal ^eb"sye
    let l = line(".") - 1
    set noro
    %d
    exec "r!git blame" s:blameopt b:basefilename @s."^" "2>/dev/null || git blame" s:blameopt b:basefilename @s
    1d
    exec "normal" l . "j"
    set ro nomod
endfunc

" called from a gitblame window
function GitHBGoToHEAD()
    let l = line(".") - 1
    set noro
    %d
    exec "r!git blame" s:blameopt b:basefilename "HEAD"
    1d
    exec "normal" l . "j"
    set ro nomod
endfunc

" called from a gitblame or a gitlog window
function GitHBShowDiff()
    if &ft == "gitblame"
	normal ^eb"sye
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
	exec "r!git blame" s:blameopt b:basefilename b:commitsha1
	1d
	call GitHBSetupAnnotateBuffer()
    else
	throw "File not found"
    endif
endfunc

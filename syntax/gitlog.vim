if exists("b:current_syntax")
    finish
endif

syn match gitlogCommit /^commit .*/

hi link gitlogCommit Statement

let b:current_syntax = "gitlog"

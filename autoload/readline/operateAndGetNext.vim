vim9script noclear

if exists('loaded') | finish | endif
var loaded = true

const HISTORY_MAX_SIZE: number = 10
var cmdline_history: list<string>

def readline#operateAndGetNext#main(): string #{{{1
    if len(cmdline_history) == 0
        return ''
    endif
    var cmdline: string = getcmdline()
    var pos_in_history: number = (index(cmdline_history, cmdline) + 1) % len(cmdline_history)
    var seq: string = cmdline_history[pos_in_history]
    return "\<cr>:" .. seq
enddef

def readline#operateAndGetNext#remember(when: string) #{{{1
    if mode() != 'c'
        return
    endif
    if when == 'on_leave'
        au CmdlineLeave : ++once readline#operateAndGetNext#remember('now')
    else
        var cmdline: string = getcmdline()
        if cmdline == ''
            return
        endif
        cmdline_history = cmdline_history + [cmdline]
        if len(cmdline_history) > HISTORY_MAX_SIZE
            remove(cmdline_history, 0)
        endif
    endif
enddef


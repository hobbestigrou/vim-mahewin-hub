" =============================================================================
" File:          plugin/mahewin_hub.vim
" Description:   VimMahewinHub is a project to provide an interface for hub command.
" Author:        Natal Ngétal
" =============================================================================

if exists("g:loaded_hub") || &cp
  finish
endif
let g:loaded_hub = 1

if !exists("g:hub_executable")
    let g:hub_executable = 'hub'
endif

function! HubClone(repository,directory_clone,...)
    execute 'cd ' . a:directory_clone

    if (a:0)
        let l:clone = system(g:hub_executable . ' clone -p ' . a:repository)
    else
        let l:clone = system(g:hub_executable . ' clone ' . a:repository)
    endif

    if (s:fatal_error(l:clone) != '')
        return ''
    endif

    execute 'cd ' . a:directory_clone . matchstr(a:repository, '\v/(.*)')
    echo l:clone

    return ''
endfunction

function! HubPullRequest(...)
    if (a:0)
        if (exists("a:2"))
            noautocmd execute '!' . g:hub_executable . ' pull-request -b ' . a:1 . ' -h ' . a:2
        else
            noautocmd execute '!' . g:hub_executable . ' pull-request -h ' . a:1
        endif
    else
        noautocmd execute '!' . g:hub_executable . ' pull-request'
    endif

    if !has('gui_running')
        redraw!
    endif

    return ''
endfunction

function! HubPullRequestIssue(issue,...)
    if (a:0)
        if (exists(("a:2"))
            let l:pull_request = system(g:hub_executable . ' pull-request -b ' . a:1 . ' -h ' . a:2 . ' -i ' . a:issue)
        else
            let l:pull_request = system(g:hub_executable . ' pull-request -h ' . a:1 . ' -i ' . a:issue)
        endif
    else
        let l:pull_request = system(g:hub_executable . ' pull-request -i ' . a:issue)
    endif

    if (s:fatal_error(l:pull_request) != '' )
        return ''
    endif
    echo l:pull_request

    return ''
endfunction

function! HubFork()
    let l:fork = system(g:hub_executable . ' fork')
    if (s:fatal_error(l:fork) != '' )
        return ''
    endif
    echo l:fork

    return ''
endfunction

function! HubBrowseIssue(...)
    if (a:0)
        call s:hub_browse('issues',a:1)
    else
        call s:hub_browse('issues')
    endif

    return ''
endfunction

function! HubBrowsePullRequest(...)
    if (a:0)
        call s:hub_browse('pulls',a:1)
    else
        call s:hub_browse('pulls')
    endif

    return ''
endfunction

function! HubBrowseBranch(branch_name,...)
    if (a:0)
        call s:hub_browse('tree/' . a:branch_name,a:1)
    else
        call s:hub_browse('tree/' . a:branch_name)
    endif

    return ''
endfunction

function! HubBrowseWiki(...)
    if (a:0)
        s:hub_browse('wiki',a:1)
    else
        call s:hub_browse('wiki')
    endif

    return ''
endfunction

function! s:hub_browse(type,...)
    if (a:0)
        let l:project = a:1
        let l:browse = system(g:hub_executable . ' browse '  . l:project . ' ' . a:type)
    else
        let l:browse = system(g:hub_executable . ' browse -- ' . a:type)

        if (l:browse != '')
            echoerr l:browse
        endif
    endif

    return ''
endfunction

function! s:fatal_error(error)
    if (matchstr(a:error, '^fatal') == 'fatal')
        echoerr a:error
        return a:error
    endif

    return ''
endfunction

command -nargs=* HubClone call HubClone(<f-args>)
command -nargs=? HubBrowseIssue call HubBrowseIssue(<f-args>)
command -nargs=? HubBrowsePullRequest call HubBrowsePullRequest(<f-args>)
command -nargs=? HubBrowseWiki call HubBrowseWiki(<f-args>)
command -nargs=* HubBrowseBranch call HubBrowseBranch(<f-args>)
command -nargs=* HubPullRequest call HubPullRequest(<f-args>)
command -nargs=* HubPullRequestIssue call HubPullRequestIssue(<f-args>)
command HubFork call HubFork()

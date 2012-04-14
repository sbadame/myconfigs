" Turn on pathogen for all plug-ins installed after
call pathogen#infect()

" Sandro spacing preferences here
set number
set expandtab
set autoindent
set smartindent
set softtabstop=4
set shiftwidth=4
set shiftround

filetype on " enables filetype detection
filetype plugin on " enables filetype specific plug-ins
filetype indent on " OPTIONAL: This enables automatic indentation as you type.
syntax on
set cursorline
set ofu=syntaxcomplete#Complete

" My color theme for vim
colors sorcerer

" Key mappings
noremap <silent> <F2> :NERDTreeToggle<CR>
noremap <silent> <F3> :TagbarToggle<CR>
nnoremap <silent> <Esc><Esc> <Esc>:nohlsearch<CR><Esc>

" Gimme some breathing room at the bottom please...
set scrolloff=10

" Let me go where I can't go!
set virtualedit=all

" Just hurry up with the multicommand time out!
set timeoutlen=500

if has("unix")
    set undofile " Have a persistant undo
    let g:clipbrdDefaultReg = '+' " Since I use linux, I want this
    set directory=/tmp
    if v:version >= 703
        set undodir=/tmp
    end

    "display tabs and trailing spaces
    set list
    set listchars=tab:>\•,extends:»,precedes:«,trail:•
    set showbreak=…
else "Oh crap... we're on windows, aren;t we??
    set guifont=Lucida_Console:h12:cANSI
    set directory=$TMP
    if v:version >= 703
        set undodir=$TMP
    end
end

set nowrap   " Disable line wrapping
" set mouse=a " Enable the mouse even when vi is used in the terminal
set nomousehide
set textwidth=120


" This shows what you are typing as a command
set showcmd

" Automatically cd into the directory that the file is in
" autocmd BufEnter * execute "chdir ".escape(expand("%:p:h"), ' ')

"Fix Vim's regex...
nnoremap / /\v
vnoremap / /\v

" makes vim usable with screen
set restorescreen

"Kill error bells
set noerrorbells
set visualbell
set t_vb=

" Turn off spell check
set nospell

" Thesaurus!! 
set thesaurus+=/usr/share/myspell/dicts/mthesaur.txt

" Some NERDTree love
 let NERDTreeBookmarksFile=expand("$HOME/.vim/NERDTreeBookmarks")
 let NERDTreeShowBookmarks=1
 let NERDTreeQuitOnOpen=1
 let NERDTreeHighlightCursorline=1
 let NERDTreeShowFiles=1
 let NERDTreeShowHidden=1


" Make swapping windows easier...
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Allow for buffers to be hidden so that they need not be closed to go to
" another file
set hidden

" Turn on incremental search
set incsearch
set smartcase

" Long history is long
set history=1000
set undolevels=1000

" No need for a vi backup file
set nobackup

" Colors!!
set t_Co=256

" Compatibility
set nocompatible

set formatprg=par

" Syntastic!!
let g:syntastic_enable_signs=1
let g:syntastic_auto_loclist=1
let g:syntastic_quiet_warnings=0

" allow backspacing over everything in insert mode
set backspace=indent,eol,start
set showmode "show current mode down the bottom

" Auto completion options
set wildmode=list:longest  "Change tab completion to be like Bash's
set wildignore=*.o,*.obj,*~,*.swp,*.pyc "Files to ignore on auto complete

let g:pydiction_location='~/.vim/after/ftplugin/pydiction/complete-dict'
set sm
set ai
let java_highlight_all=1
let java_highlight_functions="style"
let java_allow_cpp_keywords=1
set tags=~/.tags
set complete=.,w,b,u,t,i


let g:tagbar_type_tex = {
    \ 'ctagstype' : 'latex',
    \ 'kinds'     : [
        \ 's:sections',
        \ 'g:graphics',
        \ 'l:labels',
        \ 'r:refs:1',
        \ 'p:pagerefs:1'
    \ ],
    \ 'sort'    : 0
\ }

" STATUS LINE FROM HERE TO THE END OF THE FILE

set statusline=%n:\        "Buffer number
set statusline+=%f       "tail of the filename

"display a warning if the file format isn't Unix
set statusline+=%#warningmsg#
set statusline+=%{&ff!='unix'?'['.&ff.']':''}
set statusline+=%*

"display a warning if file encoding isn't UTf-8
set statusline+=%#warningmsg#
set statusline+=%{(&fenc!='utf-8'&&&fenc!='')?'['.&fenc.']':''}
set statusline+=%*

set statusline+=%h      "help file flag
set statusline+=%y      "filetype
set statusline+=%r      "read only flag
set statusline+=%m      "modified flag

set statusline+=%#error#
set statusline+=%{StatuslineTabWarning()}
set statusline+=%*

"disply a warning if &paste is set
set statusline+=%#error#
set statusline+=%{&paste?'[paste]':''}
set statusline+=%*

set statusline+=%=  "left/right seperator
"Off the to right side of the status
"Syntastic!!
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%{StatuslineCurrentHighlight()}\  "current highlight
set statusline+=\ %B\  "Byte value in hex of character under cursor
set statusline+=%v\ %l/%L   "cursor line/total lines
set statusline+=\ %P    "percent through the file

set laststatus=2

" Ok now for the functions that support my status bar madness

"return the syntax highlight group under the cursor ''
function! StatuslineCurrentHighlight()
    let name = synIDattr(synID(line('.'),col('.'),1),'name')
    if name == ''
        return ''
    else
        return '[' . name . ']'
    endif
endfunction

"recalculate the trailing whitespace warning when idle, and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_trailing_space_warning

"return '[&et]' if &et is set wrong
"return '[mixed-indenting]' if spaces and tabs are used to indent
"return an empty string if everything is fine
function! StatuslineTabWarning()
    if !exists("b:statusline_tab_warning")
        let tabs = search('^\t', 'nw') != 0
        let spaces = search('^ ', 'nw') != 0

        if tabs && spaces
            let b:statusline_tab_warning =  '[mixed-indenting]'
        elseif (spaces && !&et) || (tabs && &et)
            let b:statusline_tab_warning = '[&et]'
        else
            let b:statusline_tab_warning = ''
        endif
    endif
    return b:statusline_tab_warning
endfunction

"return a warning for "long lines" where "long" is either &textwidth or 80 (if
"no &textwidth is set)
"
"return '' if no long lines
"return '[#x,my,$z] if long lines are found, were x is the number of long
"lines, y is the median length of the long lines and z is the length of the
"longest line
function! StatuslineLongLineWarning()
    if !exists("b:statusline_long_line_warning")
        let long_line_lens = s:LongLines()

        if len(long_line_lens) > 0
            let b:statusline_long_line_warning = "[" .
                        \ '#' . len(long_line_lens) . "," .
                        \ 'm' . s:Median(long_line_lens) . "," .
                        \ '$' . max(long_line_lens) . "]"
        else
            let b:statusline_long_line_warning = ""
        endif
    endif
    return b:statusline_long_line_warning
endfunction

"return a list containing the lengths of the long lines in this buffer
function! s:LongLines()
    let threshold = (&tw ? &tw : 80)
    let spaces = repeat(" ", &ts)

    let long_line_lens = []

    let i = 1
    while i <= line("$")
        let len = strlen(substitute(getline(i), '\t', spaces, 'g'))
        if len > threshold
            call add(long_line_lens, len)
        endif
        let i += 1
    endwhile

    return long_line_lens
endfunction

"find the median of the given array of numbers
function! s:Median(nums)
    let nums = sort(a:nums)
    let l = len(nums)

    if l % 2 == 1
        let i = (l-1) / 2
        return nums[i]
    else
        return (nums[l/2] + nums[(l/2)-1]) / 2
    endif
endfunction

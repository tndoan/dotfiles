" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  set background=dark
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

"colorscheme default
"colorscheme morning
"colorscheme desert
"colorscheme monokai
"colorscheme github
"colorscheme molokai
"colorscheme dante
colorscheme kolor
set number

"when enter just move the cursor 2 spaces
set smartindent 
set shiftwidth=4
set tabstop=4
set softtabstop=4 "because of considering tab is 4 space,
"we need this for the backspace to delete 4 space
"not 4 times backspace
set autoindent
set expandtab "consider the tab is now 4 spaces

"not folding the code
set nofoldenable
"syntax enable
"set background=light
"colorscheme solarized
"
"filetype off

call pathogen#infect()
call pathogen#helptags()

set t_Co=256

filetype plugin indent on
syntax on
highlight lineNr term=bold cterm=NONE ctermfg=Blue ctermbg=DarkGrey gui=NONE guifg=DarkGrey guibg=NONE

let Tlist_Ctags_Cmd = "/usr/bin/ctags"
let Tlist_WinWidth = 30
"press F4 to toggle the list of functions
map <F4> :TlistToggle<cr> 
"auto update taglist if there is a new function in python
autocmd BufWritePost *.py :TlistUpdate

"highlight current line and adjust color
set cul 
hi CursorLine term=none cterm=none ctermbg=0

"map the next/previous line is the next/previous line which we observe in
"screen not the real next/previous line of file
nnoremap j gj
nnoremap k gk

"map <F5> to toggle spell checking
map <F5> :setlocal spell! spelllang=en_us<CR>

"map <Ctrl + Space> to replace <Ctrl+x><Ctrl+O> of Omni Complete
inoremap <C-@> <C-x><C-o>

" create a virtual verital line at position of 80
set colorcolumn=80

" keep the cursor always at the middle line of screen
set scrolloff=10

" if the current line begin with \begin{tag}, return \end{tag}
function GetCloseTag()
    let line = getline('.')
    let words = split(line) 
    " if line is empty or contain all space, return empty string
    if len(words) == 0 
        return ""
    end
    let tags = split(words[0], "{")
    if tags[0] == "\\begin"
        let tagname = split(tags[1], "}")
        let endtag = "\\end{" . tagname[0] . "}"
        return endtag
    end
    return ""
endfunction

" 
function AutoCloseTag()
    let insert_tag = GetCloseTag()
    if insert_tag == "" 
        " it is the normal string. Do nothing
        return "\<CR>"
    else
        " 
        return "\<CR>" . insert_tag . "\<Esc>O"
    end
endfunction

" If we open tex file, change the behavior of <CR> to check situation.
" If current line begin with begin environment, so when use hit enter, 
" automatically insert close environment and put cursor between.
" For example, | is the location of cursor, use hit enter
"   \begin{itemize}|
" We change to
"   \begin{itemize}
"       |
"   \end{itemize}
autocmd BufNewFile,BufRead *.tex inoremap <CR> <C-R>=AutoCloseTag()<CR>

" highlight syntax of following language in markdown files
let g:markdown_fenced_languages = ['html', 'vim', 'ruby', 'python', 'bash=sh', 'julia']

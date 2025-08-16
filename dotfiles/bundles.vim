set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=$HOME/.vim/bundle/Vundle.vim/
if has('unix')
    call vundle#begin()
else
    call vundle#begin('$HOME/.vim/bundle/')
endif

" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'xolox/vim-misc'
Plugin 'godlygeek/csapprox'
Plugin 'tpope/vim-fugitive'
Plugin 'vim-scripts/Colour-Sampler-Pack'
Plugin 'xolox/vim-colorscheme-switcher'
Plugin 'vim-scripts/taglist.vim'
Plugin 'vim-scripts/vcscommand.vim'
Plugin 'junegunn/vim-easy-align'
Plugin 'vim-scripts/moria'
Plugin 'keith/swift.vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

$start_dir = $pwd
$script_root = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
$dotfiles = Split-Path -Parent -Path $script_root

# install vimrc and vimfiles
$vimrc="$HOME\.vimrc"
$vimfiles_path="$HOME\.vim"
$bundle_path = "$vimfiles_path\bundle"
$bundles_vim="$vimfiles_path\bundles.vim"

$paths = @($vimfiles_path, $bundle_path);

foreach ($path in $paths) {
    if (!(Test-Path -Path $vimfiles_path)) {
        echo "creating path $path"
        New-Item -Path $vimfiles_path -ItemType directory | out-null
    }
}

# install vundle
$vundle_path = "$bundle_path\Vundle.vim"
if (!(Test-Path -Path $vundle_path)) {
    echo "cloning vundle into $vundle_path"
    git clone https://github.com/VundleVim/Vundle.vim.git $vundle_path
}

echo "updating vundle installed at $vundle_path"
cd $vundle_path
git pull

#Get-ChildItem -Path $dotfiles\dotfiles\vim -Recurse | Copy-Item -force -Verbose -Destination $vimfiles_path
echo "symlinking $vimrc"
cmd.exe /c mklink $vimrc "$dotfiles\dotfiles\vimrc"

echo "symlinking bundles.vim"
cmd.exe /c mklink $bundles_vim "$dotfiles\dotfiles\vim\bundles.vim"

echo "symlinking vimfiles"
cmd.exe /c mklink /D "$HOME\vimfiles" "$HOME\.vim"

# install vim plugins with vundle
vim -u $bundles_vim +BundleInstall +q

echo "moving back to $start_dir"
cd $start_dir

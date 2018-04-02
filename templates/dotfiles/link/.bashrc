# Where the magic happens.
export DOTFILES={{ dotfiles_home }}

# Source all files in "source"
for file in $DOTFILES/source/*; do
  source "$file"
done
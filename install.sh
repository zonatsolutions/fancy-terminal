#!/bin/bash
set -e

##########################################
# TERMINAL LOOKS SCRIPT BY TALHA ALI
# Fancy Look for the Terminal
# www.zonatsolutions.com
##########################################

set -e

USER_HOME="$HOME"
CONFIG_DIR="$HOME/.config"

echo "Updating packages..."
sudo apt update

echo "Installing ZSH and plugins..."
sudo apt install -y zsh zsh-autosuggestions zsh-syntax-highlighting git curl

echo "Cloning zsh-autocomplete..."
git clone --depth 1 https://github.com/marlonrichert/zsh-autocomplete "$HOME/zsh-autocomplete"

echo "Installing Starship prompt..."
curl -sS https://starship.rs/install.sh | sh -s -- -y

mkdir -p "$CONFIG_DIR"

echo "Applying Starship theme..."
starship preset catppuccin-powerline -o "$CONFIG_DIR/starship.toml"

echo "Updating Starship palette..."
if ! grep -q "palette" "$CONFIG_DIR/starship.toml"; then
    echo "palette = 'catppuccin_latte'" >> "$CONFIG_DIR/starship.toml"
else
    sed -i "s/palette *= *.*/palette = 'catppuccin_latte'/" "$CONFIG_DIR/starship.toml"
fi

echo "Updating .zshrc configuration..."

touch "$HOME/.zshrc"

grep -qxF 'eval "$(starship init zsh)"' ~/.zshrc || echo 'eval "$(starship init zsh)"' >> ~/.zshrc
grep -qxF 'source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh' ~/.zshrc || echo 'source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh' >> ~/.zshrc
grep -qxF "source $HOME/zsh-autocomplete/zsh-autocomplete.plugin.zsh" ~/.zshrc || echo "source $HOME/zsh-autocomplete/zsh-autocomplete.plugin.zsh" >> ~/.zshrc
grep -qxF 'source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' ~/.zshrc || echo 'source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' >> ~/.zshrc

echo "Installing Kitty terminal..."
sudo apt install -y kitty

mkdir -p "$CONFIG_DIR/kitty"

echo "Writing Kitty configuration..."

cat <<EOF > "$CONFIG_DIR/kitty/kitty.conf"
font_family  FiraCodeNerdFont-Regular
font_size  12.0
cursor_trail  100
hide_window_decorations  yes
tab_bar_style  powerline
initial_window_width 1920
initial_window_height 1080
remember_window_size no
background_opacity 0.6
tab_bar_min_tabs  1
tab_powerline_style  round
shell  /usr/bin/zsh
shell zsh -ic "fastfetch -c ~/.config/fastfetch/ordered-sections.jsonc; exec zsh"
EOF

echo "Installing Fastfetch..."
sudo apt install -y fastfetch

echo "Downloading fastfetch configuration from GitHub..."

TMP_DIR=$(mktemp -d)

git clone https://github.com/zonatsolutions/fancy-terminal "$TMP_DIR"

mkdir -p "$CONFIG_DIR"

cp -r "$TMP_DIR/fastfetch" "$CONFIG_DIR/"

rm -rf "$TMP_DIR"

echo "Changing default shell to zsh..."
chsh -s $(which zsh)

echo "Setup completed!"
echo "Restart your terminal or run: exec zsh"

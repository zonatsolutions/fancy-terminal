#!/usr/bin/env bash
set -e

##########################################
# TERMINAL LOOKS SCRIPT BY TALHA ALI
# Fancy Look for the Terminal
# www.zonatsolutions.com
##########################################



set -e

echo "🚀 Fancy Terminal Installer"

USER_HOME="$HOME"
CONFIG_DIR="$HOME/.config"

mkdir -p "$CONFIG_DIR"

echo "📦 Updating packages..."
sudo apt update

echo "📦 Installing dependencies..."
sudo apt install -y \
zsh \
git \
curl \
kitty \
fastfetch \
zsh-autosuggestions \
zsh-syntax-highlighting \
fonts-firacode

echo "⬇️ Installing zsh-autocomplete..."
if [ ! -d "$HOME/zsh-autocomplete" ]; then
    git clone --depth 1 https://github.com/marlonrichert/zsh-autocomplete \
    "$HOME/zsh-autocomplete"
fi

echo "⭐ Installing Starship prompt..."
if ! command -v starship &> /dev/null; then
    curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

mkdir -p "$CONFIG_DIR"

echo "🎨 Applying Starship theme..."
starship preset catppuccin-powerline -o "$CONFIG_DIR/starship.toml"

if ! grep -q "palette" "$CONFIG_DIR/starship.toml"; then
    echo "palette = 'catppuccin_latte'" >> "$CONFIG_DIR/starship.toml"
fi

echo "⚙️ Configuring ZSH..."

touch "$HOME/.zshrc"

add_line () {
grep -qxF "$1" "$HOME/.zshrc" || echo "$1" >> "$HOME/.zshrc"
}

add_line 'eval "$(starship init zsh)"'
add_line 'source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh'
add_line "source $HOME/zsh-autocomplete/zsh-autocomplete.plugin.zsh"
add_line 'source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh'

echo "🖥 Configuring Kitty..."

mkdir -p "$CONFIG_DIR/kitty"

cat > "$CONFIG_DIR/kitty/kitty.conf" <<EOF
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

echo "⬇️ Installing fastfetch config..."

TMP_DIR=$(mktemp -d)

git clone https://github.com/zonatsolutions/fancy-terminal "$TMP_DIR"

mkdir -p "$CONFIG_DIR"

cp -r "$TMP_DIR/fastfetch" "$CONFIG_DIR/"

rm -rf "$TMP_DIR"

echo "🐚 Setting ZSH as default shell..."
chsh -s $(which zsh)

echo ""
echo "✅ Installation Complete!"
echo "Restart terminal or run:"
echo ""
echo "exec zsh"

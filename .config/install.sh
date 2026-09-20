#!/usr/bin/env bash
set -e

# ==============================================================================
# Configuration
# ==============================================================================
DOTS_REPO="https://github.com/YOUR_GITHUB_USERNAME/dotfiles.git"
DOTS_DIR="$HOME/.dotfiles"
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

clear
echo "=========================================================="
echo "               Xandev's Rice Deployer                     "
echo "=========================================================="
echo ""

# 1. Ask for AUR helper preference
echo "Select your AUR helper:"
echo "  1) yay"
echo "  2) paru"
read -rp "Enter choice [1 or 2] (default: 1): " HELPER_CHOICE
HELPER_CHOICE=${HELPER_CHOICE:-1}

case "$HELPER_CHOICE" in
    2) AUR_HELPER="paru" ;;
    *) AUR_HELPER="yay" ;;
esac

echo "==> Using $AUR_HELPER as AUR helper..."

# 2. Install base build packages and git
sudo pacman -S --needed --noconfirm base-devel git

# 3. Ensure chosen AUR helper exists
if ! command -v "$AUR_HELPER" &>/dev/null; then
    echo "==> $AUR_HELPER not found. Building and installing ${AUR_HELPER}-bin..."
    git clone "https://aur.archlinux.org/${AUR_HELPER}-bin.git" "/tmp/${AUR_HELPER}-bin"
    (cd "/tmp/${AUR_HELPER}-bin" && makepkg -si --noconfirm)
    rm -rf "/tmp/${AUR_HELPER}-bin"
fi

# 4. Clone the bare repo
if [ ! -d "$DOTS_DIR" ]; then
    echo "==> Fetching dotfiles..."
    git clone --bare "$DOTS_REPO" "$DOTS_DIR"
fi

function dots {
    /usr/bin/git --git-dir="$DOTS_DIR" --work-tree="$HOME" "$@"
}

# 5. Check out dotfiles (backing up any default collision files)
echo "==> Deploying configs..."
mkdir -p "$BACKUP_DIR"

if ! dots checkout 2>/dev/null; then
    echo "==> Backing up colliding files to $BACKUP_DIR..."
    dots checkout 2>&1 | grep -E "^\s+" | awk '{$1=$1};1' | while read -r file; do
        mkdir -p "$BACKUP_DIR/$(dirname "$file")"
        mv "$HOME/$file" "$BACKUP_DIR/$file" 2>/dev/null || true
    done
    dots checkout
fi

dots config --local status.showUntrackedFiles no

# 6. Pull submodules (Neovim)
echo "==> Synchronizing Neovim submodule..."
dots submodule update --init --recursive

# 7. Configure dots alias in both Fish and Bash
echo "==> Setting up shell aliases..."
mkdir -p "$HOME/.config/fish"
if ! grep -q "alias dots=" "$HOME/.config/fish/config.fish" 2>/dev/null; then
    echo 'alias dots="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"' >> "$HOME/.config/fish/config.fish"
fi

if ! grep -q "alias dots=" "$HOME/.bashrc" 2>/dev/null; then
    echo 'alias dots="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"' >> "$HOME/.bashrc"
fi

# ==============================================================================
# Package Inspection & Installation Confirmation
# ==============================================================================

# Resolve manifest locations
NATIVE_LIST="$HOME/.config/pkglist-native.txt"
FOREIGN_LIST="$HOME/.config/pkglist-foreign.txt"

echo ""
echo "=========================================================="
echo "                 PACKAGE INSTALLATION PREVIEW             "
echo "=========================================================="

if [ -n "$NATIVE_LIST" ]; then
    COUNT_NATIVE=$(grep -vE '^\s*#|^\s*$' "$NATIVE_LIST" | wc -l)
    echo ""
    echo "─── [Official Arch / CachyOS Packages] ($COUNT_NATIVE packages) ───"
    # Display in neat terminal columns
    grep -vE '^\s*#|^\s*$' "$NATIVE_LIST" | column -c "$COLUMNS"
fi

if [ -n "$FOREIGN_LIST" ]; then
    COUNT_FOREIGN=$(grep -vE '^\s*#|^\s*$' "$FOREIGN_LIST" | wc -l)
    echo ""
    echo "─── [AUR Packages via $AUR_HELPER] ($COUNT_FOREIGN packages) ───"
    grep -vE '^\s*#|^\s*$' "$FOREIGN_LIST" | column -c "$COLUMNS"
fi

echo ""
echo "=========================================================="
read -rp "Ready to install these packages on your system? [y/N]: " INSTALL_PKGS

case "$INSTALL_PKGS" in
    [yY][eE][sS]|[yY])
        if [ -n "$NATIVE_LIST" ]; then
            echo "==> Installing native packages..."
            grep -vE '^\s*#|^\s*$' "$NATIVE_LIST" | sudo pacman -S --needed --noconfirm -
        fi

        if [ -n "$FOREIGN_LIST" ]; then
            echo "==> Installing AUR packages via $AUR_HELPER..."
            grep -vE '^\s*#|^\s*$' "$FOREIGN_LIST" | $AUR_HELPER -S --needed --noconfirm -
        fi
        ;;
    *)
        echo "==> Skipping package installation. Dotfiles and configs remain intact."
        ;;
esac
echo ""
echo "=========================================================="
echo " Dotfiles deployment complete!                           "
echo " Reboot or run 'niri' to drop into the rice.             "
echo "=========================================================="

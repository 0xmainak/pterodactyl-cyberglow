#!/bin/bash

# Pterodactyl Neon Theme Installer
# Created: June 21, 2025
#
# This script installs the neon theme to your Pterodactyl Panel installation

# Exit if any command fails
set -e

# Configuration
PTERODACTYL_PATH="/var/www/pterodactyl"
THEME_CSS_PATH="$PTERODACTYL_PATH/public/themes/neon.css"
BASE_LAYOUT_PATH="$PTERODACTYL_PATH/resources/views/layouts/base.blade.php"

# Color codes for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Print banner
echo -e "${GREEN}"
echo "╔═════════════════════════════════════════╗"
echo "║          Pterodactyl Neon Theme         ║"
echo "║              Installer Script            ║"
echo "╚═════════════════════════════════════════╝"
echo -e "${NC}"

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}Please run this script as root or with sudo.${NC}"
  exit 1
fi

# Check if Pterodactyl is installed
if [ ! -d "$PTERODACTYL_PATH" ]; then
  echo -e "${RED}Pterodactyl installation not found at $PTERODACTYL_PATH${NC}"
  echo -e "${YELLOW}Please update the PTERODACTYL_PATH variable in this script if your installation is in a different location.${NC}"
  exit 1
fi

echo -e "${GREEN}Pterodactyl installation found at $PTERODACTYL_PATH${NC}"

# Create themes directory if it doesn't exist
if [ ! -d "$PTERODACTYL_PATH/public/themes" ]; then
  echo "Creating themes directory..."
  mkdir -p "$PTERODACTYL_PATH/public/themes"
fi

# Backup original base layout file
if [ -f "$BASE_LAYOUT_PATH" ]; then
  echo "Backing up original base layout file..."
  cp "$BASE_LAYOUT_PATH" "$BASE_LAYOUT_PATH.backup.$(date +%Y%m%d%H%M%S)"
else
  echo -e "${YELLOW}Warning: Base layout file not found. Will create a new one.${NC}"
fi

# Copy theme files
echo "Installing neon.css theme file..."
cp "$(dirname "$0")/neon.css" "$THEME_CSS_PATH"

echo "Installing base.blade.php layout file..."
cp "$(dirname "$0")/base.blade.php" "$BASE_LAYOUT_PATH"

# Fix permissions
echo "Setting correct file permissions..."
chown -R www-data:www-data "$THEME_CSS_PATH" "$BASE_LAYOUT_PATH"
chmod 644 "$THEME_CSS_PATH" "$BASE_LAYOUT_PATH"

# Clear view cache
echo "Clearing Laravel view cache..."
cd "$PTERODACTYL_PATH"
php artisan view:clear

echo -e "${GREEN}"
echo "╔═════════════════════════════════════════╗"
echo "║      Neon Theme Installation Complete    ║"
echo "║                                          ║"
echo "║  You may need to refresh your browser or ║"
echo "║  clear your browser cache to see changes ║"
echo "╚═════════════════════════════════════════╝"
echo -e "${NC}"

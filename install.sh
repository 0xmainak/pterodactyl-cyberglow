#!/bin/bash

# Pterodactyl Neon Theme Installer
# Created: June 21, 2025
#
# This script installs the neon theme to your Pterodactyl Panel installation

set -e

# Configuration
PTERODACTYL_PATH="/var/www/pterodactyl"
THEME_CSS_PATH="$PTERODACTYL_PATH/public/themes/neon.css"
BASE_LAYOUT_PATH="$PTERODACTYL_PATH/resources/views/layouts/base.blade.php"

# Color codes
GREEN='\033[1;32m'
CYAN='\033[1;36m'
MAGENTA='\033[1;35m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
NC='\033[0m'

# Banner
echo -e "${CYAN}"
echo "╔══════════════════════════════════════════════════════════╗"
echo "║                                                          ║"
echo "║        🌟 PTERODACTYL NEON THEME INSTALLER 🌟             ║"
echo "║                                                          ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Root check
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}[ERROR] Please run this script as root or with sudo.${NC}"
  exit 1
fi

# Pterodactyl check
if [ ! -d "$PTERODACTYL_PATH" ]; then
  echo -e "${RED}[ERROR] Pterodactyl not found at $PTERODACTYL_PATH${NC}"
  echo -e "${YELLOW}[INFO] Update PTERODACTYL_PATH in this script if needed.${NC}"
  exit 1
fi
echo -e "${GREEN}[OK] Pterodactyl found at $PTERODACTYL_PATH${NC}"

# Themes dir
if [ ! -d "$PTERODACTYL_PATH/public/themes" ]; then
  echo -e "${MAGENTA}[INFO] Creating themes directory...${NC}"
  mkdir -p "$PTERODACTYL_PATH/public/themes"
fi

# Backup
if [ -f "$BASE_LAYOUT_PATH" ]; then
  BACKUP_FILE="$BASE_LAYOUT_PATH.backup.$(date +%Y%m%d%H%M%S)"
  echo -e "${MAGENTA}[INFO] Backing up base layout to $BACKUP_FILE${NC}"
  cp "$BASE_LAYOUT_PATH" "$BACKUP_FILE"
else
  echo -e "${YELLOW}[WARN] base.blade.php not found. Will create a new one.${NC}"
fi

# Install files
echo -e "${MAGENTA}[INFO] Installing neon.css...${NC}"
cp "$(dirname "$0")/neon.css" "$THEME_CSS_PATH"

echo -e "${MAGENTA}[INFO] Installing base.blade.php...${NC}"
cp "$(dirname "$0")/base.blade.php" "$BASE_LAYOUT_PATH"

# Permissions
echo -e "${MAGENTA}[INFO] Fixing permissions...${NC}"
chown -R www-data:www-data "$THEME_CSS_PATH" "$BASE_LAYOUT_PATH"
chmod 644 "$THEME_CSS_PATH" "$BASE_LAYOUT_PATH"

# Clear caches
echo -e "${MAGENTA}[INFO] Clearing Laravel caches...${NC}"
cd "$PTERODACTYL_PATH"
php artisan view:clear
php artisan cache:clear
php artisan config:clear

# Done
echo -e "${GREEN}"
echo "╔══════════════════════════════════════════════════════════╗"
echo "║                                                          ║"
echo "║   ✅ Neon Theme Installed Successfully!                  ║"
echo "║                                                          ║"
echo "║   ℹ️  Refresh your browser or clear cache to see changes  ║"
echo "║                                                          ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo -e "${NC}"

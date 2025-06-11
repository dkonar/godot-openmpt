#!/bin/bash

# Godot OpenMPT Release Script
# This script helps create a new release by tagging the current commit

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Godot OpenMPT Release Creator${NC}"
echo "================================"

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo -e "${RED}Error: Not in a git repository${NC}"
    exit 1
fi

# Check if there are uncommitted changes
if ! git diff-index --quiet HEAD --; then
    echo -e "${YELLOW}Warning: You have uncommitted changes${NC}"
    echo "Please commit or stash your changes before creating a release."
    exit 1
fi

# Get current version from plugin.cfg
current_version=$(grep -E '^version=' addons/godot-openmpt/plugin.cfg | cut -d'"' -f2)
echo -e "${BLUE}Current version:${NC} ${current_version}"

# Ask for new version
echo -e "\n${YELLOW}Enter new version (e.g., 1.4, 1.5.0):${NC}"
read -p "> " new_version

if [ -z "$new_version" ]; then
    echo -e "${RED}Error: Version cannot be empty${NC}"
    exit 1
fi

# Validate version format (basic check)
if ! [[ $new_version =~ ^[0-9]+\.[0-9]+(\.[0-9]+)?$ ]]; then
    echo -e "${RED}Error: Invalid version format. Use format like 1.4 or 1.4.0${NC}"
    exit 1
fi

# Ask for confirmation
echo -e "\n${YELLOW}This will:${NC}"
echo "1. Update plugin.cfg version to ${new_version}"
echo "2. Update CHANGELOG.md with new version"
echo "3. Commit these changes"
echo "4. Create and push tag v${new_version}"
echo "5. Trigger GitHub Actions to build and create the release"
echo ""
read -p "Continue? (y/N): " confirm

if [[ ! $confirm =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Release cancelled${NC}"
    exit 0
fi

# Update plugin.cfg
echo -e "\n${BLUE}Updating plugin.cfg...${NC}"
sed -i.bak "s/version=\".*\"/version=\"${new_version}\"/" addons/godot-openmpt/plugin.cfg
rm addons/godot-openmpt/plugin.cfg.bak 2>/dev/null || true

# Update CHANGELOG.md with new version and date
echo -e "${BLUE}Updating CHANGELOG.md...${NC}"
current_date=$(date +%Y-%m-%d)
sed -i.bak "s/## \[Unreleased\]/## [${new_version}] - ${current_date}/" CHANGELOG.md 2>/dev/null || true
rm CHANGELOG.md.bak 2>/dev/null || true

# If there's no [Unreleased] section, add the version at the top of the changelog
if ! grep -q "## \[${new_version}\]" CHANGELOG.md; then
    # Create a temporary file with the new version section
    temp_file=$(mktemp)
    echo "## [${new_version}] - ${current_date}" > "$temp_file"
    echo "" >> "$temp_file"
    echo "### Added" >> "$temp_file"
    echo "- Release ${new_version}" >> "$temp_file"
    echo "" >> "$temp_file"

    # Insert after the first occurrence of "# Changelog"
    awk '
    /^# Changelog/ {
        print;
        getline; print;  # Print the next line too
        getline; print;  # And the one after that
        system("cat '"$temp_file"'");
        next;
    }
    { print }
    ' CHANGELOG.md > CHANGELOG.md.tmp && mv CHANGELOG.md.tmp CHANGELOG.md

    rm "$temp_file"
fi

# Stage the changes
echo -e "${BLUE}Staging changes...${NC}"
git add addons/godot-openmpt/plugin.cfg CHANGELOG.md

# Commit the changes
echo -e "${BLUE}Committing changes...${NC}"
git commit -m "Release v${new_version}

- Updated plugin version to ${new_version}
- Updated changelog for release"

# Create and push the tag
echo -e "${BLUE}Creating tag v${new_version}...${NC}"
git tag -a "v${new_version}" -m "Release v${new_version}"

echo -e "${BLUE}Pushing changes and tag...${NC}"
git push origin main
git push origin "v${new_version}"

echo -e "\n${GREEN}✅ Release v${new_version} created successfully!${NC}"
echo -e "${BLUE}GitHub Actions will now build the binaries and create the release.${NC}"
echo -e "${BLUE}Check the Actions tab on GitHub to monitor the build progress.${NC}"
echo -e "${BLUE}The release will be available at: https://github.com/$(git config --get remote.origin.url | sed 's/.*github.com[:/]\([^.]*\).*/\1/')/releases${NC}"

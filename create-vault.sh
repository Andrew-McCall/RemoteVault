#!/bin/bash

# Download .backup.sh file to the current directory
URL="https://raw.githubusercontent.com/Andrew-McCall/RemoteVault/main/.backup.sh"
echo "Downloading .backup.sh..."

# Check if curl is available
if ! command -v curl &> /dev/null; then
  echo "Error: curl is not installed."
  exit 1
fi

curl -s -o "./.backup.sh" "$URL"
if [ $? -ne 0 ]; then
  echo "Error: Failed to download .backup.sh."
  exit 1
fi

# Initialize git repository
echo "Initializing git repository..."
git init
if [ $? -ne 0 ]; then
  echo "Error: Failed to initialize git repository."
  exit 1
fi

# Ask the user for the repo path
echo "Please enter the repository path:"
read REPO_PATH

# Add the remote origin
echo "Adding remote origin..."
git remote add origin "gcrypt::$REPO_PATH"
if [ $? -ne 0 ]; then
  echo "Error: Failed to add remote origin."
  exit 1
fi

# Create the Backup List file
BACKUPLIST="./.backupList"
echo "Creating $BACKUPLIST"
touch "$BACKUPLIST"
if [ $? -ne 0 ]; then
  echo "Error: Failed to create backup list file."
  exit 1
fi

# Check if nano is available
if ! command -v nano &> /dev/null; then
  echo "Error: nano is not installed. Falling back to vi."
  editor="vi"
else
  editor="nano"
fi

# Open Backup List with the chosen text editor
echo "Opening $BACKUPLIST in $editor..."
$editor "$BACKUPLIST"
if [ $? -ne 0 ]; then
  echo "Error: Failed to open $BACKUPLIST in $editor."
  exit 1
fi

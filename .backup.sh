#!/bin/bash

# Change the current directory to the location of the script
cd "$(dirname "$0")"
echo "Backing up $0 @ $(date)"


LOG_FILE=".git/.backup.log"

# Redirect stdout and stderr to both console and log file
exec > >(tee -a "$LOG_FILE") 2>&1

# Define the file path inside the .git folder
FILE_LIST=".backupList"

# Check if the .git directory exists (i.e., it's a valid Git repository)
if [ ! -d ".git" ]; then
    echo "Error: Not a Git repository"
    exit 1
fi

# Check if the file exists
if [ ! -f "$FILE_LIST" ]; then
    echo "Error: $FILE_LIST not found"
    exit 1
fi

# Add files listed in the file
while IFS= read -r file; do
    if [ -n "$file" ]; then
        git add "$file"
    fi
done < "$FILE_LIST"

# Check for changes
if git diff --cached --quiet; then
    echo "No changes to commit. Exiting."
    exit 0
else
    echo "Changes saved:"
    git diff --name-only --cached
fi

# Commit with current date and time
COMMIT_MSG="Auto commit: $(date '+%Y-%m-%d %H:%M:%S')"
git commit -m "$COMMIT_MSG" || { echo "Error: Commit failed"; exit 1; }

# Push to the current branch
echo "Pushing changes..."
git push origin $(git rev-parse --abbrev-ref HEAD) --force || { echo "Error: Push failed"; exit 1; }

echo "Changes committed and pushed successfully."


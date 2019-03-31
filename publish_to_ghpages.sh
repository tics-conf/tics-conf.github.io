#!/bin/sh

DIR=$(dirname "$0")

# cd $DIR/..

if [[ $(git status -s) ]]
then
    echo "The working directory is dirty. Please commit any pending changes."
    exit 1;
fi

echo "Deleting old publication"
rm -rf public
mkdir public
git worktree prune
rm -rf .git/worktrees/public/

echo "Checking out gh-pages branch into public"
git worktree add -B gh-pages public origin/gh-pages

echo "Initializing theme submodules"
git submodule add https://github.com/redraw/hugo-mondrian-theme.git themes/mondrian

echo "Removing existing files"
rm -rf public/*

echo "Creating CNAME for tics.site domain"
echo tics.site > public/CNAME

echo "Generating site"
hugo

echo "Updating gh-pages branch"
cd public && git add --all && git commit -m "Publishing to gh-pages (publish.sh)"

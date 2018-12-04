#!/bin/bash

#deploy gh-pages
figlet DEPLOY GH-PAGES
echo '[deploy_gh-pages]: create new temp dir'
mkdir deployGH-PAGES
cd deployGH-PAGES

echo '[deploy_gh-pages]: clone gh-pages branch'
git clone -b gh-pages https://github.com/${TRAVIS_REPO_SLUG}.git
export TRAVIS_REPO_NAME=${TRAVIS_REPO_SLUG#*/}
cd ${TRAVIS_REPO_NAME}

echo '[deploy_gh-pages]: configuring git'
git config --global push.default simple
git config user.name "Travis CI"
git config user.email "deploy@travis-ci.org"

echo '[deploy_gh-pages]: remove all old files'
rm -rf *

echo '[deploy_gh-pages]: copy new files'
cp ../../output/* .

echo '[deploy_gh-pages]: git add & commit'
git add --all
git commit -m "Deploy code docs to GitHub Pages Travis build: ${TRAVIS_BUILD_NUMBER}" -m "Commit: ${TRAVIS_COMMIT}"

echo '[deploy_gh-pages]: git push'
git push --force "https://${GH_REPO_TOKEN}@github.com/${TRAVIS_REPO_SLUG}.git" > /dev/null 2>&1

echo '[deploy_gh-pages]: remove temp dir'
cd ../..
rm -rf deployGH-PAGES

#deploy to commplete repo
figlet DEPLOY TO COMPLETE
commitHash="$1"
commitMessage=$(git --no-pager log -1 --pretty="%B")
commitAuthorEMail=$(git --no-pager log -1 --pretty="%cE")
commitAuthorName=$(git --no-pager log -1 --pretty="%aN")
echo "Last commit: $commitHash by $commitAuthorName with email $commitAuthorEMail"

# Remove all output, we don't want to commit binaries
rm -rf output/
git clone "https://${GH_REPO_TOKEN}@github.com/SoPra-Team-10/Complete.git"
cd Complete/
git config --global push.default simple
git config user.name "$commitAuthorName"
git config user.email "$commitAuthorEMail"
mkdir -p Uebungsblaetter
cp ../README.md Uebungsblaetter/
cp -r ../Meilenstein* Uebungsblaetter/
git add -A
git commit -m "$commitMessage"
git push -f  "https://${GH_REPO_TOKEN}@github.com/SoPra-Team-10/Complete.git" master
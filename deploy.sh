#!/bin/bash

TMP_DIR=/tmp/punch-blog-deploy

rm -rf _site
punch g
cp NAME _site/
rm -rf $TMP_DIR
mkdir $TMP_DIR
cp -r .git $TMP_DIR/
pushd $TMP_DIR
git branch -D master
git checkout --orphan master
git rm -rf .
popd
cp -r _site/* $TMP_DIR/
pushd $TMP_DIR
git add .
git commit -a -m "Deploy site - See source code in the punch branch."
popd


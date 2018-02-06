#!/bin/bash

# Copyright (c) 2018 Rafał Wolak <r.wolak@design4.pro>

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to
# deal in the Software without restriction, including without limitation the
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
# sell copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
# IN THE SOFTWARE.

set -e # Exit with nonzero exit code if anything fails

# Install dependencies for release build
pip install -r requirements.txt
git config --global user.name "${GIT_NAME}"
git config --global user.email "${GIT_EMAIL}"
git config --global push.default tracking

# Deploy documentation to GitHub pages
if git remote | grep gh-token > /dev/null; then
  git remote rm gh-token
fi;
git remote add gh-token "https://${GH_TOKEN}@github.com/${GIT_REPO_SLUG}"
git fetch gh-token && git fetch gh-token gh-pages:gh-pages

echo "Pushing to github"
mkdocs gh-deploy -v --clean --remote-name gh-token
git push gh-token gh-pages

#!/bin/bash
set -e
git clone https://github.com/sharan-vayakkady/june-09.git
cd june-09
git config user.name $USERNAME
git config user.email $EMAIL
git checkout $MERGE_BRANCH 
git branch
git merge --no-commit --no-ff $ORIGIN_BRANCH  | tee automerge.out
git branch
if grep "Automatic merge failed" automerge.out; then
    echo "Merge conflict detected"
    # Generate a patch of the merge conflict
    patch=$(git diff --name-only --diff-filter=U)
    # Get the full patch contents
    patch_content=$(git diff -U0 $patch)
    echo "Merge conflict detected, Please review files : $patch"
    result=`echo ":warning: Merge conflict detected, Please review files!"`
    echo $result
    echo "COMPARE_RESULT=$result" >> $GITHUB_OUTPUT
    git merge --abort
elif grep "Already up to date" automerge.out; then
    result=`echo ":white_check_mark: Nothing to merge, already up to date!"`
    #echo "COMPARE_RESULT=$result"
else
    echo "No merge conflict, please merge master to staging"
    result=`echo ":negative_squared_cross_mark: Master has new changes, Master can be merged to Staging!"`
    echo "COMPARE_RESULT=$result" >> $GITHUB_OUTPUT
fi

Move the most recent commit(s) to a new branch with Git

How can I go from this

master A - B - C - D - E
to this?

newbranch     C - D - E
             /
master A - B 


Moving to a new branch

Unless there are other circumstances involved, this can be easily done by branching and rolling back.

# Note: Any changes not committed will be lost.
git branch newbranch      # Create a new branch, saving the desired commits
git reset --hard HEAD~3   # Move master back by 3 commits (GONE from master)
git checkout newbranch    # Go to the new branch that still has the desired commits
But do make sure how many commits to go back. Alternatively, you can instead of HEAD~3, simply provide the hash of the commit (or the reference like origin/master) you want to "revert back to" on the master (/current) branch, e.g:

git reset --hard a1b2c3d4
*1 You will only be "losing" commits from the master branch, but don't worry, you'll have those commits in newbranch!

WARNING: With Git version 2.0 and later, if you later git rebase the new branch upon the original (master) branch, you may need an explicit --no-fork-point option during the rebase to avoid losing the carried-over commits. Having branch.autosetuprebase always set makes this more likely. See John Mellor's answer for details.

Moving to an existing branch

WARNING: The method above works because you are creating a new branch with the first command: git branch newbranch. If you want to use an existing branch you need to merge your changes into the existing branch before executing git reset --hard HEAD~3. If you don't merge your changes first, they will be lost. So, if you are working with an existing branch it will look like this:

git checkout existingbranch
git merge master
git checkout master
git reset --hard HEAD~3 # Go back 3 commits. You *will* lose uncommitted work.
git checkout existingbranch







For those wondering why it works (as I was at first):

You want to go back to C, and move D and E to the new branch. Here's what it looks like at first:

A-B-C-D-E (HEAD)
        ↑
      master
After git branch newBranch:

    newBranch
        ↓
A-B-C-D-E (HEAD)
        ↑
      master
After git reset --hard HEAD~2:

    newBranch
        ↓
A-B-C-D-E (HEAD)
    ↑
  master
Since a branch is just a pointer, master pointed to the last commit. When you made newBranch, you simply made a new pointer to the last commit. Then using git reset you moved the master pointer back two commits. But since you didn't move newBranch, it still points to the commit it originally did.

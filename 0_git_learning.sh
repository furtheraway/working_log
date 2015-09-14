# my learning about how to use git and github.

# configeration setup
    git config --global user.name "furtheraway"
    git config --global user.email "yuanyao.or.john@gmail.com"
    git config --list   # view your configurations
    vi ~/.gitconfig  # git configuration file


git init    # will start version control for the corrent folder, generationg hidden folder .git


# create .gitignore file in the project directory to ignore non-source-code files.
    cat .gitignore
    *.[oa]
    *~

git add file_name
    # multipurpose command:
        # 1. to begin tracking new files,
        # 2. to stage files
        # 3. to mark merge conflicted files as resolved
    git add .           # all in current directory
    git add '*.txt'     # a single quote will include files in subdirectory
    git add -A . 
        # where the dot stands for the current directory, so everything in and beneath it is added.
        # The -A ensures even file deletions (directly by rm instead of git rm) are included.


git status  # use as often as you can
    staged:     ready to be committed
        # 1. git reset <filename> to remove a file or files from the staging area.
        # 2. use "git rm --cached <file>..." to untrack a file.
        # 3. use "git checkout -- <file>..." to discard changes in working directory, revert to last commit.

    unstaged:   have not been prepared to be commited.
    untracked:  usually a newly created file_name
    deleted:    file has been deleted and is waiting to be removed form Git.
git status -s  % short version
    

# compare difference: git diff
    git diff    # see changes that have not been staged
    git diff --staged/--cached   # see staged changes compared with last commit.
    git diff HEAD   # changes in the working tree since your last commit
    git diff HEAD^ HEAD     # Compare the version before the last commit and the last commit





# a "commit" is a snapshot of our repository. 
    # staging area is a place where we can group files together before we commit them to git
    git commit -m "a sensible message"
    git commit -v   # git will put the difference in the editor so you can see exactly what changes you're committing.
    git commit -a   # will skip staging step.
    git commit -am "Delete stuff"  # -a is for files deleted just by rm instead of git rm.
    git commit --amend # amend(replace) an unmature commit, change commit message, or add some files. ! DANGER, can not be recovered.


    
    
git log
    git log --summary
    git log --oneline --decorate # see which commits the branch pointers are pointing to.
    git log --oneline --decorate --graph --all
    #--all will display remote branches you have fetched
    # without --all you will only see your local branches.
    
git rm '*.txt'  # remove not just local file, but also stage the removal of the file for us.
git rm -r folder_of_cats
git mv  # rename file


### AN EXAMPLE ABOUT GET GROMACS REMOTE
    # very long ago, with hardy:
        git clone git://git.gromacs.org/gromacs.git Downloads/
        git remote add origin git@github.com:farawayyy/gromacs.git # really, questionable??? suspect to be git remote add github git@github.com:farawayyy/gromacs.git
        git push -u github master
        git remote rename github my_github_gromax (recently renamed)
    # view the remotes
        john@john-ideapad:~/gromacs$ git remote -v
        my_github_gromax    git@github.com:furtheraway/gromacs.git (fetch)
        my_github_gromax    git@github.com:furtheraway/gromacs.git (push)
        origin  git://git.gromacs.org/gromacs.git (fetch)
        origin  git://git.gromacs.org/gromacs.git (push)
    # one year later
        git fetch origin # gromacs has been updated to v5.0, so I fetch the updates
        git chechout master # go to my one year old master branch(local)
        git merge origin/master    # mergy origin/master, which just been updated throught fetch, into my local master branch.
        git push my_github_gromax master    # push my updated local master branch to my remote repository (to which ever branch local_master is tracking, if none tracking, create new branch(same name) on remote) in my account(furtheraway) on github.

    # check out a remote branch, which has been fetched, and make it your own editable branch. (they call it base it off your remote branch)
        git chechout -b qmmm_local(local branch name) orgin/qmmm # branch qmmm_local set up to track remote branch qmmm from origin, and witched to it. And qmmm will track orgin/qmmm 
        === git checkout --track origin/qmmm # local branch will be default named qmmm
        git branch -vv # see the relative locations and tracking targets of branches.




# add a remote repository.
    git remote -v
    git remote show remote_name         # can see remote url and which branch of it is tracked
    git remote rename name1 name2
    git remote add remote_name https://github.com/try-git/try_git.git
    git remote remove remote_name(origin)


# deal with remote, github
    git clone https://github.com/furtheraway/project_name
        # create a directory named "project_name" 
        # initialize a .git directory inside it
        # pulls down all the data and a full copy of version histroy.
        # this remote will be default named origin
        # default name it origin/master locally.
        varient: git clone https://...  Target(local)_directory_name
        git clone -o booyah(name the remote) http://....    .  # create booyah/master as your default remote branch; the last . is important, otherwise create folder booyah
    


#push local changes to Github
    git push -u origin(remote) master(local branch)
    #The -u tells Git to remember the parameters, so that next time we can simply run git push and Git will know what to do. (-u seems to set up the tracking relationship)
    git push origin --delete serverfix # delete your branch from he server.

# setup tracking branches manually 
    git branch --all # to see the fetched remote branches
    git branch -u origin/serverfix # if not work, use --set-upstream instead of -u


git fetch remote_name   ; git status;
git merge remote_name/branch_name  # (merge to your current local branch)

git pull
git pull remote_name remote_branch


# merge branch hotfix into branch master
    git checkout master
    git merge hotfix
    git pull == git fetch orignin + git merge origin/master # fetch get the remote locally available, and then you can merge, pull do the same thing tegether.
git fetch origin



git branch -vv # list all branches
git branch new_branch_name
git branch -d branch_name # delete a branch
git branch -d -f bad_feature  # delete a branch wich has not merged
git branch --merged / --no-merged # see which branch has not been merged into the branch you're currently on.
git branch --all  # see all the remote branches you have fetched.


git checkout  branchname  # change to another brach; if not exist, create one; keep the same remote linkage with the current branch.
git checkout -b new_branch # create and move to a new branck; NOT keep the same remote linkage.
#Files can be changed back to how they were at the last commit by using the command: git checkout -- <target>
git checkout -- octocat.txt(<file_name>) # -- will make sure it is a file following it, not a branch called octocat.txt




# My own examples: records of my git/github using:
    # clone from the current repository form hardy and Yiwen:
        abc@abc-Notebook:~/Dropbox/html$ git clone https://github.com/XchangeCoop/XchangeCoop.github.io
            # the above clone, get me the stable branch to my local master, but not the most recent dev branch.   
        rm XchangeCoop.github.io/ -r

        # so, I use the following to pull down origin
        mkdir test; cd test/
        git init
        git remote add origin https://github.com/XchangeCoop/XchangeCoop.github.io
        git remote -v
        git pull origin dev  # fetch remote origin, and merge its dev branch into your current local branch.
        git fetch origin 
        git branch --all
        git diff origin/dev master
        git diff origin/dev origin/stable

        git log --decorate --graph # ask Yiwen to explain the branches, seen no master branch, but command git branch --all shows origin/master is there.   Is there any way to see where is these branches? How could you track these branches?

    # it seems better to follow:
  -># git init; add remote; fetch remote; git branch --all; or git log --all --decorate;
    # then git merge desired remote/branch. 
        mkdir club_web; cd Dropbox/html/club_web/
        git init
        git remote add originhub https://github.com/furtheraway/clubweb.git
        git remote -v; git fetch originhub; git branch --all;
        git add index.html; git status; git commit -a; git log; 
        git pull originhub master;      # pull down remote originhub master branch to you current local branch.
        git push originhub master -u;   # push local master branch to remote originhub
        ### to see the tracking relationship, use:  git remote show originhub.




#######################################################################################
after developing the the clubpage, I git add and commit.

abc@abc-Notebook:~/Dropbox/html/club_web$ git status
# On branch master
# Your branch is ahead of 'originhub/master' by 1 commit.
#

abc@abc-Notebook:~/Dropbox/html/club_web$ git remote show originhub 
* remote originhub
  Fetch URL: https://github.com/furtheraway/clubweb.git
  Push  URL: https://github.com/furtheraway/clubweb.git
  HEAD branch: master
  Remote branch:
    master tracked
  Local branch configured for 'git pull':
    master merges with remote master
  Local ref configured for 'git push':
    master pushes to master (fast-forwardable)
do

abc@abc-Notebook:~/Dropbox/html/club_web$ git branch --all
* master
  remotes/originhub/master

abc@abc-Notebook:~/Dropbox/html/club_web$ git checkout -b test
Switched to a new branch 'test'

abc@abc-Notebook:~/Dropbox/html/club_web$ git branch --all
  master
* test
  remotes/originhub/master

abc@abc-Notebook:~/Dropbox/html/club_web$ git pull originhub test
fatal: Couldn't find remote ref test
Unexpected end of command stream

abc@abc-Notebook:~/Dropbox/html/club_web$ git push originhub test   # Now, since local test is newly created, it doesn't track any remote branch, so  a new branch of the same name test is created on remote(originhub)
Username for 'https://github.com': furtheraway
Password for 'https://furtheraway@github.com': 
To https://github.com/furtheraway/clubweb.git
 * [new branch]      test -> test

abc@abc-Notebook:~/Dropbox/html/club_web$ git remote show originhub 
* remote originhub
  Fetch URL: https://github.com/furtheraway/clubweb.git
  Push  URL: https://github.com/furtheraway/clubweb.git
  HEAD branch: master
  Remote branches:
    master tracked
    test   tracked
  Local branch configured for 'git pull':
    master merges with remote master
  Local refs configured for 'git push':
    master pushes to master (fast-forwardable)
    test   pushes to test   (up to date)

abc@abc-Notebook:~/Dropbox/html/club_web$ git push originhub test2  # since there is no local branch called test2.
Username for 'https://github.com': furtheraway
Password for 'https://furtheraway@github.com': 
error: src refspec test2 does not match any.
error: failed to push some refs to 'https://github.com/furtheraway/clubweb.git'

abc@abc-Notebook:~/Dropbox/html/club_web$ git push originhub master
Username for 'https://github.com': furtheraway
Password for 'https://furtheraway@github.com': 
To https://github.com/furtheraway/clubweb.git
   25acd7c..8ea9a5e  master -> master

abc@abc-Notebook:~/Dropbox/html/club_web$ git remote show originhub 
* remote originhub
  Fetch URL: https://github.com/furtheraway/clubweb.git
  Push  URL: https://github.com/furtheraway/clubweb.git
  HEAD branch (remote HEAD is ambiguous, may be one of the following):
    master
    test
  Remote branches:
    master tracked
    test   tracked
  Local branch configured for 'git pull':
    master merges with remote master
  Local refs configured for 'git push':
    master pushes to master (up to date)
    test   pushes to test   (up to date)

abc@abc-Notebook:~/Dropbox/html/club_web$ git branch -vv
  master 8ea9a5e [originhub/master] Club Webpage New Version
* test   8ea9a5e Club Webpage New Version

abc@abc-Notebook:~/Dropbox/html/club_web$ git fetch originhub 
abc@abc-Notebook:~/Dropbox/html/club_web$ git branch --all
  master
* test
  remotes/originhub/master
  remotes/originhub/test

do


###### Commonly used. ######
git init

git status
git add .
git commit -m "put down some message"

git remote add github https://github.com/furtheraway/html_backup.git (create this repository in github webpage first)

git push github master 
Username for 'https://github.com': furtheraway
Password for 'https://furtheraway@github.com':xiaohc8*

git remote -v
git remote show [remote_name]

git fetch [remote_name]
git pull
or git merge remote_name/branch_name

git branch -vv 	# show tracking
git branch --all -vv  # show both local and remote

git log --decorate --graph --all

git push -u origin(remote) master(local branch)



###################################################################################
login on linode, install git and do the following:
###################################################################################

   83  git
   84  sudo apt-get install git

   86  git config --global user.name "linode"
   87  git config --global user.email "yuanyao.or.john@gmail.com"
   88  git config --list

   94  git init
   95  sudo git clone https://github.com/furtheraway/clubweb.git .
  100  git status

# change hardy''s profile picture.

  227  git status
  230  sudo git add .
  233  sudo git commit -m "change hardy's profile pic"
  236  sudo git push origin
  237  git status






    
git rebase master # see the book proget-en346, page 113. to clean up your local repository.

git stash: Sometimes when you go to pull you may have changes you don't want to commit just yet. One option you have, other than commiting, is to stash the changes.
Use the command 'git stash' to stash your changes, and 'git stash apply' to re-apply your changes after your pull.

# What's shipgit

Shipgit is my personal git workflow that I have been using for my solo web based project. This
workflow is highly inspired by:

1. [git-flow](https://github.com/nvie/gitflow)
2. [git-HubFlow](https://github.com/datasift/gitflow)
3. [OneFlow](https://www.endoflineblog.com/oneflow-a-git-branching-model-and-workflow)
4. [gitworkflow](https://github.com/rocketraman/gitworkflow)

shipgit supports the basic branching models like:
- production branch
- main branch
- feature branch
- release branch
- hotfix branch

It also comes with some of my personal tweaks:
- Adding a commit.template to guide users to write better commit message.
    <img width="700" alt="image" src="https://user-images.githubusercontent.com/40255418/169645845-9fe6851f-d938-4309-8fed-7702cfd42efc.png">
- Adding [--log](https://git-scm.com/docs/git-merge#Documentation/git-merge.txt---logltngt) options
    to the `merge` command, which in my opinion added useful information to the merge commit
    message.
- Handling the pulling/pushing from/to your remote hosting providers so that your work is always
    up to date.
- Opinionated standard on using [git merge](https://git-scm.com/docs/git-merge) and
    [git rebase](https://git-scm.com/docs/git-rebase) within git-roll.

You can read more on **why** I decided to build this project here.

## Disclaimer
This project is still in its very early stage at v0.1.0. Breaking changes might be introduced until
we have a v1.0 release.

**Make sure you understand what the scripts are doing before proceeding to the installations.**

## Installation
**Installation on windows machine is not supported now. PRs are welcome to add support for windows
machine if anyone find git-roll useful and want to use it on a windows machine.**

**Prerequisite: You have a /usr/local/bin directory which is also added to your PATH.**

*Note: I have only tested shipgit on an Intel Macbook running macOS Monterey Version 12.3.1. However
if your environment satisfies the prequisite, installation should work fine. Feel free to file issues 
if you have problems installing git-roll.*

```bash
git clone git@github.com:marcushwz/shipgit.git
cd shipgit
chmod +x install.sh uninstall.sh
./install.sh
```

The `install.sh` is basically copying all the script files to your machine's `/usr/local/bin` which
should be already in your PATH so that you can use all the git-roll commands in your terminal.

To uninstall, run `./uninstall.sh`

## Usage
### shipgit init
**Prerequisite: Your project directory must be git initialized with remote origin setup**

1. `cd` into your project's directory and run:
```bash
shipgit init
```
2. You will be asked a few questions:
    - Branch name for production: production
    - Branch name for main: main
    - Prefix for Feature branches: feature/
    - Prefix for Hotfix branches: hotfix/
    - Prefix for Release branches: release/
3. Under the hood, git-roll will create the `production` branch for you if you don't already have
   it locally.
4. Finally, a local local config "commit.template" will also be added to use a default template
   provided by git-roll.
    - You can view all the configs added by git-roll by opening the `.git/config` file with your
        editor of choice.
    - You can also edit the commit template in `.git/.gitmessage` if you do not like the default
        one.
5. That's it. shipgit is now setup and you can start using all its commands.

### shipgit feature
Available commands:
- shipgit feature start "feature_name"
- shipgit feature finish

#### Starting a feature
Let's say you have started a new project and wanted to build the login-flow feature. You can do so
by running:

```bash
shipgit feature start login-flow
```

What this command is doing under the hood:
1. Check out to your local main branch.
2. Pull latest changes from your remote main branch.
    - git-roll is calling `git pull` under the hood, but it's recommended to set the pulling
        default to use the rebase by running: `git config --global pull.rebase true`.
3. Create a new feature branch with the prefix you have given base on the main branch:
    - A new branch `feature/login-flow` will be created.
4. Check out to the `feature/login-flow` branch.
5. Push the newly created `feature/login-flow` branch to remote.
6. You can now start building your login flow!

#### Finishing a feature
Few hours later, you have done with your login flow. You can now run:

```bash
shipgit feature finish
```

What this command is doing under the hood:
1. Check out to your local main branch.
2. Pull latest changes from your remote main branch.
3. Merge `feature/login-flow` branch into main branch.
    - If there is no merge conflict:
        - Push latest changes to remote main branch.
        - Delete both local and remote `feature/login-flow` branches.
    - If there is merge confilct:
        - Abort the merge.
        - Checkout to `feature/login-flow`
        - Perform a rebase with updated local main branch.
        - Telling you to fix those conflicts and run `shipgit feature finish` again when you are done.

### shipgit release
Available commands:
- git roll release start "version" "commit-hash"(optional)
- git roll release finish "version"

#### Starting a release
Now the login flow feature is done and merged into main branch. It's time to showcase it to
your friends. You can do so by creating a release:

```bash
shipgit release start v0.1.0
```

What this command is doing under the hood:
1. Check out to your local main branch.
2. Pull latest changes from your remote development branch.
3. Create a new release branch base on the given commit-sha or latest commit on main branch:
    - A new branch `release/v0.1.0` will be created.
4. Check out to the `release/v0.1.0` branch.
5. Push the newly created `release/v0.1.0` branch to remote.
6. You can now start finalising your v0.1 release.

#### Finishing a release
Everything is finalized and you are ready to finish the release:

```bash
shipgit release finish
```

What this command is doing under the hood:
1. Create the new `v0.1.0` tag.
2. Check out to your local main branch.
3. Pull latest changes from your remote main branch.
4. Merge `release/v0.1.0` branch into main branch.
    - If there is no merge conflict:
        - Push the new tag `v0.1.0` to remote
        - Push latest changes to remote main branch.
        - Checkout to production branch
        - Merge tag `v0.1.0` with `git merge --ff-only v0.1.0`
        - Push latest changes to remote production branch.
        - Delete both local and remote release branches.
        - Checkout to main branch
    - If there is merge confilct:
        - Abort the merge.
        - Delete the `v0.1.0` tag.
        - Checkout to `release/v0.1.0`.
        - Perform a rebase with updated local main branch.
        - Telling you to fix those conflicts and run `shipgit release finish "version"` again when you are done.

### shipgit hotfix
Available commands:
- git roll hotfix start "version"
- git roll hotfix finish "version"
- git roll hotfix end "version"

#### Starting a hotfix
Your friend reported that there is a bug with the login flow. You can start a hotfix branch by:

```bash
shipgit hotfix start v0.1.1
```

What this command is doing under the hood:
1. Check out to your local production master.
2. Pull latest changes from your remote production branch.
3. Create a new hotfix branch with the prefix you have given base on the production branch:
    - A new branch `hotfix/v0.1.1` will be created.
4. Check out to the `hotfix/v0.1.1` branch.
5. Push the newly created `hotfix/v0.1.1` branch to remote.
6. You can now start fixing the bug.

#### Finishing a release
Phew.., you found the bug and fixed it under one hour. You can now finish the hotfix by:

```bash
shipgit hotfix finish v0.1.1
```

What this command is doing under the hood:
1. Create a new tag `v0.1.1`.
2. Check out to your local main branch.
3. Pull latest changes from your remote main branch.
4. Merge `hotfix/v0.1.1` branch into master branch.
    - If there is no merge conflict:
        - Push the `v0.1.1` tag to remote.
        - Push latest changes to remote main branch.
        - Checkout to local production branch.
        - Merge tag `v0.1.1` with `git merge --ff-only v0.1.1`.
        - Push latest changes to remote production branch.
        - Delete both local and remote hotfix branches.
        - Checkout to main branch.
    - If there is merge confilct:
        - Abort the merge.
        - Telling you to fix the conflict and run `git commit`.
        - After that, run `shipgit hotfix end v0.1.1`

#### Ending a hotfix
This should only be called after you have fixed the merge conflicts when trying to merge the
hotfix branch into the main branch.

```bash
shipgit hotfix end v0.1.1
```

What this command is doing under the hood:
1. Push the tag `v0.1.1` to remote.
2. Push the latest changes to remote main branch.
3. Checkout to local production branch.
4. Pull latest changes from remote production branch.
5. Merge the tag `v0.1.1` with `git merge --ff-only v0.1.1`
6. Push the latest changes to remote production.
7. Delete both local and remote hotfix branches.
8. Checkout to main branch.

### shipgit update
Run this command to keep your local main and production branches up-to-date with remote.

```bash
shipgit update
```

What this command is doing under the hood:
1. Check out to your local main branch.
2. Pull latest changes from your remote main branch.
3. Check out to your local production branch.
4. Pull latest changes from your remote production branch.

## Pro Tips
You can add aliases to your shell. For example, I am using `zsh` shell and I have the following
aliases set up in my `.zshrc`:

```bash
# git-roll aliases
alias sg="shipgit"
alias sgu="shipgit update"
alias sgf="shipgit feature"
alias sgr="shipgit release"
alias sgh="shipgit hotfix"
```

Now I can do something like:
```bash
# init
sg init

# update
sgu

# feature
sgf start feature1
sgf finish

# release
sgr start v0.1.0
sgr finish v0.1.1

# hotfix
sgh start v0.1.1
sgh finish v0.1.1
sgh end v0.1.1
```

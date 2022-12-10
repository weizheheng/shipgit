# What's shipgit

Shipgit is my personal git workflow that I have been using for my solo web based project and
recently introduced it to a team of 6 people at work.

This workflow is highly inspired by:
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
    <img width="743" alt="CleanShot 2022-12-10 at 12 51 52@2x" src="https://user-images.githubusercontent.com/40255418/206829817-f740f381-8bf6-4d6d-846b-a3749c3dae64.png">

- Adding [--log](https://git-scm.com/docs/git-merge#Documentation/git-merge.txt---logltngt) options
    to the `merge` command, which in my opinion added useful information to the merge commit
    message.
- Handling the pulling/pushing from/to your remote hosting providers so that your work is always
    up to date.
- Opinionated standard on using [git merge](https://git-scm.com/docs/git-merge) and
    [git rebase](https://git-scm.com/docs/git-rebase) within shipgit.

## Disclaimer
This project is still in its very early stage at v0.3.0. Breaking changes might be introduced until
we have a v1.0 release.

Currently, the hotfix and release workflow only works with semantic version with or without prefix.

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

NOTE: You might have to use sudo if permission denied.

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
3. Under the hood, shipgit will create the `production` branch for you if you don't already have
   it locally.
4. Finally, a local local config "commit.template" will also be added to use a default template
   provided by shipgit.
    - You can view all the configs added by shipgit by opening the `.git/config` file with your
        editor of choice.
    - You can also edit the commit template in `.git/.gitmessage` if you do not like the default
        one.
5. That's it. shipgit is now setup and you can start using all its commands.

### shipgit feature
Available commands:
- shipgit feature start "feature_name"
- shipgit feature finish
- shipgit feature sync

#### Starting a feature branch
```bash
shipgit feature start login-flow
```

What this command is doing under the hood:
1. Pull latest changes from your remote main branch.
2. Create a new feature branch based on local up-to-date main branch.
3. Push the newly created feature branch to remote and add upstream reference.

#### Synching feature branch
```bash
shipgit feature sync
```

What this command is doing under the hood:
1. Pull latest changes from your remote main branch.
2. Rebase feature branch with local up-to-date main branch.
    - You will need to handle merge conflicts if any.

#### Finishing a feature branch
```bash
shipgit feature finish
```

What this command is doing under the hood:
1. Pull latest changes from your remote branch.
2. Rebase feature branch with your local up-to-date main branch.
    - You will need to handle merge conflicts if any.
    - Once fixing all the conflicts, you can run `shipgit feature finish` again
3. Merge feature branch into main branch.
4. Push main branch to remote.
5. Delete feature branch locally and remotely.

### shipgit release
**NOTE: Currently only works with semantic versioning**

Available commands:
- shipgit release start "release-name"
- shipgit release finish (patch|minor|major)
- shipgit release sync

#### Starting a release branch
```bash
shipgit release start release-1
```

What this command is doing under the hood:
1. Pull latest changes from your remote main branch.
2. Create a new release branch based on latest commit on the local main branch.
3. Push the new release branch to remote.

#### Syncing a release branch
```bash
shipgit release sync
```

What this command is doing under the hood:
1. Pull latest changes from your remote main branch.
2. Rebase release branch with your local up-to-date main branch.
    - You will need to handle merge conflicts if any.

#### Finishing a release branch
```bash
shipgit release finish (patch|minor|major)
```

What this command is doing under the hood:
1. Pull latest changes from your remote main branch.
2. Rebase release branch with local up-to-date main branch.
    - You will need to handle merge conflicts if any.
    - After fixing all the conflicts you can run `shipgit release finish (patch|minor|major)`
        again.
3. Add a new annonated tag to latest commit of your release branch. Note that the semantic version
   will be bumped automatically depending on the release type (patch|minor|major).
4. Merge release branch into main branch.
5. Push the new annotated tag and main branch to remote.
6. Merge the annotated tag into local up-to-date production branch.
7. Push production branch to remote.
8. Deleted release branch locally and remotely.

### shipgit hotfix
Available commands:
- git roll hotfix start "hotfix-name"
- git roll hotfix finish (patch|minor|major)
- git roll hotfix end

#### Starting a hotfix branch
```bash
shipgit hotfix start fix-bug1
```

What this command is doing under the hood:
1. Pull latest changes from your remote production branch.
2. Create a new hotfix branch based on up-to-date production branch.
3. Push the newly created hotfix branch to remote and add upstream reference.

#### Syncing a hotfix branch
```bash
shipgit hotfix sync
```

What this command is doing under the hood:
1. Pull latest changes from your remote production branch.
2. Rebase feature branch with your local up-to-date production branch.
    - You will need to handle merge conflicts if any.

#### Finishing a hotfix branch
```bash
shipgit hotfix finish (patch|minor|major)
```

What this command is doing under the hood:
1. Pull latest changes from your remote production branch
2. Rebase hotfix branch with local up-to-date production branch
    - You will need to handle merge conflicts if any.
    - After fixing all the conflicts you can run `shipgit release finish (patch|minor|major)`
        again.
3. Add a new annonated tag to latest commit of your release branch. Note that the semantic version
   will be bumped automatically depending on the hotfix finish type (patch|minor|major).
4. Merge hotfix branch into main branch.
    - You might come across merge conflicts here.
    - Fix all the conflicts and run `git commit`
    - After that, you can checkout to your hotfix branch again and run `shipgit hotfix end`
5. Push the new annotated tag and main branch to remote.
6. Merge the annotated tag into local up-to-date production branch.
7. Push production branch to remote.
8. Delete hotfix branch locally and remotely.

#### Ending a hotfix
This should only be called after you have fixed the merge conflicts when trying to merge the
hotfix branch into the main branch.

```bash
shipgit hotfix end
```

What this command is doing under the hood:
1. Push the annotated tag created while running `shipgit hotfix finish (patch|minor|major)` and
   main branch (you just fixed the conflicts while trying to merge hotfix branch into main branch)
   to remote.
2. Merge the annotated tag into production branch.
3. Push production branch to remote.
4. Delete hotfix branch locally and remotely.

### shipgit update
```bash
shipgit update
```

What this command is doing under the hood:
1. Pull latest changes from your remote main and production branch.

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
sgf sync
sgf finish

# release
sgr start release-1
sgr sync
sgr finish patch

# hotfix
sgh start fix-bug1
sgh sync
sgh finish patch
sgh end
```

# What's git-roll

A git workflow that's suitable for software developments that can benefit from a structured
[branching models](https://nvie.com/posts/a-successful-git-branching-model/) by [Vincent Driessen](https://nvie.com/about/).

git-roll supports the basic branching models like:
- main/master branch
- develop branch
- feature branch
- release branch
- hotfix branch

It also comes with some of my personal tweaks:
- Adding a commit.template to guide users to write better commit message.
    <img width="647" alt="image" src="https://user-images.githubusercontent.com/40255418/168460323-88240c45-76a3-40d7-a8d8-705850c47f10.png">
- Adding [--log](https://git-scm.com/docs/git-merge#Documentation/git-merge.txt---logltngt) options
    to the `merge` command, which in my opinion added useful information to the merge commit
    message.
- Handling the pulling/pushing from/to your remote hosting providers so that your work is always
    up to date.
- Opinionated standard on using [git merge](https://git-scm.com/docs/git-merge) and
    [git rebase](https://git-scm.com/docs/git-rebase) within git-roll.

You can read more on **why** I decided to build this project here.

## Disclaimer
This project is still in its very early stage at v0.1.1. Breaking changes might be introduced until
we have a v1.0 release.

**Make sure you understand what the scripts are doing before proceeding to the installations.**

## Installation
**Installation on windows machine is not supported now. PRs are welcome to add support for windows
machine if anyone find git-roll useful and want to use it on a windows machine.**

**Prerequisite: You have a /usr/local/bin directory which is also added to your PATH.**

*Note: I have only tested git-roll on an Intel Macbook running macOS Monterey Version 12.3.1. However
if your environment satisfies the prequisite, installation should work fine. Feel free to file issues 
if you have problems installing git-roll.*

```bash
git clone git@github.com:marcushwz/git-roll.git
cd git-roll
chmod +x install.sh uninstall.sh
./install.sh
```

The `install.sh` is basically copying all the script files to your machine's `/usr/local/bin` which
should be already in your PATH so that you can use all the git-roll commands in your terminal.

To uninstall, run `./uninstall.sh`

## Usage
### git roll init
**Prerequisite: Your project directory must be git initialized with remote origin setup**

1. `cd` into your project's directory and run:
```bash
git roll init
```
2. You will be asked a few questions:
    - Branch name for production: main
    - Branch name for development: development
    - Prefix for Feature branches: feature/
    - Prefix for Hotfix branches: hotfix/
    - Prefix for Release branches: release/
3. Under the hood, git-roll will create the `development` branch for you if you don't already have
   it locally.
4. Finally, a local local config "commit.template" will also be added to use a default template
   provided by git-roll.
    - You can view all the configs added by git-roll by opening the `.git/config` file with your
        editor of choice.
    - You can also edit the commit template in `.git/.gitmessage` if you do not like the default
        one.
5. That's it. git-roll is now setup and you can start using all its commands.

### git roll feature
Available commands:
- git roll feature start "feature_name"
- git roll feature finish

#### Starting a feature
Let's say you have started a new project and wanted to build the login-flow feature. You can do so
by running:

```bash
git roll feature start login-flow
```

What this command is doing under the hood:
1. Check out to your local development branch.
2. Pull latest changes from your remote development branch.
    - git-roll is calling `git pull` under the hood, but it's recommended to set the pulling
        default to use the rebase by running: `git config --global pull.rebase true`.
3. Create a new feature branch with the prefix you have given base on the development branch:
    - A new branch `feature/login-flow` will be created.
4. Check out to the `feature/login-flow` branch.
5. Push the newly created `feature/login-flow` branch to remote.
6. You can now start building your login flow!

#### Finishing a feature
Few hours later, you have done with your login flow. You can now run:

```bash
git roll feature finish
```

What this command is doing under the hood:
1. Check out to your local development branch.
2. Pull latest changes from your remote development branch.
3. Merge `feature/login-flow` branch into development branch.
    - If there is no merge conflict:
        - Push latest changes to remote development branch.
        - Delete both local and remote `feature/login-flow` branches.
    - If there is merge confilct:
        - Abort the merge.
        - Checkout to `feature/login-flow`
        - Perform a rebase with updated local development branch.
        - Telling you to fix those conflicts and run `git roll feature finish` again when you are done.

### git roll release
Available commands:
- git roll release start "version"
- git roll release finish
- git roll release cleanup "version"

#### Starting a release
Now the login flow feature is done and merged into development branch. It's time to showcase it to
your friends. You can do so by creating a release:

```bash
git roll release start v0.1
```

What this command is doing under the hood:
1. Check out to your local development branch.
2. Pull latest changes from your remote development branch.
3. Create a new release branch with the prefix you have given base on the development branch:
    - A new branch `release/v0.1` will be created.
4. Check out to the `release/v0.1` branch.
5. Push the newly created `release/v0.1` branch to remote.
6. You can now start finalising your v0.1 release.

#### Finishing a release
Everything is finalized and you are ready to finish the release:

```bash
git roll release finish
```

What this command is doing under the hood:
1. Check out to your local development branch.
2. Pull latest changes from your remote development branch.
3. Merge `release/v0.1` branch into development branch.
    - If there is no merge conflict:
        - Push latest changes to remote development branch.
    - If there is merge confilct:
        - Abort the merge and stop the process.
        - Checkout to `release/v0.1`
        - Perform a rebase with updated local development branch.
        - Telling you to fix those conflicts and run `git roll release finish` again when you are done.
4. Checkout to your local master branch.
5. Pull latest changes from your remote master branch.
6. Merge `release/v0.1` branch into master branch.
    - If there is no merge confilct:
        - Create a new annotated tag `v0.1`.
        - Push the `v0.1` tag to remote.
        - Push latest changes to remote master branch.
        - Delete both local and remote release branches.
        - Checkout to develop branch.
    - If there is merge confilct:
        - Abort the merge and stop the process.
        - Telling you to fix those conflicts and call `git commit` when you are done.
        - You can then finish it yourself with the guides or call `git roll release cleanup v0.1`

#### Cleaning up a release
This should only be called after you have fixed the merge conflicts when trying to merge the
release branch into the master branch.

```bash
git roll release cleanup v0.1
```

What this command is doing under the hood:
1. Check if `v0.1` has been created, create one if it hasn't.
2. Push the `v0.1` tag to remote.
3. **Force push** latest changes to the remote master branch.
4. Delete both the local and remote release branches.
5. Checkout to develop branch.

### git roll hotfix
Available commands:
- git roll hotfix start "version"
- git roll hotfix finish
- git roll hotfix cleanup "version"

#### Starting a hotfix
Your friend reported that there is a bug with the login flow. You can start a hotfix branch by:

```bash
git roll hotfix start v0.2
```

What this command is doing under the hood:
1. Check out to your local development master.
2. Pull latest changes from your remote master branch.
3. Create a new hotfix branch with the prefix you have given base on the master branch:
    - A new branch `hotfix/v0.2` will be created.
4. Check out to the `hotfix/v0.2` branch.
5. Push the newly created `hotfix/v0.2` branch to remote.
6. You can now start fixing the bug.

#### Finishing a release
Phew.., you found the bug and fixed it under one hour. You can now finish the hotfix by:

```bash
git roll hotfix finish
```

What this command is doing under the hood:
1. Check out to your local master branch.
2. Pull latest changes from your remote master branch.
3. Merge `hotfix/v0.2` branch into master branch.
    - If there is no merge conflict:
        - Create a new annotated tag `v0.2`.
        - Push the `v0.2` tag to remote.
        - Push latest changes to remote master branch.
    - If there is merge confilct:
        - Abort the merge and stop the process.
        - Checkout to `hotfix/v0.2`
        - Perform a rebase with updated local master branch.
        - Telling you to fix those conflicts and run `git roll hotfix finish` again when you are done.
4. Checkout to your local develop branch.
5. Pull latest changes from your remote development branch.
6. Merge `hotfix/v0.2` branch into development branch.
    - If there is no merge confilct:
        - Push latest changes to remote development branch.
        - Delete both local and remote hotfix branches.
    - If there is merge confilct:
        - Abort the merge and stop the process.
        - Telling you to fix those conflicts and call `git commit` when you are done.
        - You can then finish it yourself with the guides or call `git roll hotfix cleanup v0.2`

#### Cleaning up a hotfix
This should only be called after you have fixed the merge conflicts when trying to merge the
hotfix branch into the development branch.

```bash
git roll hotfix cleanup v0.1
```

What this command is doing under the hood:
1. **Force push** latest changes to the remote development branch.
2. Delete both the local and remote release branches.
3. Checkout to develop branch.

## Pro Tips
You can add aliases to your shell. For example, I am using `zsh` shell and I have the following
aliases set up in my `.zshrc`:

```bash
# git-roll aliases
alias gr="git roll"
alias grf="git roll feature"
alias grr="git roll release"
alias grh="git roll hotfix"
```

Now I can do something like:
```bash
# init
gr init

# feature
grf start feature1
grf finish

# release
grr start v0.1
grr finish
grr cleanup v0.1

# hotfix
grh start v0.2
grh finish
grh cleanup v0.2
```

## Acknowledgement
This projects is highly inspired by:
1. [git-flow](https://github.com/nvie/gitflow)
2. [git-HubFlow](https://github.com/datasift/gitflow)


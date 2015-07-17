#!/bin/bash

# Git shortcuts
alias ga='git add '
alias gd='git diff'
alias gr='git rm'
alias gs='git status'
alias gss='git status -s'
alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)&lt;%an&gt;%Creset' --abbrev-commit"
alias gc='git commit -m'
alias gull='git pull origin'
alias gush='git push origin'
alias gco='git checkout'

#alias grpyc="git status | awk '{if($2=\"deleted:\"){printf $3\" \"}}'"
#alias grpyc="git status | awk '{if($3 ~ /pyc$/){printf $3\" \"}}'"
#alias grpyc="git status | awk '{if($3 ~ /pyc$/){printf $3" "}}'"

#alias gst='git status'

#alias gush='git push --all'
#
#alias gsh='git show'
#
#alias gb='git branch'
#alias gba='git branch -a'
#
#alias gco='git checkout'
#
#alias gd1='echo "git diff HEAD"; git diff HEAD'
#alias gd2='echo "git diff HEAD^"; git diff HEAD^'
#alias gdh='git diff HEAD'
#
#alias grmall="git status | grep 'deleted:' | awk '{print \$3}' | xargs git rm -f"
#
#alias gf='git svn fetch'
#alias gfr='git svn fetch && git svn rebase'
#alias gdc='git svn dcommit'
#alias gnc='git svn fetch && git svn rebase && git svn dcommit'
#alias gcn='git svn fetch && git svn rebase && git svn dcommit'
#
## Git submodule shortcuts
#alias gsa='git submodule add'
#alias gsu='git submodule update --init'
#
#alias gcl='git clone'
#
## Usage:
##   gc 'bug is fixed'                 # non-interactive mode
##   gc                                # interactive mode
##   Commit message: bug is fixed
##
#function gc { 
#  local commitmessage
#  if [ "" = "$1" ]; then 
#    echo -n 'Commit message: '
#    commitmessage="$(ruby -e "puts gets")"
#    git commit -m "$commitmessage"
#  else
#    git commit -m "$1"
#  fi
#}

## Aliases
#alias gss='git status -s'
#alias gup='git fetch && git rebase'
#alias gp='git push'
#alias gpo='git push origin'
#alias gdv='git diff -w "$@" | vim -R -'
#alias gc='git commit -v'
#alias gca='git commit -v -a'
#alias gci='git commit --interactive'
#alias gb='git branch'
#alias gba='git branch -a'
#alias gcount='git shortlog -sn'
#alias gcp='git cherry-pick'
#alias gco='git checkout'
#alias gexport='git archive --format zip --output'
#alias gdel='git branch -D'
#alias gmu='git fetch origin -v; git fetch upstream -v; git merge upstream/master'
#alias gll='git log --graph --pretty=oneline --abbrev-commit'
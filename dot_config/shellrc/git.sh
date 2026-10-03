# Git etc stuff

if [[ -f $HOME/.gitconfig.$USER ]]; then
    export GIT_CONFIG_GLOBAL=$HOME/.gitconfig.$USER
fi

# A function instead of an alias so that g will work when non-interactive
# (such as inside gittreeif).  But in some places the alias already exists,
# so remove it first.
unalias g 2>/dev/null
g() { PYTHONWARNDEFAULTENCODING= git "$@"; }

if command -v diff-so-fancy >/dev/null; then
    export GIT_PAGER='diff-so-fancy | less -iFRQX'
fi

if [[ $SHELL_TYPE == zsh ]]; then
    compdef g=git
fi

if [[ $SHELL_TYPE == bash ]]; then
    if [[ -r ~/.git-completion.bash ]]; then
        source ~/.git-completion.bash
        __git_complete g __git_main
    fi
fi

# Use our own ~/bin/git-ref-grep to filter references based on a line in .treerc
export TIG_LS_REMOTE=git-ref-grep

# A pager to get exactly one screen of output (taking the prompt into account),
# like this:
#
#   % 1s git log
#
# Define GIT_PAGER and PAGER to be sure it works.
alias 1s='PAGER="head -n $(($(tput lines)-4))" GIT_PAGER=$PAGER'

# Watch the actions, and when they pass, merge to main and push.
alias gshipit='watchgha --wait-for-start --poll 5 --message="Shipping $(git rev-parse --abbrev-ref @)" && g ma && g brmerge- && g push'
alias wgha='watchgha'

# Make it easier to work with merge conflicts.
alias eflict='e $(git flict)'
alias gaflict='git add $(git flict)'

# Checkout a PR from someone's fork
alias otherpr='withop github gh pr checkout $1'

# Push back to the PR from someone's fork
alias otherpush='withop github git -c credential.helper="!gh auth git-credential" push'

# Git hooks are invisible but change what git commands do, so announce them
# when entering a repo.
if [[ $SHELL_TYPE == zsh && -n $PS1 ]]; then
    git_show_hooks() {
        local git_dir=$(git rev-parse --absolute-git-dir 2>/dev/null)
        if [[ -z $git_dir ]]; then
            _git_shown_hooks_dir=
            return
        fi
        local hooks_dir=$(git rev-parse --git-path hooks)
        hooks_dir=${hooks_dir:a}
        # Only announce once per repo, not for every cd inside it.
        if [[ $hooks_dir == $_git_shown_hooks_dir ]]; then
            return
        fi
        _git_shown_hooks_dir=$hooks_dir

        local -a hooks
        local hook
        # modifiers: N (don't error) - (follow symlinks) .x (regular executable files)
        for hook in $hooks_dir/*(N-.x); do
            if [[ $hook != *.sample ]]; then
                hooks+=(${hook:t})
            fi
        done
        if (( $#hooks )); then
            echo -e "\e[31mgit hooks:\e[0m $hooks (from $git_dir)"
        fi
    }

    git_check_precommit() {
        local toplevel=$(git rev-parse --show-toplevel 2>/dev/null)
        if [[ -z $toplevel ]]; then
            _git_shown_precommit_dir=
            return
        fi
        # Only announce once per repo, not for every cd inside it.
        if [[ $toplevel == $_git_shown_precommit_dir ]]; then
            return
        fi
        _git_shown_precommit_dir=$toplevel

        if [[ ! -f $toplevel/.pre-commit-config.yaml ]]; then
            return
        fi
        local hooks_dir=$(git rev-parse --git-path hooks)
        hooks_dir=${hooks_dir:a}
        local pc_installed=0
        if [[ -f $hooks_dir/pre-commit ]]; then
            if grep -q 'pre-commit.com' $hooks_dir/pre-commit 2>/dev/null; then
                pc_installed=1
            fi
        fi
        if (( ! pc_installed )); then
            echo -e "\e[31mpre-commit:\e[0m not installed, run 'pre-commit install' ($toplevel/.pre-commit-config.yaml)"
        fi
    }

    autoload -Uz add-zsh-hook
    add-zsh-hook chpwd git_show_hooks
    add-zsh-hook chpwd git_check_precommit
fi

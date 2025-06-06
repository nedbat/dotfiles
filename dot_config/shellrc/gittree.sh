# Run a command for every repo found somewhere beneath the current directory.
#
#   $ gittree git fetch --all --prune
#
# To only run commands in repos with a particular branch, use gittreeif:
#
#   $ gittreeif branch_name git fetch --all --prune
#
# If the command has subcommands that need to run in each directory, quote the
# entire command:
#
#   $ gittreeif origin/foo 'git log --format="%s" origin/foo ^$(git merge-base origin/master origin/foo)'
#
# The directory name is printed before each command.  Use -q to suppress this,
# or -r to show the origin remote url instead of the directory name.
#
#   $ gittreeif origin/foo -q git status
#
gittreeif() {
    local test_branch="$1"
    shift
    local show_dir=true show_repo=false
    if [[ $1 == -r ]]; then
        # -r means, show the remote url instead of the directory.
        shift
        local show_dir=false show_repo=true
    fi
    if [[ $1 == -q ]]; then
        # -q means, don't echo the separator line with the directory.
        shift
        local show_dir=false show_repo=false
    fi
    find . -name .git -type d -prune | while read d; do
        local d=$(dirname "$d")
        if [[ "$test_branch" != "" ]]; then
            git -C "$d" rev-parse --verify -q "$test_branch" >& /dev/null || continue
        fi
        if [[ $show_dir == true ]]; then
            echo -e "\e[2m---- $d ----\e[22m"
        fi
        if [[ $show_repo == true ]]; then
            echo -e "\e[2m----" $(git -C "$d" config --get remote.origin.url) "----\e[22m"
        fi
        if [[ $# == 1 && $1 == *' '* ]]; then
            (cd "$d" && eval "$1")
        else
            (cd "$d" && "$@")
        fi
    done
}

gittree() {
    # Run a command on all git repos.
    gittreeif "" "$@"
}

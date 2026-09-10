# Pythons
alias p='python3'
alias te='tox -q -e'
alias tm='tox -q -m'

ten0k() {
    tox -q -e $1 -- -n 0 -k $2 $3 $4 $5
}

# For special cases, define a local function:
#   ten0kq() {
#       .tox/$1/bin/python3 igor.py test_with_tracer c -n 0 -k $2
#   }

export PYTHONSTARTUP=$XDG_CONFIG_HOME/startup.py
export _PYTHON_BIN="$(python3 -c "import sysconfig; print(sysconfig.get_path('scripts'))")"
export PATH="$PATH:$_PYTHON_BIN"
if [[ -w /tmp ]]; then
    export PYTHONPYCACHEPREFIX=/tmp/$(whoami)-pyc
    mkdir -p $PYTHONPYCACHEPREFIX
    chmod 700 $PYTHONPYCACHEPREFIX
fi

# Activate a virtualenv somewhere, default here.
workin() {
    for d in ${1:-.}/{.,venv,.venv}; do
        if [[ -f $d/bin/activate ]]; then
            source $d/bin/activate
        fi
    done
}

# Set the prompt slug for the current virtualenv.
setvenvname() {
    if [[ -n $VIRTUAL_ENV ]]; then
        sed -i -n -e "/^prompt =/d" $VIRTUAL_ENV/pyvenv.cfg
        echo "prompt = $1" >> $VIRTUAL_ENV/pyvenv.cfg
    else
        echo "No virtualenv activated, nothing to do"
    fi
}

export PIP_REQUIRE_VIRTUALENV=true
export PIP_DISABLE_PIP_VERSION_CHECK=1

unset _PYTHON_BIN

# miniconda
# Conda likes to change the prompt, use this to stop it so other fancier prompts win:
#   conda config --set changeps1 False
if [[ -d /usr/local/miniconda ]]; then
    eval "$(/usr/local/miniconda/bin/conda shell.$SHELL_TYPE hook)"
fi

if [[ -n $PS1 ]]; then
    # If we are already in a Python virtualenv, re-activate it to make sure it wins
    # the $PATH wars.
    if [[ -n $VIRTUAL_ENV ]]; then
        echo "Reactivating $VIRTUAL_ENV.."
        source $VIRTUAL_ENV/bin/activate
    fi
fi

# Compilation under Cygwin:
# Usage:    ./cygwin_make.sh [python_environment]
#   - Check if 'python' command refers to Anaconda Python, rather than Cywin's
#     If necessary, activate Anaconda requested virtual environment
#   - Check if PyTorch is installed
#   - Set the environment variables for Visual C++ compiler (using Windows command shell for calling .bat file)
#   - If successful ('cl' is accessible), then launch make.sh (using Cygwin Bash)
if ! type python | grep -i conda ; then
    if ! . /cygdrive/c/ProgramData/*conda3/Scripts/activate $1 ; then
        if ! . $(cygpath $USERPROFILE)/*conda3/Scripts/activate $1 ; then
            echo "Can't find Anaconda 'python' command :-("
            echo "Call '. activate' before launching '$0'!"
            exit 1
        fi
    fi
fi
type python
if ! python -c 'import torch ; print("PyTorch version:", torch.__version__)' ; then
    echo "PyTorch not installed in your Anaconda Python environment :-("
    echo "If it has been installed in a virtual environment, pass the environment's name as command line argument, e.g."
    echo "    $0 py_with_torch"
    exit 1
fi

VCVARSALL="C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat"
BASH_FROM_WINDOWS=$(cygpath -w $(type -p bash))
cmd /c "$(cygpath -ws "$VCVARSALL") x64 -vcvars_ver=14.0 && cl > NUL: && $BASH_FROM_WINDOWS make.sh"

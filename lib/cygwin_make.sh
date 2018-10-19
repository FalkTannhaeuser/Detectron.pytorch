# Compilation under Cygwin:
# Usage:    ./cygwin_make.sh [python_virtual_environment]
#   - Check if 'python' command refers to Anaconda Python, rather than Cywin's
#     If necessary, activate Anaconda requested virtual environment
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

VCVARSALL="C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat"
BASH_FROM_WINDOWS=$(cygpath -w $(type -p bash))
cmd /c "$(cygpath -ws "$VCVARSALL") x64 -vcvars_ver=14.0 && cl > NUL: && $BASH_FROM_WINDOWS make.sh"

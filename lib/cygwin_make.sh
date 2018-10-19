##########################################################################
# Compilation under Cygwin:
# Usage:    ./cygwin_make.sh [python_environment]
##########################################################################

##########################################################################
# Verify your MSVC compiler toolsets as follows:
# If you have "Visual Studio Community 2017" (downloadable from
# https://visualstudio.microsoft.com/free-developer-offers/):
#   - Launch "Visual Studio Installer"
#   - Click the "Modify" button, then select menu "Individual components"
#   - In the left panel, scroll down to "Compilers, build tools and runtimes" category
#   - If either "VC++ 2015.3 v14.00 (v140) toolset for desktop"
#     or        "VC++ 2017 version 15.4 v14.11 toolset"
#     is already checked (i.e. installed), you can click the "Close" button in the installer.
#     In this file, you just need to modify (comment/uncomment) the MSVC_TOOLSET variable below accordingly.
#   - Otherwise, select the latter (v14.11) toolset and click the "Modify" button in the installer.
#   - Note that recent toolsets as e.g. "VC++ 2017 version 15.8 v14.15 latest v141 tools"
#     don't work with the CUDA compiler!
##########################################################################

#MSVC_TOOLSET="14.00"
MSVC_TOOLSET="14.11"

REPO_ROOT=$(realpath -e $(dirname $0)/..)
cd $REPO_ROOT/lib

# Check if 'python' command refers to Anaconda Python, rather than Cywin's
# If necessary, activate Anaconda requested virtual environment
if ! type python | grep -i conda ; then
    if ! . $(cygpath "C:\ProgramData\*conda3\Scripts\activate") $1 ; then
        if ! . $(cygpath $USERPROFILE)/*conda3/Scripts/activate $1 ; then
            echo "Can't find Anaconda 'python' command :-("
            echo "Call '. activate' before launching '$0'!"
            exit 1
        fi
    fi
fi
type python

# Check if PyTorch is installed
if ! python -c 'import torch ; print("PyTorch version:", torch.__version__)' ; then
    echo "PyTorch is not installed in your Anaconda Python environment :-("
    echo "If it has been installed in a virtual environment, pass the environment's name as command line argument, e.g."
    echo "    $0 py_with_torch"
    exit 1
fi

# Set the environment variables for Visual C++ compiler (using Windows command shell for calling .bat file)
# If successful ('cl' is accessible), then launch make.sh (using Cygwin Bash)
VCVARSALL="C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat"
#VCVARSALL="C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat"
BASH_FROM_WINDOWS=$(cygpath -w $(type -p bash))
cmd /c "$(cygpath -ws "$VCVARSALL") x64 -vcvars_ver=$MSVC_TOOLSET && cl > NUL: && $BASH_FROM_WINDOWS make.sh"

# These files get converted to CR/LF endings by PyTorch - ${CONDA_PREFIX}/lib/site-packages/torch/utils/ffi/__init__.py
# during compilation, which is confusing for the Git user
d2u -k model/nms/_ext/nms/__init__.py model/roi_crop/_ext/roi_crop/__init__.py \
       model/roi_pooling/_ext/roi_pooling/__init__.py modeling/roi_xfrom/roi_align/_ext/roi_align/__init__.py

# Print results
echo "Created the following binaries:"
find $REPO_ROOT -iname '*.pyd' -ls

# Compilation under Cygwin:
#   - Check if 'python' command refers to Anaconda Python, rather than Cywin's
#   - Set the environment variables for Visual C++ compiler (using Windows command shell for calling .bat file)
#   - Then launch make.sh (using Cygwin Bash)
type python | grep -i conda || ( echo "Can't find Anaconda python :-(" ; exit 1 )
cmd /c "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat" x64 -vcvars_ver=14.0 "&&" "c:\cygwin64\bin\bash" make.sh

# LLVM-TL: LTL checker plugin for LLVM

This is an LLVM plugin which checks LTL properties at the granularity of basic blocks. Read [the
report](report.pdf) for the details.

## Build instructions
Building this thing is kind of a nightmare. All of the model-checking software uses Autotools, while
LLVM and the plugin itself use CMake. ITS-LTL also requires a Java runtime to support the Antlr
parser.  All of the model-checking software should be built without LTO: pass `--enable-nolto`.

1. Install (and if necessary build) libSPOT (possibly available as a package), libDDD, and libITS on
your system library path, or modify `src/CMakeLists.txt` to point to the locations of their compiled
shared libraries.

3. Apply `ITS-LTL.patch` to the ITS-LTL submodule (compiles it as a static library as well as a
standalone executable). Follow the instructions in their README to acquire Antlr 3.4, and install
the library and the Java runtime on your system path. When configuring ITS-LTL, you need to give it
the location of the Antlr JAR via the `--with-antlrjar` option; it will not find it automatically.
You also need to update the C++ standard used to C++17 for compatibility with libSPOT; the easiest
way to do with is to invoke `configure` with `CXXFLAGS='-std=c++17' ./configure <args>`. Then build
and install ITS-LTL.

4. Build LLVM from the submodule. When configuring, pass `-DLLVM_ENABLE_EH -DLLVM_ENABLE_RTTI` to
CMake to enable features necessary for compatibility with the model-checking libraries. Building
LLVM takes a while; use of the Ninja buildsystem (rather than `make`) is strongly recommended (see
[LLVM build instructions](https://www.llvm.org/docs/CMake.html)).

5. Finally, you can build the plugin by running `cmake src` or `cmake .` from within `src`, followed
by `make` (no install). The buildsystem used is not important here (plugin built with Make is
compatible with LLVM built with Ninja). As discussed in the report, the property and functions to
check are statically defined; these definitions are at the top of TLPropPass.cpp. The list of
function names must end in a semicolon. Different test cases are enabled using preprocessor macros
set in `src/CMakeLists.txt`; test case 2 is enabled by default.

6. Now you can run the pass. First, generate LLVM bitcode from C/C++ with `clang -S -emit-llvm -o
<file>.ll <file>.[c|cpp]` (you can use the clang you just built, at `llvm-project/build/bin/clang`,
or one installed on the system). Then, run the pass from the root of the repo with
`llvm-project/build/bin/opt -load-pass-plugin=src/libTLPropPass.so -debug -passes=llvm-tl -o
/dev/null <file>.ll`. `-debug` enables output from the pass, and `-o /dev/null` is necessary to
discard the output (which will be identical to the input).


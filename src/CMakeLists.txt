cmake_minimum_required(VERSION 3.13.4)
project(llvm-tl)

#set(LT_LLVM_INSTALL_DIR "" CACHE PATH ../llvm-project/build)
set(LLVM_DIR "../llvm-project/build/lib/cmake/llvm/")

#list(APPEND CMAKE_PREFIX_PATH "${LT_LLVM_INSTALL_DIR}/lib/cmake/llvm/")

find_package(LLVM REQUIRED CONFIG)
find_library(ITSLTL REQUIRED NO_CACHE libitsltl.a PATHS ../ITS-LTL/src/.libs)

include_directories(SYSTEM ${LLVM_INCLUDE_DIRS})
include_directories("../ITS-LTL/src")

set(CMAKE_CXX_STANDARD 17 CACHE STRING "")

add_library(TLPropPass SHARED TLPropPass.cpp FunctionGAL.cpp AtProp.cpp) 
target_link_libraries(TLPropPass "${ITSLTL}")


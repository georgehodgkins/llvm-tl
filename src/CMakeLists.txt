cmake_minimum_required(VERSION 3.13.4)
project(llvm-tl)
set(CMAKE_BUILD_TYPE Debug)

#set(LT_LLVM_INSTALL_DIR "" CACHE PATH ../llvm-project/build)
set(LLVM_DIR "../llvm-project/build/lib/cmake/llvm/")
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

#list(APPEND CMAKE_PREFIX_PATH "${LT_LLVM_INSTALL_DIR}/lib/cmake/llvm/")

find_package(LLVM REQUIRED CONFIG)
find_library(ITSLTL REQUIRED NO_CACHE libitsltl.a PATHS /usr/local/lib)
set(ITSLTL "-Wl,--whole-archive ${ITSLTL} -Wl,--no-whole-archive")
find_library(LIBITS REQUIRED NO_CACHE libITS.a PATHS /usr/local/lib)
find_library(LIBSPOT REQUIRED libspot.so PATHS /usr/local/lib)
find_library(LIBDDD REQUIRED libDDD.so PATHS /usr/local/lib)
find_library(LIBANTLR3 REQUIRED libantlr3c.so PATHS /usr/local/lib)

include_directories(SYSTEM ${LLVM_INCLUDE_DIRS})
include_directories("../ITS-LTL/src")

set(CMAKE_CXX_STANDARD 17 CACHE STRING "")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DGLIBCXX_USE_CXX11_ABI=0 -DTESTCASE_1")

add_library(TLPropPass SHARED TLPropPass.cpp FunctionGAL.cpp AtProp.cpp) 
set_property(TARGET TLPropPass PROPERTY POSITION_INDEPENDENT_CODE ON)
target_link_libraries(TLPropPass "${ITSLTL} ${LIBSPOT} ${LIBITS} ${LIBDDD} ${LIBANTLR3}")



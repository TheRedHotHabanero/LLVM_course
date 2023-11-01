cmake_minimum_required(VERSION 3.16)
project(LLVM_course)

set(CMAKE_CXX_STANDARD 17)

find_package(SDL2 REQUIRED)

# Создаем директорию для сборки
set(CMAKE_BINARY_DIR ${CMAKE_SOURCE_DIR}/build)

# Создаем директорию сборки, если она не существует
file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR})

# Define the source files for your project
set(SOURCE_FILES
    ${CMAKE_SOURCE_DIR}/life.cpp
    ${CMAKE_SOURCE_DIR}/sim.cpp
)

add_executable(LLVM_course ${SOURCE_FILES})

target_link_libraries(LLVM_course SDL2)

# Define a custom target to generate LLVM IR
add_custom_target(GenerateLLVMIR
    COMMAND mkdir -p ${CMAKE_BINARY_DIR}/llvm_ir  # Create the output directory if it doesn't exist
    COMMAND clang++ -O2 -S -emit-llvm ${SOURCE_FILES} ${CMAKE_BINARY_DIR}/llvm_ir/
    DEPENDS LLVM_course
)

# Reset the compiler variables to their original values
set(CMAKE_CXX_COMPILER g++)
set(CMAKE_C_COMPILER gcc)

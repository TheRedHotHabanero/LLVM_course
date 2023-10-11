cmake_minimum_required(VERSION 3.16)
project(LLVM_course)

set(CMAKE_CXX_STANDARD 17)

set(SFML_DIR ../SFML/lib/cmake/SFML)

find_package(SFML 2.5 COMPONENTS graphics audio REQUIRED)

find_package(OpenMP REQUIRED)

# Создаем директорию для сборки
set(CMAKE_BINARY_DIR ${CMAKE_SOURCE_DIR}/build)

# Создаем директорию сборки, если она не существует
file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR})

# Добавьте флаги OpenMP для компиляции и линковки
if(OpenMP_CXX_FOUND)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${OpenMP_CXX_FLAGS}")
endif()

# Define the source files for your project
set(SOURCE_FILES
    ${CMAKE_SOURCE_DIR}/LifeGame/life.cpp
    ${CMAKE_SOURCE_DIR}/LifeGame/main.cpp
)

add_executable(LLVM_course ${SOURCE_FILES})

target_link_libraries(LLVM_course sfml-graphics sfml-audio)

# Define a custom target to generate LLVM IR
add_custom_target(GenerateLLVMIR
    COMMAND mkdir -p ${CMAKE_BINARY_DIR}/llvm_ir  # Create the output directory if it doesn't exist
    COMMAND clang++ -S -emit-llvm ${SOURCE_FILES} ${CMAKE_BINARY_DIR}/llvm_ir/
    DEPENDS LLVM_course
)

# Reset the compiler variables to their original values
set(CMAKE_CXX_COMPILER g++)
set(CMAKE_C_COMPILER gcc)

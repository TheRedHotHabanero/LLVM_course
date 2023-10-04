cmake_minimum_required(VERSION 3.16)
project(LLVM_course)

set(CMAKE_CXX_STANDARD 17)

set(SFML_DIR ../SFML/lib/cmake/SFML)

find_package(SFML 2.5 COMPONENTS graphics audio REQUIRED)

find_package(OpenMP REQUIRED)

# Добавьте флаги OpenMP для компиляции и линковки
if(OpenMP_CXX_FOUND)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${OpenMP_CXX_FLAGS}")
endif()

add_executable(LLVM_course
    ${CMAKE_SOURCE_DIR}/LifeGame/life.cpp
    ${CMAKE_SOURCE_DIR}/LifeGame/main.cpp)

target_link_libraries(LLVM_course sfml-graphics sfml-audio)
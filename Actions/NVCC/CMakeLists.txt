cmake_minimum_required(VERSION 3.8 FATAL_ERROR)

add_executable(simplest ../simplest.cu)

## CMAKE_CUDA_ARCHITECTURES now detected for NVCC, empty CUDA_ARCHITECTURES not allowed.
set_property(TARGET simplest PROPERTY CUDA_ARCHITECTURES OFF) 

project(simplest LANGUAGES CXX CUDA)
enable_language(CUDA)

enable_testing()
add_test(NAME simplest COMMAND simplest) 

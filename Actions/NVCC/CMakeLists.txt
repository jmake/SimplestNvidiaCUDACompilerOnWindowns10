cmake_minimum_required(VERSION 3.8 FATAL_ERROR)
project(hello LANGUAGES CXX CUDA)
enable_language(CUDA)
add_executable(smallest.x ../smallest.cu)

## CMAKE_CUDA_ARCHITECTURES now detected for NVCC, empty CUDA_ARCHITECTURES not allowed.
set_property(TARGET smallest.x PROPERTY CUDA_ARCHITECTURES OFF) 

enable_testing()
add_test(NAME smallest COMMAND smallest.x) 

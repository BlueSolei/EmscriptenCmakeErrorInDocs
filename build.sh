rm -rf build
emcmake cmake -S . -B build
emmake cmake --build build --parallel 8 
cmake --install build

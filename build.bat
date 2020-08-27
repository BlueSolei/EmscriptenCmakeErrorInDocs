rd /q/s build 2>nul
call emcmake cmake -S . -B build
call emmake cmake --build build --parallel 8 
cmake --install build

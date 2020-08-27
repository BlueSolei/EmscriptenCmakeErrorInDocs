cmake_minimum_required(VERSION 3.16)

project(cmake-s-issue)

set(EXAMPLE_TARGETS
    example-good-1
    example-good-2
    example-bad-1
    example-bad-2
    example-bad-3
    example-bad-4
    example-bad-5)

foreach(EXAMPLE_TARGET ${EXAMPLE_TARGETS})
  add_executable(${EXAMPLE_TARGET} main.c)
  install(TARGETS ${EXAMPLE_TARGET} DESTINATION bin)
  install(FILES ${CMAKE_BINARY_DIR}/${EXAMPLE_TARGET}.wasm DESTINATION bin)
endforeach()

if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  set(CMAKE_INSTALL_PREFIX
      ${CMAKE_SOURCE_DIR}
      CACHE PATH "" FORCE)
endif()

# DO work: (with space, multiple options, with shell, separate quotes)
target_link_options(example-good-1 PRIVATE "SHELL: -s WASM=1"
                    "SHELL: -s ASYNCIFY=1")

# (with space, multiple options, with shell, single quote)
target_link_options(example-good-2 PRIVATE "SHELL: -s WASM=1 -s ASYNCIFY=1")

# DON'T work: (without space, multiple options, with shell, separate quotes)
target_link_options(example-bad-1 PRIVATE "SHELL: -sWASM=1"
                    "SHELL: -sASYNCIFY=1")

# (with space, multiple options, without shell, separate quotes)
target_link_options(example-bad-2 PRIVATE "-s WASM=1" "-s ASYNCIFY=1")

# (without space, multiple options, without shell, single quote)
target_link_options(example-bad-3 PRIVATE "-sWASM=1 -sASYNCIFY=1")

# (without space, multiple options, with shell, single quote)
target_link_options(example-bad-4 PRIVATE "SHELL: -sWASM=1 -sASYNCIFY=1")

# (with space, multiple options, without shell, single quote)
target_link_options(example-bad-5 PRIVATE "-s WASM=1 -s ASYNCIFY=1")

# cmake `-s` issues when using `target_link_options()` to build for Emscripten

From the [Emscripten documentation](https://emscripten.org/docs/getting_started/FAQ.html?highlight=faq#how-do-i-specify-s-options-in-a-cmake-project) 
you can see that one way to overcome cmake's quirks,
is to write `-sX=Y` instead of `-s X=Y` (mind the space).
> However, some ``-s`` options may require quoting, or the space between ``-s``
and the next argument may confuse CMake, when using things like
``target_link_options``. To avoid those problems, you can use ``-sX=Y``
notation, that is, without a space:
> ```
> # same as before but no space after -s
>  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -sUSE_SDL=2")
>  # example of target_link_options with a list of names
>  target_link_options(example PRIVATE "-sEXPORTED_FUNCTIONS=[_main]")
>```

This seems to be wrong, as it doesn't seem to solve the problem.  
The [cmake docs](https://cmake.org/cmake/help/latest/command/target_link_options.html) for `target_link_options` 
explains that the issue arise from cmake merging same options (here `-s`) together.  
To mitigate this, they recommend to perpend the linker's options string with '`SHELL:`'.  
>The final set of compile or link options used for a target is constructed by accumulating options from the current target and the usage requirements of its dependencies. The set of options is de-duplicated to avoid repetition. While beneficial for individual options, the de-duplication step can break up option groups. For example, `-D A -D B` becomes `-D A B`. One may specify a group of options using shell-like quoting along with a `SHELL:` prefix. The `SHELL:` prefix is dropped, and the rest of the option string is parsed using the `separate_arguments()` UNIX_COMMAND mode. For example, `"SHELL:-D A" "SHELL:-D B"` becomes `-D A -D B`.


**So instead of writing this:**

```
target_link_options(example PRIVATE "-s USE_SDL=2 -s EXPORTED_FUNCTIONS=[_main]")
```

**You should write:*
```
target_link_options(example PRIVATE "SHELL: -s USE_SDL=2 -s EXPORTED_FUNCTIONS=[_main]")
```

## In the repo:
I created tests for all kind of combinations of spaces, quotes, and use of '`SHELL:`'.  
I run each test in nodejs, and you can see it fail because it can't fins the `Asyncify` module, since the linking is messed up.  

To run the tests:  
1. open a shell
2. make sue emsdk is in your env
3. build.bat/sh
4. run_tests.bat/sh

look in the `CMakeLists.txt` file for the different options.

Thanks to @sammax at the Discord channel, to discuss this with me :-)
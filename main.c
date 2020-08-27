#include <emscripten.h>

EM_JS(void, callAsyncify, (),
      { Asyncify.handleSleep(function(wakeUp) { wakeUp(); }); });

int main() {
  callAsyncify();
}

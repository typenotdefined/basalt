#include <stdio.h>
#include <stdlib.h>
#include <gmodc/lua/interface.h>

GMOD_MODULE_OPEN() {
  printf("Hello from console");

  return 0;
}

GMOD_MODULE_CLOSE() {
  return 0;
}
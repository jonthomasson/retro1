#include <stdio.h>
#include <stdlib.h>
#include "acia.h"
#include "led.h"
#include "basic.h"
#include "readline.h"

int main() {

  acia_init();
  
  led_init();
  
  //basic_init();

  acia_puts("6502 HomeComputer ready.\n");
  
  sprintf(print_buffer, "%u bytes free.\n", _heapmemavail());
  acia_puts(print_buffer);
  acia_puts("Ready.\n");
  

  /*for (;;) {
    char * line = readline(NON_INTERRUPTIBLE);
    interpret(line);
  }*/

  return 0;
}
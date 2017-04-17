
#include <stdio.h>
#include <stdlib.h>
#include "led.h"
#include "tools.h"
#include "acia.h"

char print_buffer[80];
//char resp;
int ison;
int main() {
    
    led_init();
    acia_init();
    ison = 0;
    *print_buffer = '\0';
    acia_puts("6502 HomeComputer ready.\r\n");
    //sprintf(print_buffer, "%u bytes free.\n", _heapmemavail());
  //acia_puts(print_buffer);
  //acia_puts("Ready.\n");
  for (;;) {
      acia_puts("Type something.\r\n");
      //resp = acia_getc();
      acia_gets(print_buffer, 255);
      acia_puts("You typed: ");
      //acia_putc(resp);
      acia_puts(print_buffer);
      
      acia_puts("\r\n");
      if(ison == 0){
          ison = 1;
      }else{
          ison = 0;
      }
    led_set(ison);
    
    //delay_ms(200);
    //led_set(1);
    //delay_ms(100);
  }

  return 0;
}
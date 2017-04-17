
#include "led.h"
#include "tools.h"


int main() {

  led_init();
  for (;;) {
    led_set(0);
    delay_ms(100);
    led_set(1);
    delay_ms(100);
  }

  return 0;
}
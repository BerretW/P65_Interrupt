#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include "acia.h"
#include "utils.h"


void print_f(char * s){
  acia_put_newline();
  acia_puts(s);
}





void main(void) {
int i = 0;
IRQ_enable();
timer_setup();
print_f("Ahoj zde interruot");

while(1){
++i;
//acia_putc(i);

}
}

#ifndef _DEBUG_H
#define _DEBUG_H

extern void debug_keys(void);
extern void debug_key_matrix(void);
#define debug_printf(fmt) {sprintf(print_buffer, fmt); acia_puts(print_buffer);}
#define debug_printf1(fmt, arg1) {sprintf(print_buffer, fmt, arg1); acia_puts(print_buffer);}
#define debug_printf2(fmt, arg1, arg2) {sprintf(print_buffer, fmt, arg1, arg2); acia_puts(print_buffer);}

#endif

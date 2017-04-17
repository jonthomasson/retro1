#ifndef _ACIA_H
#define _ACIA_H

extern void acia_init(void);
extern void __fastcall__ acia_putc(char c);
extern void __fastcall__ acia_puts(const char * s);
extern void acia_put_newline(void);
extern char acia_getc(void);
extern void __fastcall__ acia_gets(char * buffer, unsigned char n);

#endif

; ----------------- assembly instructions ---------------------------- 
;
; this is a subroutine library only
; it must be included in an executable source file
;
;
;*** I/O Locations *******************************
; define the i/o address of the Via1 chip
;*** 6522 CIA ************************
Via1Base       =     $7f50
Via1PRB        =     $7f50
Via1PRA        =     $7f51
Via1DDRB       =     $7f52
Via1DDRA       =     $7f53
Via1T1CL       =     $7f54
Via1T1CH       =     $7f55
Via1T1LL       =     $7f56
Via1TALH       =     $7f57
Via1T2CL       =     $7f58
Via1T2CH       =     $7f59
Via1SR         =     $7f5a
Via1ACR        =     $7f5b
Via1PCR        =     $7f5c
Via1IFR        =     $7f5d
Via1IER        =     $7f5e
Via1PRA1       =     $7f5f
;
;***********************************************************************
; 6522 VIA I/O Support Routines
;
Via1_init      ldx   #$00              ; get data from table
Via1init1      lda   Via1idata,x       ; init all 16 regs from 00 to 0F
               sta   Via1Base,x        ; 
               inx                     ; 
               cpx   #$0f              ; 
               bne   Via1init1         ;       
               rts                     ; done
;
Via1idata      .byte $00               ; prb  '00000000'
               .byte $00               ; pra  "00000000'
               .byte $00               ; ddrb 'iiiiiiii'
               .byte $00               ; ddra 'iiiiiiii'
               .byte $00               ; tacl  
               .byte $00               ; tach  
               .byte $00               ; tall  
               .byte $00               ; talh  
               .byte $00               ; t2cl
               .byte $00               ; t2ch
               .byte $00               ; sr
               .byte $00               ; acr
               .byte $00               ; pcr
               .byte $7f               ; ifr
               .byte $7f               ; ier
; 
;
;
;end of file

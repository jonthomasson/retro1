.setcpu "65C02"
.code
;---------------------------------------------------------------------
;  SBC Firmware V5.1, 5-30-05, by Daryl Rictor
;
; ----------------- assembly instructions ---------------------------- 
;               *=   $E800                ; start of operating system
;Start_OS       jmp   MonitorBoot         ; easy access to monitor program
Jmp_CR	   jmp   Print_CR		
Jmp_1sp	   jmp   Print1SP			; jump table for usable monitor
Jmp_2sp	   jmp   Print2SP			; routines
Jmp_xsp	   jmp   PrintXSP			; This will not change in future
Jmp_nib	   jmp   PrintDig			; releases, only be added to
Jmp_byte	   jmp   Print1Byte
jmp_wrd	   jmp   Print2Byte
jmp_bell	   jmp   Bell
jmp_delay	   jmp   Delay
jmp_scan	   jmp   Scan_input
jmp_inp        jmp   Input_chr  
jmp_out        jmp   Output
jmp_input	   jmp   Input
jmp_input1     jmp   Input1
;
;
;*********************************************************************       
;  local Zero-page variables
;
Prompt         =     $32               ; 1 byte   
linecnt        =     $33               ; 1 byte
Modejmp        =     $34               ; 1 byte
Hexdigcnt      =     $35               ; 1 byte
OPCtxtptr      =     $36               ; 1 byte
Memchr         =     $37               ; 1 byte
Startaddr      =     $38               ; 2 bytes
Startaddr_H    =     $39
Addrptr        =     $3a               ; 2 bytes
Addrptr_H       =    $3b
Hexdigits      =     $3c               ; 2 bytes
Hexdigits_H    =     $3d
Memptr         =     $3e               ; 2 bytes
Memptr_H       =     $3f
;
; Local Non-Zero Page Variables
;
buffer         =     $0300             ; keybd input buffer (127 chrs max)
PCH            =     $03e0             ; hold program counter (need PCH next to PCL for Printreg routine)
PCL            =     $03e1             ;  ""
ACC            =     $03e2             ; hold Accumulator (A)
XREG           =     $03e3             ; hold X register
YREG           =     $03e4             ; hold Y register
SPTR           =     $03e5             ; hold stack pointer
PREG           =     $03e6             ; hold status register (P)
ChrInVect      =     $03eb             ; holds Character Input Address
ScanInVect     =     $03ee             ; holds Character Scan Input address
ChrOutVect     =     $03f1             ; holds Character Output Address
BRKvector      =     $03f4             ; holds application break vector
RESvector      =     $03f7             ; 2F7,8,9 holds application reset vector & checksum
INTvector      =     $03fa             ; 2FA,B,C holds application interrupt vector & checksum
NMIvector      =     $03fd             ; 2FD,E,F holds application NMI vector & checksum

;               
; *************************************************************************
; kernal commands
; *************************************************************************
; PrintRegCR   - subroutine prints a CR, the register contents, CR, then returns
; PrintReg     - same as PrintRegCR without leading CR
; Print2Byte   - prints AAXX hex digits
; Print1Byte   - prints AA hex digits
; PrintDig     - prints A hex nibble (low 4 bits)
; Print_CR     - prints a CR (ASCII 13)and LF (ASCII 10)
; PrintXSP     - prints # of spaces in X Reg
; Print2SP     - prints 2 spaces
; Print1SP     - prints 1 space
; Input_assem  - Alternate input prompt for Assember
; Input        - print <CR> and prompt then get a line of input, store at buffer
; Input_Chr    - get one byte from input port, waits for input
; Scan_Input   - Checks for an input character (no waiting)
; Output       - send one byte to the output port
; Bell         - send ctrl-g (bell) to output port
; Delay        - delay loop
; *************************************************************************
;
RegData        .byte" PC=  A=  X=  Y=  S=  P= (NVRBDIZC)="
;
PrintReg       Jsr   Print_CR          ; Lead with a CR
               ldx   #$ff              ;
               ldy   #$ff              ;
Printreg1      iny                     ;
               lda   RegData,y         ;
               jsr   Output            ;
               cmp   #$3D              ; "="
               bne   Printreg1         ;
Printreg2      inx                     ;
               cpx   #$07              ;
               beq   Printreg3         ; done with first 6
               lda   PCH,x             ;  
               jsr   Print1Byte        ;
               cpx   #$00              ;
               bne   Printreg1         ;
               bra   Printreg2         ;
Printreg3      dex                     ;
               lda   PCH,x             ; get Preg
               ldx   #$08              ; 
Printreg4      rol                     ;
               tay                     ;
               lda   #$31              ;
               bcs   Printreg5         ;
               dec                     ;
Printreg5      jsr   Output            ;
               tya                     ;
               dex                     ;
               bne   Printreg4         ;
; fall into the print CR routine
Print_CR       PHA                     ; Save Acc
               LDA   #$0D              ; "cr"
               JSR   Output            ; send it
               LDA   #$0A              ; "lf"
               JSR   Output            ; send it
               PLA                     ; Restore Acc
               RTS                     ; 

Print2Byte     JSR   Print1Byte        ;  prints AAXX hex digits
               TXA                     ;
Print1Byte     PHA                     ;  prints AA hex digits
               LSR                     ;  MOVE UPPER NIBBLE TO LOWER
               LSR                     ;
               LSR                     ;
               LSR                     ;
               JSR   PrintDig          ;
               PLA                     ;
PrintDig       PHY                     ;  prints A hex nibble (low 4 bits)
               AND   #$0F              ;
               TAY                     ;
               LDA   Hexdigdata,Y      ;
               PLY                     ;
               jmp   Output            ;
PrintXSP1      JSR   Print1SP          ;
               dex                     ;
PrintXSP       cpx   #$00              ;
               bne   PrintXSP1         ;
               rts                     ;
Print2SP       jsr   Print1SP          ; print 2 SPACES
Print1SP       LDA   #$20              ; print 1 SPACE
               JMP   Output            ;
;
Input_Assem    lda   #$21              ; Assembler Prompt "!"
               .byte $2c               ; mask out next line to bypass 
Input          lda   #$3E              ; Monitor Prompt ">"
               sta   Prompt            ; save prompt chr 
Input1         jsr   Print_CR          ; New Line
               lda   Prompt            ; get prompt
               jsr   Output            ; Print Prompt
               ldy   #$ff              ; pointer
InputWait      jsr   Input_chr         ; get a character
               cmp   #$20              ; is ctrl char?
               BCS   InputSave         ; no, echo chr 
               cmp   #$0d              ; cr
               Beq   InputDone         ; done
               cmp   #$1B              ; esc
               beq   Input1            ; cancel and new line
               cmp   #$08              ; bs
               beq   backspace         ;
		   cmp   #$09		   ; TAB key
		   beq   tabkey		   ;
               cmp   #$02              ; Ctrl-B
               bne   InputWait         ; Ignore other codes
               brk                     ; Force a keyboard Break cmd
backspace      cpy   #$ff              ;
               beq   InputWait         ; nothing to do
               dey                     ; remove last char
               Lda   #$08              ; backup one space
               jsr   Output            ;
               Lda   #$20              ; Print space (destructive BS)
               jsr   Output            ;
               Lda   #$08              ; backup one space
               jsr   Output            ;
               BRA   InputWait         ; ready for next key
tabkey	   lda   #$20		   ; convert tab to space
		   iny			   ; move cursor
               bmi   InputTooLong	   ; line too long?
               sta   buffer,y		   ; no, save space in buffer
		   jsr   Output		   ; print the space too
               tya   			   ; test to see if tab is on multiple of 8
		   and   #$07		   ; mask remainder of cursor/8
               bne   tabkey		   ; not done, add another space
		   bra   InputWait	   ; done. 
InputSave      CMP   #$61              ;   ucase
               BCC   InputSave1        ;
               SBC   #$20              ;
InputSave1     INY                     ;
               BMI   InputTooLong      ; get next char (up to 127)
               STA   buffer,y          ;
               JSR   Output            ; OutputCharacter
               BRA   InputWait         ;
InputDone      INY                     ;
InputTooLong   LDA   #$0d              ; force CR at end of 128 characters 
               sta   buffer,y          ;
               JSR   Output            ;
;               lda   #$0a              ; lf Char   
;               JSR   Output            ;
               RTS                     ;
;
Input_chr      jmp   (ChrInVect)       ;
Scan_input     jmp   (ScanInVect)      ; 
Output         jmp   (ChrOutVect)      ;
;
Bell           LDA  #$07               ; Ctrl G Bell
               jmp  Output             ; 
;
Delay          PHA                     ; use A to execute a delay loop
delay1         DEC                     ;
               BNE   delay1            ;
               PLA                     ;
               DEC                     ;
               BNE   Delay             ;
GRTS           RTS                     ;
;
;
BRKroutine     sta   ACC               ; save A    Monitor"s break handler
               stx   XREG              ; save X
               sty   YREG              ; save Y
               pla                     ; 
               sta   PREG              ; save P
               pla                     ; PCL
               plx                     ; PCH
               sec                     ;
               sbc   #$02              ;
               sta   PCL               ; backup to BRK cmd
               bcs   Brk2              ;
               dex                     ;
Brk2           stx   PCH               ; save PC
               TSX                     ; get stack pointer
               stx   SPTR              ; save stack pointer
               jsr   Bell              ; Beep speaker
               jsr   PrintReg          ; dump register contents 
               ldx   #$FF              ; 
               txs                     ; clear stack
               cli                     ; enable interrupts again
               ;jmp   Monitor           ; start the monitor

;
;-----------DATA TABLES ------------------------------------------------
;
Hexdigdata     .byte "0123456789ABCDEF";hex char table 
;    
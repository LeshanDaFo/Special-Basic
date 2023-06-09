; ###############################################################
; #                                                             #
; #  SPECIAL BASIC C64 SOURCE CODE                              #
; #  Version 1.0 (2023.05.28)                                   #
; #  Copyright (c) 2023 Claus Schlereth                         #
; #                                                             #
; #  This version of the source code is under MIT License       #
; #                                                             #
; #  This source code can be found at:                          #
; #  https://github.com/LeshanDaFo/Special-Basic                #
; #  This source code is bsed on the existing Disk images       #
; #  published by Markt & Technik in 1987, 64'er Extra Nr 7     #
; #  and 1993, in 64'er Sonderheft 87                           #
; #  the German computer magazine "64'er 88/04"                 #
; #                                                             #
; #  Special Basic was written by Michael Störch & Lars George  #
; #                                                             #
; ###############################################################

; History:
; V1.0 =   Initial version


; ----------------------------------------------
; - token definations --------------------------
; ----------------------------------------------


; ----------------------------------------------
; - char definations ---------------------------
; ----------------------------------------------


; ----------------------------------------------
; - used zero page addresses -------------------
; ----------------------------------------------
CBM_CHRGET      = $0073
CBM_CHRGOT      = $0079

CBM_LINNUM      = $14
CBM_TXTTAB      = $2B                   ; start of BASIC program text
CBM_VARTAB      = $2D
CBM_FRETOP      = $33                   ; top of string stack
CBM_FRESPC      = $35                   ; utility pointer for strings
CBM_MEMSIZ      = $37                   ; highest BASIC RAM address / bottom of string stack
CBM_TXTPTR      = $7A

CBM_COMMANDBUF	= $0200
CBM_KBDSCNVEC	= $028F

; ----------------------------------------------
; - vector table addresses ---------------------
; ----------------------------------------------


; ----------------------------------------------
; - system addresses ---------------------------
; ----------------------------------------------

CBM_REASON      = $A408                 ; check available memory, do out of memory error if no room
CBM_ERROR       = $A437                 ; Error handling
CBM_WARMSTART   = $A474                 ; basic warm start
CBM_LNKPRG      = $A533	                ; rechain basic program lines
CBM_INLIN       = $A560                 ; call for BASIC input and return
CBM_FNDLIN      = $A613                 ; find line in basic
CBM_CLR         = $A660                 ; basic command CLR
CBM_STXTPT      = $A68E                 ; set txtptr to beginning of program-1
CBM_NEWSTT      = $A7AE                 ; process next statement
CBM_BSTOP       = $A82C                 ; basic call check STP
CBM_GOTO        = $A8A0                 ; perform GOTO
CBM_DATA        = $A8F8                 ; perform DATA
CBM_ADCGTPT     = $A8FB                 ; add (y) to CHRGET pointer
CBM_LINGET      = $A96B                 ; get line number
CBM_STROUT      = $AB1E                 ; output a string
CBM_FRMNUM      = $AD8A                 ; evaluate expression and check type mismatch
CBM_FRMEV       = $AD9E                 ; evaluate expression
CBM_CHKCLS      = $AEF7                 ; check for a right paramthese
CBM_CHKOPN      = $AEFA                 ; scan for "(", else do syntax error then warm Start
CBM_CHKCOM      = $AEFD                 ; check comma
CBM_CHKCHAR     = $AEFF                 ; check for a specific value
CBM_SNERR       = $AF08                 ; handle syntax error
CBM_PTRGET      = $B08B                 ; GET PNTR TO VARIABLE INTO "VARPNT".
CBM_ERRFC       = $B248                 ; illegal quantity error
CBM_INTFAC      = $B391                 ; convert fixed integer AY to float FAC1
CBM_CHKDIR      = $B3A6                 ; check direct mode
CBM_STRSPA      = $B47D                 ; make string space A bytes long
CMD_PUTNEW      = $B4CA
CBM_FRESTR      = $B6A3                 ; evaluate string
CBM_GETBYT      = $B79E                 ; get byte parameter
CBM_GETNUM      = $B7EB                 ; get address and byte
CBM_COMBYT      = $B7F1                 ; get comma, check byte
CBM_GETADR      = $B7F7                 ; convert FAC_1 to integer in temporary integer
CBM_FADD        = $B867                 ; add (AY) to FAC1
CBM_FMULT       = $BA28                 ; do convert AY, FCA1*(AY)
CBM_FDIVT       = $BB12                 ;
CBM_MOVFM       = $BBA2                 ; unpack memory (AY) into FAC1
CBM_MOVMF       = $BBD4                 ; round FAC, and stor at (y,x)
CBM_MOVAF       = $BC0C                 ; round and copy FAC1 to FAC2
CBM_SIGN        = $BC2B                 ; GET SIGN INTO ACCX.
CBM_FLOATC      = $BC49                 ; FLOAT UNSIGNED VALUE IN FAC+1,2
CBM_INT         = $BCCC                 ; perform INT
CBM_INTOUT      = $BDCD                 ; Output Positive Integer in A/X
CBM_FOUT        = $BDDD                 ; Convert FAC#1 to ASCII String
CBM_EREXIT      = $E0F9                 ; Error exit
CBM_READY       = $E386                 ; BASIC Warmstart Vektor
CBM_INISTP      = $E39D                 ; initialize the stack pointer
CBM_INIT        = $E3BF                 ; initialize basic ram
CBM_IRQ         = $EA31                 ; handle IRQ
CBM_SHFLOG      = $EB48                 ; evaluate the SHIFT/CTRL/C= keys
CBM_CLSEI       = $F642                 ; close serial bus device   
CBM_RAMTAS      = $FD50                 ; RAM test and find RAM end
CBM_IOINIT      = $FDA3                 ; initialize IO devices
CBM_CINT        = $FF5B                 ; init VIC and screen editor
CBM_SECND       = $FF93                 ; send SA after LISTEN
CBM_TKSA        = $FF96                 ; Set secondary address
CBM_IECIN       = $FFA5                 ; Read byte from IEC bus
CBM_CIOUT       = $FFA8                 ; handshake IEEE byte out
CBM_UNTALK      = $FFAB                 ; send UNTALK out IEEE
CBM_UNLSN       = $FFAE                 ; send UNLISTEN out IEEE
CBM_LISTN       = $FFB1                 ; send LISTEN out IEEE
CBM_TALK        = $FFB4                 ; send TALK out IEEE
CBM_READST      = $FFB7                 ; read I/O STAtus word
CBM_SETLFS      = $FFBA                 ; set file parameters
CBM_SETNAM      = $FFBD                 ; Set file name
CBM_OPEN        = $FFC0                 ; OPEN Vector
CBM_CLOSE       = $FFC3                 ; CLOSE Vector
CBM_CHKIN       = $FFC6                 ; Set input file
CBM_CHKOUT      = $FFC9                 ; Set Output
CBM_CLRCHN      = $FFCC                 ; Restore I/O Vector
CBM_CHRIN       = $FFCF                 ; Input Vector
CBM_CHROUT      = $FFD2                 ; Output Vector
CBM_LOAD        = $FFD5                 ; Load into memory
CBM_SAVE        = $FFD8                 ; 
CBM_STOP        = $FFE1                 ; Test STOP Vector

MODULSTART      = $8000

; Addresses at CAxx used by SPECIAL BASIC
; $CA00         =       FLASH mode $00 = OFF, $01 = ON
; $CA01         =       FLASH color
; $CA02         =       FLASH frequency
; $CA03         =       FLASH IRQ counter
; $CA04         =       VARY mode, $00 = OFF, >$00 = ON
; $CA05         =       VARY value 2
; $CA06         =       VARY value 1
; $CA07         =       VARY frequency
; $CA08         =       VARY IRQ counter
; $CA09         =       HIRES / HICOL, pf,hf
; $CA0A - $CA0C =       CREATE / CHAR, 
; $CA0D         =       AUTO flag, $00 = OFF, $01 = ON
; #CA0E         =       STRACE mode, see command
; $CA0F         =       TRACE value, see command
; $CA13 - $CA14 =       ON ERROR line address
; $CA15         =       ERRN code number
; $CA16 - $CA17 =       ERRLN line number
; $CA18 - $CA19 =       CONT memory pointer
; $CA1A         =       RESUME flag, $00 = ON
; $CA1B         =       $80 = inverted output. $40 = ???, $01 = ???
; $CA1C         =       temp stack pointer
; $CA1D - $CA1E =       FIX / VARY memory address
; $CA1F         =       BREAK flag
; $CA20         =       ON ERROR flag, $00 = OFF, $FF = ON
; $CA21         =       PAGE mode
; $CA22         =       DELAY value
; $CA23 - $CA25 =       used for sprite handling
; $CA26 - #CA27 =       MONITOR start address
; $CA28 - $CA29 =       GLOBAL / LOCAL 
; $CA35 - $CA5D =       EXEC/END PROC STACK TABLE
; $CA5E - $CAAE =       REPAET/UNTIL STACK TABLE
; $CAAF - $CAFF =       LOOP/ENDLOOP STACK TABLE


SB = 87

!to"build/specialbasic.prg",cbm

; ----------------------------------------------
; - the basic loader ---------------------------
; ----------------------------------------------
;
*=$0801
; basic part
        !by $29,$08,$00,$00,$9E,$20,$32,$30
        !by $39,$31,$20,$20,$28,$43,$29,$20
        !by $31,$39,$39,$33,$20,$42,$59,$20
        !by $4d,$41,$52,$4b,$54,$20,$26,$20
        !by $54,$45,$43,$48,$4e,$49,$4b,$00
        !by $00,$00
; ----------------------------------------------
; copy special basic prg to $8000-$BFFF
        LDY #<ENTRY
        LDX #>ENTRY
        STY $FB
        STX $FC
        LDY #$00
        LDX #>MODULSTART
        STY $FD
        STX $FE
        LDX #$40
-       lda ($FB),y
        STA ($FD),y
        INY
        BNE -
        INC $FC
        INC $FE
        DEX
        BNE -
; ----------------------------------------------
; Initialize the funktion key commands
        TXA
        TAY
        CLC
--      PHA
        TAX
-       LDA F_KEYS,y
        PHP
        AND #$7F
        STA $CB00,x
        INX
        INY
        PLP
        BPL -
        LDA #$5F
        STA $CB00,X
        PLA
        ADC #$20
        BCC --
; ----------------------------------------------
; clear some areas
        TAX
        LDA #$20
-       STA $CC00,x
        STA $CD00,x
        STA $CE00,x
        STA $CF00,x
        STA $F000,x
        STA $F100,x
        STA $F200,x
        STA $F300,x
        INX
        BNE -
; ----------------------------------------------
; Initialize the vector bytes

;    $CA1D/$CA1E FIX / VARY
;    $CA26/$CA27 SET / MONITOR
;    $CA28/$CA29 GLOBAL / LOCAL

        LDX #$D0
        STA $CA1D
        STX $CA1E
        LDA #<L804D                     ; points at the beginning
        LDX #>L804D                     ; to a "RTS"
        STA $CA26
        STX $CA27
        LDA #$00
        LDX #$D8
        STA $CA28
        STX $CA29

; start modul over reset
        JMP $FCE2

; ----------------------------------------------
F_KEYS:
        !pet "commandS" ; F1
        !pet "shoW"     ; F2
        !pet "ruN"      ; F3
        !pet "chaiN"    ; F4
        !pet "lisT"     ; F5
        !pet "memorY"   ; F6
        !pet "helP"     ; F7
        !pet "diR"      ; F8
; ----------------------------------------------

ENTRY
!pseudopc MODULSTART {

; ----------------------------------------------
; - Special Basic Start ------------------------
; ----------------------------------------------

        !word .reset                    ; at $8000 RESET-Vector 
        !word .nmi                      ; at $8002 NMI-Vector   
        !pet "CBM80"                    ; at $8004 CBM80
        
OWN_VECTAB   
        !word OWN_ERRMSG                ; $0300/01 Vector: Print BASIC Error Message
        !word OWN_BWSTART               ; $0302/03 Vector: BASIC Warm Start
        !word OWN_CRUNCH                ; $0304/05 Vector: Tokenize BASIC Text 
        !word OWN_PLOP                  ; $0306/07 Vector: BASIC Text LIST
        !word OWN_GONE                  ; $0308/09 Vector: BASIC Char. Dispatch  
        !word OWN_EVAL                  ; $030A/0B Vector: BASIC Token Evaluation 
; ----------------------------------------------
L8015   LDY #$20
-       LDA $FD2F,y
        STA $0313,y
        DEY
        BNE -
        STY $CA00
        STY $CA04
        STY $07EE
        STY $CA1B                       ; $00
        STY $CA0D                       ; $00 = AUTO OFF
        LDA #<OWN_STOPVEC
        LDX #>OWN_STOPVEC
        STA $0328
        STX $0329
        LDA #<OWN_IRQ
        LDX #>OWN_IRQ
        STA $0314
        STX $0315
        LDA #<OWN_NMIVEC
        LDX #>OWN_NMIVEC
        STA $0318
        STX $0319
; ----------------------------------------------
; - $804D BEGIN , BEND -------------------------
; ----------------------------------------------
L804D
CMD_BEGIN
CMD_BEND
        RTS
---------------------------------
.reset
        JSR CBM_IOINIT                  ; $FDA3, initilize IO devices
        JSR CBM_RAMTAS                  ; $FD50, RAM test and find RAM end
        JSR L8015                       ; prepare some memory vectors
        JSR CBM_CINT                    ; $FD5B, init VIC and screen editor
        JSR CBM_INIT                    ; $E3BF, initialize basic ram
        LDA #$00
        STA CBM_FRETOP                  ; top of string stack
        STA CBM_MEMSIZ
        LDA #$80
        STA CBM_FRETOP+1                ; highest BASIC RAM address / bottom of string stack
        STA CBM_MEMSIZ+1
        LDA CBM_TXTTAB                  ; start of BASIC program text
        LDY CBM_TXTTAB+1
        JSR CBM_REASON                  ; $A408, check memory space
        LDA #<OWN_STARTMSG              ; pointer to start message
        LDY #>OWN_STARTMSG
        JSR CBM_STROUT                  ; print message
        JSR $E430                       ; go, initialise memory pointers
        LDA #$06
        STA $D020                       ; background color
        LDX #$0F
        STX $D021                       ; foreground color
-       LDA OWN_VECTAB-4,X              ; load own vector addresses
        STA $0300-4,X                   ; store it
        DEX                             ;
        BPL -                           ; loop
        INX                             ; #$00
        STX $CA1F                       ; this command is handled in next step again                       
        JSR L899E
        LDA #<OWN_NMIJMP
        LDX #>OWN_NMIJMP
        STA $FFFA
        STX $FFFB
        CLI
        JMP CBM_INISTP
---------------------------------
L80A2   SEI
        LDA #<OWN_KBDDEC
        LDX #>OWN_KBDDEC
        STA CBM_KBDSCNVEC
        STX CBM_KBDSCNVEC+1
        RTS
---------------------------------
OWN_NMIJMP
L80AE   SEI
; ----------------------------------------------
; - $80AF new NMI vector ($0318) ---------------
; ----------------------------------------------
OWN_NMIVEC
        PHA
        TXA
        PHA
        TYA
        PHA
.nmi
        LDA $01
        PHA
        ORA #$02
        STA $01
        LDA #$7F
        STA $DD0D
        LDY $DD0D
        BMI L80F5
        JSR $F6BC
        JSR CBM_STOP                    ; Test STOP Vector
        BNE L80F5
        JSR L8015
        JSR CBM_IOINIT                  ; $FDA3, initilize IO devices
        JSR $E518
        LDA #$04
        STA $0288
        LDA #$93
        JSR CBM_CHROUT
        JSR L80A2
        LDA #$06
        STA $D020                       ; background color
        LDA #$0F
        STA $D021                       ; foreground color
        LDA #$00
        STA $0286                       ; text color
        JMP $E37B
---------------------------------
L80F5   TYA
        PHA
        TSX
        LDY #$05
-       LDA L8110,Y 
        STA $0100,X 
        DEX
        DEY
        BPL -
        PLA
        TXS
        JMP $FE73
---------------------------------
L8109   PLA
        PLA
        STA $01
        PLA
        TAY
        PLA
---------------------------------
L8110   TAX
        PLA
        RTI
        !by $34
        !word L8109
; ----------------------------------------------
; - $8116 new IRQ vector ($0314) ---------------
; ----------------------------------------------
OWN_IRQ
        LDA $D019
        STA $D019
        BPL L8147
        LDA $D012
        CMP $07F6
        BEQ L813E
        LDA #$94
        LDX #$3B
        LDY #$39
        STA $DD00
        STX $D011
        STY $D018
        LDA $07F6
L8138   STA $D012
        JMP $EA81
L813E   JSR CMD_NRM
        LDA $07F5
        JMP L8138
---------------------------------
L8147   LDA $DC0D
        CLI
        LDA $FB
        PHA
        LDA $FC
        PHA
        LDA $FD
        PHA
        LDA $FE
        PHA
        LDY $CA00
        BEQ L8195
        DEC $CA03
        BNE L8195
        LDA $CA02
        STA $CA03
        DEY
        STY $FB
        STY $FD
        LDX $0288
        STX $FC
        LDX #$D8
        STX $FE
        LDX #$03
L8177   BNE L817B
        LDY #$E8
L817B   DEY
        LDA ($FD),Y
        AND #$0F
        CMP $CA01
        BNE L818B
        LDA ($FB),Y
        EOR #$80
        STA ($FB),Y
L818B   TYA
        BNE L817B
        INC $FC
        INC $FE
        DEX
        BPL L8177
L8195   LDA $CA04
        BEQ L81BC
        DEC $CA08
        BNE L81BC
        LDX $CA07
        STX $CA08
        EOR #$01
        STA $CA04
        TAX
        LDA $CA03,X 
        LDX $CA1D
        LDY $CA1E
        STX $FB
        STY $FC
        LDY #$00
        STA ($FB),Y
L81BC   LDA $07EE
        BNE L81C4
L81C1   JMP L827C
---------------------------------
L81C4   DEC $07EC
        BNE L81C1
        LDA $07ED
        STA $07EC
        DEC $07EA
        BNE L81C1
        LDA $07EB
        STA $07EA
        LDA $07F1
        LDX $07F2
        LDY $07F4
        STA $FB
        STX $FC
        LDA ($FB),Y
        CMP #$3A
        BCS L81F1
        CMP #$30
        BCS L8215
L81F1   CMP #$2A
        BNE L8225
        INY
        LDA ($FB),Y
        CMP #$31
        BCC L8209
        CMP #$34
        BCS L8209
        TAX
        LDA L825B-1,X 
        STA $07EF
        BCC L8222
L8209   CMP #$4E
        BNE L821F
        LDY #$FF
        LDA #$01
        STA $07EA
        !by $2c
L8215   SBC #$2F
        STA $07EC
        STA $07ED
        BCS L826E
L821F   JSR L82A3
L8222   JMP L826E
---------------------------------
L8225   LDX #$06
L8227   CMP L828E,X 
        BEQ L8231
        DEX
        BPL L8227
        BMI L826E
L8231   LDA #$01
        STA $FD
        CPX #$06
        BNE L823B
        INC $FD
L823B   TXA
        ASL
        TAX
        INY
        LDA ($FB),Y
        CMP #$23
        BNE L8247
        INY
        INX
L8247   LDA L8295,X 
        PHA
        LDA ($FB),Y
        SEC
        SBC #$2F
        TAX
        PLA
L8252   DEX
        BEQ L825B
        ASL
        ROL $FD
        JMP L8252
---------------------------------
L825B   LDX $07EF
        STA $D400,X 
        LDA $FD
        STA $D401,X 
        JSR L82A6
        ORA #$01
        STA $D404,X 
L826E   INY
        STY $07F4
        CPY $07F3
        BCC L827C
        LDA #$00
        STA $07EE
L827C   PLA
        STA $FE
        PLA
        STA $FD
        PLA
        STA $FC
        PLA
        STA $FB
        JMP CBM_IRQ

---------------------------------
; used in sound commands
VOICES  !by $00,$07,$0E                         ; $D4xx

L828E   !by $43,$44,$45,$46,$47,$41,$48         ; "CDEFGAH"
L8295   !by $12,$23,$34,$46,$5A,$5A,$6E,$84     ; .#4FZZ..
        !by $9B,$B3,$CD,$E9                     ; ....
---------------------------------

        ASL $06
L82A3   LDX $07EF
L82A6   LDA $07E9,X 
        AND #$FE
        STA $D404,X 
        RTS
; ----------------------------------------------
; - $82AF own keyboard decoding routine --------
; ----------------------------------------------
; check for function keys
OWN_KBDDEC
        LDX $3A                         ; check direct mode
        INX
        BNE L82C4                       ; branch if not direct mode
        LDA $D4                         ; check quote mode
        BNE L82C4                       ; branch if quote mode
        LDA $CB                         ; get actual key pressed
        LDX #$03
-       CMP F_KEYCODES,X                ; function key codes, F1/F2,F3/F4,F5/F6,F7/F8
        BEQ +
        DEX
        BPL -
L82C4   JMP CBM_SHFLOG
---------------------------------
; handle function keys
+       CMP $C5                         ; compare for repeatly pressed key
        BEQ L82C4                       ; branch if so
        STA $C5                         ; else store as pressed key
        TXA                             ; F-key counter to accu
        ASL                             ; multiply with 2
        LDX $028D                       ; check for shift pressed
        DEX
        BNE +                           ; branch if not shift pressed
        ADC #$01                        ; else add 1 to accu
+       ASL                             ;
        ASL                             ;
        ASL                             ; multiply with 16, ($10)
        ASL                             ;
        ASL                             ;
        TAX                             ; $00,$20,$40,$60,$80,$A0,$C0,$E0
-       LDA $CB00,X                     ; load f-key char 
        BEQ ++                          ; branch if no more
        CMP #$5F                        ; $5f is for "RETURN" and also last char
        BEQ +                           ; branch if return
        JSR CBM_CHROUT                  ; else output char to screen
        INX                             ; increase cuonter
        BNE -                           ; "JMP" normaly will not reach 0
+       LDA #$0D                        ; load "return"                        
        STA $0277                       ; store to key buffer
        LDA #$01                        ; key count
        STA $C6                         ; store it as one key prssed
++      LDA #$00                        ; clear cursor
        STA $CF
        JMP CBM_SHFLOG                  ; finished, a f-key was pressed, and will be executed
---------------------------------
F_KEYCODES
        !by $04,$05,$06,$03
; ----------------------------------------------
; - $8300 Stop vector --------------------------
; ----------------------------------------------
OWN_STOPVEC
        JSR $F6ED                       ; test stop key
        BNE L830D                       ; branch if not pressed
        LDA $CA1F                       ; else load BREAK flag
        BNE L830D                       ; branch RTS if not zero
        STA $CA1B                       ; else store zero to '$CA1B'
L830D   RTS
---------------------------------
L830E   TYA
        BNE L8314
        JMP CBM_WARMSTART
---------------------------------
L8314   CMP #$40
        BEQ L830D
        JMP CBM_NEWSTT
; ----------------------------------------------
; - $831B Own Error message vector -------------
; ----------------------------------------------

OWN_ERRMSG
        LDA #$00
        LDY $CA1B                       ; load Y with value from "$CA1B"
        STA $CA1B                       ; clear '$CA1B'
        TXA                             ; error code in X
        BMI L830E                       ; no error, do 'ready.'
        LDY $3A                         ; basic line high byte/ direct mode
        INY
        BEQ L8343                       ; branch if direct mode
        LDX $39                         ; basic line low byte
        DEY                             ; basic line high byte was increased before
        STX $CA16                       ; store basic line low byte
        STY $CA17                       ; store basic line high byte
        LDX $3D                         ; low byte cont pointer
        LDY $3E                         ; high byte cont pointer
L8338   STX $CA18                       ; store cont pointer low byte
        STY $CA19                       ; store cont pointer high byte
        LDX #$00
        STX $CA1A                       ; set RESUME flag = ON
L8343   STA $CA15                       ; error code number
        LDY $CA20                       ; ON ERROR flag
        BNE L835F                       ; branch if set
        ASL                             ; multiply with 2
        TAX                             ; transfer to X
        CPX #$3D                        ; compare if it is a new error mssage
        BCS L8354                       ; branch if new (>=$3D)
        JMP $A43D                       ; else do old error message output
---------------------------------
L8354   LDA L8376-$3D-1,X               ; load error text addr low byte
        STA $22                         ; store it to $22
        LDA L8376-$3D,X                 ; load error text addr high byte
        JMP $A445                       ; output error message
---------------------------------
L835F   LDY $CA14                       ; ON ERROR line address high byte
        LDX $CA13                       ; ON ERROR line address low byte
        BNE L8368
        DEY                             ; dec address by 1        
L8368   DEX                             ;
        STX CBM_TXTPTR                  ; store address low byte
        STY CBM_TXTPTR+1                ; store address high byte
        LDX $CA1C                       ; holds stack pointer
        TXS
        LDA #$00
        JMP CBM_NEWSTT                  ; continue on the defined error line
---------------------------------

L8376   !word ERR31
        !word ERR32
        !word ERR33
        !word ERR34
        !word ERR35
        !word ERR36
        !word ERR37
        !word ERR38
        !word ERR39
        !word ERR40
        !word ERR41
        !word ERR42                     ; $9ef9

ERR31   !pet "until without repeaT"
ERR32   !pet "end loop without looP"
ERR33   !pet "missing end looP"
ERR34   !pet "missing benD"
ERR35   !pet "proc not founD"
ERR36   !pet "end proc without exeC"
ERR37   !pet "can't resumE"
ERR38   !pet "out of rangE"
ERR39   !pet "illegal string lengtH"
ERR40   !pet "wrong strinG"
ERR41   !pet "missing endcasE"

; ----------------------------------------------
; - $843E Own basic warm start vector ----------
; ----------------------------------------------
OWN_BWSTART
        LDX #$00                        
        STX $CA20                       ; clear 'ON ERROR' flag
        DEX                             ; $FF
        STX $3A                         ; set direct mode
        LDA $D011                       ; check BITMAP mode
        AND #$20
        BEQ +                           ; branch if TEXT mode
        JSR CMD_NRM                     ; else initialize screen
+       LDA $CA0D                       ; check for AUTO mode
        BEQ L847A                       ; branch if OFF
; handling AUTO mode
        LDA $F7                         ; load AUTO start line low byte
        LDX $F8                         ; load AUTO start line high byte
        STA $63                         ; store low byte
        STX $62                         ; store high byte
        LDX #$90                        ;
        SEC
        JSR CBM_FLOATC                  ; FLOAT UNSIGNED VALUE IN FAC+1,2
        JSR $BDDF                       ; onvert FAC1 to string, and output to screen
        LDX #$01
-       LDA $00FF,X                     ; get char from input buffer
        BEQ +                           ; branch if it is nothing (more)
        STA $0276,X                     ; else store to key buffer
        INX                             ;
        BNE -                           ; next
+       LDA #$20                        ; space
        STA $0276,X                     ; store to key buffer
        STX $C6                         ; set X as char amount
L847A   JSR CBM_INLIN                   ; call for BASIC input
        STX CBM_TXTPTR                  ; save BASIC execute pointer low byte
        STY CBM_TXTPTR+1                ; save BASIC execute pointer high byte
        JSR CBM_CHRGET                  ; increase and scan memory
        TAX                             ; copy byte to set flags
        BNE +                           ; branch if there was an input
        STA $CA0D                       ; else delete AUTO flag
        BEQ L847A                       ; (jmp) lopp if no input
+       BCC +                           ; branch if found a number
        LDX #$00                        ;
        STX $CA0D                       ; switch off AUTO mode
        JMP $A496                       ; go to ROM and handle basic line
---------------------------------
+       JSR CBM_LINGET                  ; get line number into $14/$15
        CLC                             ;
        LDA $14                         ; load low byte
        ADC $F9                         ; add AUTO step low byte
        STA $F7                         ; store as new AUTO line low byte
        LDA $15                         ; load high byte
        ADC $FA                         ; add AUTO step high byte +carry
        STA $F8                         ; store as new AUTO line high byte
        LDX CBM_TXTPTR                  ; load text pointer
        LDA CBM_COMMANDBUF,X                     ; load next char
        BNE L84B0                       ; branch if not zero
        STA $CA0D                       ; else switch off AUTO mode
L84B0   JMP $A49F                       ; go to ROM to finish the input
; ----------------------------------------------
; - $84B3 NRM ----------------------------------
; ----------------------------------------------
CMD_NRM
        LDA #$1B
        STA $D011                       ; switch on screen
L84B8   LDA #$97
        STA $DD00                       ; restore video address
        LDA #$15
        STA $D018                       ; restore charset
        LDA #$04
        STA $0288                       ; screen start to $0400
        RTS
; ----------------------------------------------
; - $84C8 Own crunch vector --------------------
; ----------------------------------------------
OWN_CRUNCH
        LDX CBM_TXTPTR                  ; save TXTPTR
        LDY CBM_TXTPTR+1                ;
        LDA #<CBM_COMMANDBUF            ; set TXTPTR temporarily 
        STA CBM_TXTPTR                  ; to $0200
        LDA #>CBM_COMMANDBUF            ; $02
        STA CBM_TXTPTR+1                ; System/Basic input buffer
        JSR CBM_CHRGOT                  ; get first char from line input
        BCS +                           ; branch if it was a number
        STA $CA1A                       ; else store #$02 to RESUME flag
+       STX CBM_TXTPTR                  ; restore TXTPTR
        STY CBM_TXTPTR+1                ;

L84E0   JSR ROM_OFF                     ;
        LDX #$FF                        ; index pointer
--      INX                             ; increment read index
        LDA CBM_COMMANDBUF,X            ; get a byte from input buffer
        BEQ +++                         ; go back to ROM

; if found a quote, then skipp until next quote, or basic line end
        CMP #$22                        ; compare with quote character
        BNE +                           ; not a quote
-       INX                             ; else increment read index
        LDA CBM_COMMANDBUF,X            ; get a byte from input buffer
        BEQ +++                         ; no more input, go back to ROM
        CMP #$22                        ; else compare with second quote
        BNE -                           ; not found, search until end of input
        BEQ --                          ; (jmp) qutes are skipped, go get next char

+       CMP #$41                        ; check for possible command chars ???
        BCC --                          ; below #$41, go back to ROM
        CMP #$60                        ;
        BCS --                          ; above #$5F, go back to ROM
        STX $22                         ; store act. read index (where we have found a possible command)

; A problem occurs in the next part when the CMDS table starts at an address like $A000
; in this case, the Y register is loaded with #$FF and stored in $FB
; the accu is loaded with #$A0 and stored in $FC
; later, $FC is increased to #$00
; then the BNE command to skip increasing $FC will not work
; therefore, $FC is increased to #$A1 and ($FB) now contains the address $A100
; Result:
; The command tab must start at $X001 or higher.
; however, the number of commands must also be taken into account so that the "page" is not left too early

        LDY #<CMDS-1                    ; #$01
        STY $FB
        STY $23                         ; command counter
        DEY
        LDA #>CMDS                      ; #$A0
        STA $FC
        DEX                             ; input buffer index pointer
-       INX
        INC $FB 
        BNE L8518
        INC $FC 
; compare command buffer char with command table
L8518   LDA CBM_COMMANDBUF,X 
        SEC
        SBC ($FB),Y
        BEQ -                           ; branch if equal 
        CMP #$80                        ; else compare with shifted char (last command char)
        BEQ ++                          ; branch if we found a command
; if a command was not found
        LDX $22                         ; input buffer index pointer (command start)
        INC $23                         ; command counter

-       LDA ($FB),Y                     ; load char from CMDS table
        PHA                             ; save it
        INC $FB                         ;
        BNE +                           ;
        INC $FC                         ;
+       PLA                             ; get back saved char
        BEQ --                          ; if it was zero, loop check next char from input buffer
        BPL -                           ; branch if it was not the last char of a command
        BMI L8518                       ; it was the last char, go compare with next command from table
; a command was found
++      STX $24                         ; save pointer (last command char) 
        LDY $22                         ; input buffer index pointer (command start in basic line)
        LDX #$63                        ; new command start token #$63
        LDA $23                         ; command counter value
        BPL +                           ; first page commands
        INX                             ; else inrease new command start token to #$64
        SBC #$7F                        ; substract #$7F, to start from #01
+       STA CBM_COMMANDBUF+1,Y          ; store command token
        TXA
        STA CBM_COMMANDBUF,Y            ; store command start token
        LDX $24                         ; pointer to last found command char from input buffer  
-       INY                             ; act possition in basic input line +1
        INX                             ; point to next input possition (after last found command)
        LDA CBM_COMMANDBUF,X            ; move rest of line
        STA CBM_COMMANDBUF+1,Y          ; to possition after double token
        BNE -                           ; loop until end of line
        LDX $22                         ; 
        INX                             ; increas search start possition
        BNE --                          ; branch if it is not the last char in the input buffer
+++     JSR ROM_ON                      ; else switch on ROM
        JMP $A57C                       ; go to ROM

; foolowing are some support routines, used in different commands
---------------------------------
; switch on ROM
ROM_ON   
        LDA $01
        ORA #$01
        STA $01
        RTS
---------------------------------
; switch on RAM
ROM_OFF   
        LDA $01
        AND #$FE
        STA $01
        RTS
---------------------------------
INCFB_FC
        INC $FB
        BNE +
        INC $FC
+       RTS
---------------------------------
L8578   LDY #$00
L857A   JSR INCFB_FC
        LDA ($FB),Y
        RTS
---------------------------------
INC7A_7B
        INC CBM_TXTPTR
        BNE +
        INC CBM_TXTPTR+1
+       RTS
---------------------------------
L8587   LDY #$00
L8589   JSR INC7A_7B
        LDA (CBM_TXTPTR),Y
        RTS
---------------------------------
L858F   JSR ROM_ON
        JSR CBM_COMBYT
        JMP ROM_OFF
---------------------------------
L8598   JSR ROM_ON
        JSR CBM_GETBYT
        JMP ROM_OFF
---------------------------------
L85A1   JSR ROM_ON
        JSR CBM_CHKCOM
        JMP ROM_OFF
---------------------------------
L85AA   JSR ROM_ON
        JSR CBM_FRMEV
        JSR CBM_FRESTR
        PHA
        JSR ROM_OFF
        PLA
        RTS
---------------------------------
L85B9   JSR ROM_ON
        JSR CBM_PTRGET
        PHA
        JSR ROM_OFF
        PLA
        RTS
---------------------------------
L85C5   PHA
        JSR ROM_ON
        PLA
        JSR CBM_STRSPA
        PHA
        JSR ROM_OFF
        PLA
        RTS
---------------------------------
L85D3   JSR ROM_ON
        JSR CBM_FRMNUM
        JSR CBM_GETADR
        PHA
        JSR ROM_OFF
        PLA
        RTS
---------------------------------
L85E2   PHA
        JSR ROM_ON
        PLA
        JSR CBM_INTOUT
        JMP ROM_OFF
---------------------------------
L85ED   JSR ROM_ON
L85F0   JSR $A3BF
L85F3   JMP ROM_OFF
---------------------------------

; ----------------------------------------------
; - $85F6 CHRLO --------------------------------
; ----------------------------------------------
CMD_CHRLO
        LDA #$0E
        !by $2c
; ----------------------------------------------
; - $85F9 CHRHI --------------------------------
; ----------------------------------------------
CMD_CHRHI
        LDA #$8E
        !by $2c
; ----------------------------------------------
; - $85FC CLS ----------------------------------
; ----------------------------------------------
CMD_CLS
        LDA #$93
        !by $2c
P_SPC   LDA #$20
        !by $2c
P_RET   LDA #$0D
        JMP CBM_CHROUT

; additional some support routines
---------------------------------
L8607   JSR ROM_ON
        JSR CBM_CHRGOT
        JSR CBM_LINGET
        JMP ROM_OFF
---------------------------------
L8613   JSR L861D                       ; find line
        BCS +                           ; ok
        LDX #$11                        ; else, UNDEF'D STATEMENT ERROR
        JMP PRINTERR
---------------------------------
L861D   JSR ROM_ON
        JSR CBM_FNDLIN
        PHP
        JSR ROM_OFF
        PLP
+       RTS
---------------------------------
; $8629 Print error , with No. in X
PRINTERR
        JSR ROM_ON
        JMP ($0300)
---------------------------------
; check for a specific value
L862F   PHA
        JSR ROM_ON
        PLA
        JSR CBM_CHKCHAR
        JMP ROM_OFF
---------------------------------
L863A   JSR ROM_ON
        JSR CBM_FOUT
        JMP ROM_OFF
---------------------------------
L8643   JSR ROM_ON
        JSR CBM_BSTOP
        JMP ROM_OFF
---------------------------------
L864C   JSR ROM_ON
        JSR CBM_STXTPT
        JMP ROM_OFF
---------------------------------
L8655   JSR ROM_ON
L8658   JSR CBM_ADCGTPT
        JMP ROM_OFF
---------------------------------
L865E   JSR ROM_ON
        JSR $A9B1
        JMP ROM_OFF
---------------------------------
L8667   JSR ROM_ON
        JSR $AA9D
        JMP ROM_OFF
---------------------------------
L8670   LDX #$17                        ; STRING TO LONG
        JMP PRINTERR
---------------------------------
L8675   JSR ROM_ON
        JSR CBM_FRMNUM
        JMP ROM_OFF
---------------------------------
L867E   LDX #$0E                        ; ILLEGAL QUANTITY
        JMP PRINTERR
---------------------------------
; get address, and byte
L8683   JSR ROM_ON
        JSR CBM_GETNUM
        JSR ROM_OFF
        LDY $14
        LDA $15
        RTS
---------------------------------
; switch on kernel
L8691   LDA $01
        EOR #$03
L8695   STA $01
        CLI
        RTS
---------------------------------
; switch off kernal
L8699   SEI
        LDA $01
        EOR #$03
        STA $01
        RTS
---------------------------------
L86A1   LDA CBM_TXTPTR
        BNE +
        DEC CBM_TXTPTR+1
+       DEC CBM_TXTPTR
        RTS
---------------------------------
L86AA   SEI
        LDA $01
        EOR #$07
        STA $01
        RTS
---------------------------------
L86B2   LDA $01
        EOR #$07
        STA $01
        CLI
-       RTS
---------------------------------
L86BA   JSR L85A1                       ; CBM_CHKCOM
L86BD   JSR L8598                       ; CBM_GETBYT
        CPX #$10
        BCC -
--      JMP L867E                       ; ILLEGAL QUANTITY
---------------------------------
; checks for input between $01 and $08
; sets the bits 0 to 7 accordingly, and store it to $02
L86C7   JSR L8598                       ; CBM_GETBYT
        TXA                             ; transfer byte to accu
        BEQ --                          ; error if 0
        CMP #$09                        ; compare with 9
        BCS --                          ; error if equal or higher
        TAY                             ; transfer to Y
        LDA #$01                        ; load accu with 1
-       ASL                             ; multiply with 2
        DEX                             ; decrease x
        BNE -                           ; loop multiply
        ROR                             ; shift to the right
        STA $02                         ; store value into $02
        RTS
---------------------------------
; define voice No. according to the input
L86DC   JSR L8598                       ; CBM_GETBYT
        DEX
        CPX #$03                        ; compare with 3
        BCS --                          ; error if equal or higher
        LDY VOICES,X                    ; $00,$07,$0e, voice low byte
        LDX #$D4                        ; voice high byte
        STY $14
        STX $15
        RTS
---------------------------------
L86EE   JSR L85A1                       ; CBM_CHKCOM
L86F1   JSR L8598                       ; CBM_GETBYT
        INX                             ; increase
-       RTS
; ----------------------------------------------
; - $86f6 own plop vector ----------------------
; ----------------------------------------------
; BASIC-Text auflisten / Umwandlung Token in BASIC-Text 
OWN_PLOP
        STA $02                         ; save act. char
        BIT $CA1B                       ; check for reverse ON/OFF
        BPL L8718                       ; branch if OFF, bit 7 was clear
        CMP #$3A                        ; else compare wth ':'
        BNE +                           ; branch if not
; Quotation mode switch during tokenization; Bit #6: 0 = Normal mode; 1 = Quotation mode.
; Quotation mode switch during LIST; $01 = Normal mode; $FE = Quotation mode.
        LDA $0F                         ; else check quotation mode
        BMI +                           ; branch on quote mode
        LDA #$92                        ; else switch reverse off
        JSR CBM_CHROUT                  ;
+       TYA                             ; index for line to accu
L870B   CLC
L870C   ADC $5F                         ; act. line low byte ???
L870E   CMP $F7                         ; ???
L8710   BNE L8722                       ; ???
L8712   LDA #$12                        ; switch reverse on
L8714   JSR CBM_CHROUT
L8717   CLV

L8718   BVC L8722                       ; branch if bit 6 at address $CA1A is clear
L871A   CMP #$3A
L871C   BNE L8722
L871E   LDA $0F                         ; check quotation mode
L8720   BPL -                           ; branch if not set

L8722   LDX $CA1B                       ; 
L8725   DEX
L8726   BNE L8744
L8728   LDA $CA21                       ; PAGE mode
L872B   BEQ L8744
L872D   CPY #$04
L872F   BNE L8744
L8731   CMP $D6
L8733   BCS L8744
L8735   JSR $F13E
L8738   TAX
L8739   BEQ L8735
L873B   JSR CBM_BSTOP
L873E   JSR CMD_CLS
L8741   JMP $A6C9
---------------------------------
L8744   LDX $028D
L8747   CPX #$01
L8749   BEQ L8744
L874B   CPX #$02
L874D   BNE L875D
L874F   LDX #$00
L8751   STX $FE
L8753   LDX $CA22                       ; DELAY value
L8756   DEC $FE
L8758   BNE L8756
L875A   DEX
L875B   BNE L8756
L875D   LDA $02
L875F   CMP #$63
L8761   BEQ L876D
L8763   LDX #$24
L8765   CMP #$64
L8767   BEQ L8772
L8769   TAX
L876A   JMP $A71A
---------------------------------
L876D   LDX #$01
L876F   LDA #$A0
L8771   !by $2c
L8772   LDA #$A2
L8774   STX $FB
L8776   STA $FC
L8778   JSR ROM_OFF
L877B   INY
L877C   STY $49
L877E   LDA ($5F),Y
L8780   TAX
L8781   LDY #$00
L8783   DEX
L8784   BEQ L878D
L8786   JSR L857A
L8789   BPL L8786
L878B   BMI L8783
L878D   INY
L878E   LDA ($FB),Y
L8790   BMI L8798
L8792   JSR CBM_CHROUT
L8795   JMP L878D
---------------------------------
L8798   TAX
L8799   JSR ROM_ON
L879C   TXA
L879D   JMP $A6EF
---------------------------------
L87A0   STA $63
L87A2   STX $62
L87A4   LDA #$13
L87A6   JSR CBM_CHROUT
L87A9   LDX #$90
L87AB   SEC
L87AC   JSR CBM_FLOATC
L87AF   JSR $BDDF
L87B2   LDX #$00
L87B4   INX
L87B5   LDA $0100,X 
L87B8   BNE L87B4
L87BA   JSR P_SPC
L87BD   INX
L87BE   CPX #$06
L87C0   BNE L87BA
L87C2   LDA #$00
L87C4   LDY #$01
L87C6   JMP CBM_STROUT
; ----------------------------------------------
; - $87C9 Own gone vector ----------------------
; ----------------------------------------------
OWN_GONE
        JSR CBM_CHRGET
L87CC   BEQ L8801
L87CE   LDY $CA0E                       ; STRACE mode
L87D1   BEQ L8801
L87D3   LDX $3A
L87D5   INX
L87D6   BEQ L8801
L87D8   DEY
L87D9   BEQ L8804
L87DB   LDA $D3
L87DD   PHA
L87DE   LDA $D6
L87E0   PHA
L87E1   LDA $39
L87E3   DEX
L87E4   JSR L87A0
L87E7   LDX $CA0F                       ; TRACE value
L87EA   LDY #$00
L87EC   DEY
L87ED   BNE L87EC
L87EF   DEX
L87F0   BNE L87EC
L87F2   PLA
L87F3   STA $D6
L87F5   PLA
L87F6   CMP #$28
L87F8   BCC L87FC
L87FA   SBC #$28
L87FC   STA $D3
L87FE   JSR $E56C
L8801   JMP L8896
---------------------------------
L8804   LDA $CB
L8806   CMP #$0D
L8808   BEQ L8810
L880A   CMP #$27
L880C   BNE L8813
L880E   LDA #$00
L8810   STA $CA0F                       ; TRACE value
L8813   LDA $CA0F                       ; TRACE value
L8816   BEQ L8801
L8818   LDA $D3
L881A   PHA
L881B   LDA $D6
L881D   PHA
L881E   LDA $39
L8820   LDX $3A
L8822   STA $FC
L8824   STA $14
L8826   STX $FB
L8828   STX $15
L882A   JSR L87A0
L882D   LDX #$05
L882F   LDA $0288
L8832   STX $FD
L8834   STA $FE
L8836   LDA #$20
L8838   LDY #$4A
L883A   STA ($FD),Y
L883C   DEY
L883D   BNE L883A
L883F   INY
L8840   LDA (CBM_TXTPTR),Y
L8842   BNE L883F
L8844   TYA
L8845   SEC
L8846   ADC CBM_TXTPTR
L8848   STA $FE
L884A   LDA CBM_TXTPTR+1
L884C   ADC #$00
L884E   STA $FD
L8850   DEC CBM_TXTPTR+1
L8852   LDY #$FC
L8854   !by $2c
L8855   LDY $02
L8857   DEY
L8858   LDA (CBM_TXTPTR),Y
L885A   BNE L8857
L885C   STY $02
L885E   LDX #$03
L8860   INY
L8861   LDA $FB,X 
L8863   CMP (CBM_TXTPTR),Y
L8865   BNE L8855
L8867   DEX
L8868   BPL L8860
L886A   LDA CBM_TXTPTR
L886C   SEC
L886D   ADC $02
L886F   STA $5F
L8871   LDA CBM_TXTPTR+1
L8873   ADC #$00
L8875   STA $60
L8877   INC CBM_TXTPTR+1
L8879   LDA $02
L887B   EOR #$FF
L887D   TAY
L887E   LDA #$40
L8880   STA $CA1B
L8883   JSR P_SPC
L8886   JSR $A703
L8889   LDA #$00
L888B   STA $C6
L888D   JSR $F13E
L8890   TAX
L8891   BEQ L888D
L8893   JMP L87F2
---------------------------------
L8896   JSR CBM_CHRGOT
L8899   TSX
L889A   STX $CA1C                       ; temp stack pointer
L889D   CMP #$64
L889F   BEQ L88C7
L88A1   CMP #$63
L88A3   BEQ L88E3
L88A5   CMP #$8A
L88A7   BNE L88B4
L88A9   LDY #$00
L88AB   STY $CA5E
L88AE   STY $CAAF
L88B1   JSR L9EEB
L88B4   CMP #$8B
L88B6   BEQ L8902
L88B8   CMP #$9B
L88BA   BNE L88C1
L88BC   LDX #$01
L88BE   STX $CA1B
L88C1   JSR CBM_CHRGOT
L88C4   JMP $A7E7
---------------------------------
L88C7   JSR L88D0
L88CA   JSR ROM_ON
L88CD   JMP CBM_NEWSTT
---------------------------------
L88D0   JSR L8587                       ; LDA($7A+1),y
L88D3   ASL
L88D4   TAY
L88D5   JSR ROM_OFF
L88D8   LDA CMDADD2-1,Y 
L88DB   PHA
L88DC   LDA CMDADD2-2,Y 
L88DF   PHA
L88E0   JMP CBM_CHRGET
---------------------------------
L88E3   JSR L8587                       ; LDA($7A+1),y
L88E6   CMP #$20
L88E8   BCC L88FF
L88EA   JSR L88F0
L88ED   JMP L88CA
---------------------------------
L88F0   ASL
L88F1   TAY
L88F2   JSR ROM_OFF
L88F5   LDA CMDADD1-1,Y 
L88F8   PHA
L88F9   LDA CMDADD1-2,Y 
L88FC   JMP L88DF
---------------------------------
L88FF   JMP CBM_SNERR
---------------------------------
L8902   JSR CBM_CHRGET
L8905   JSR CBM_FRMEV
L8908   JSR CBM_CHRGOT
L890B   CMP #$89
L890D   BEQ L8914
L890F   LDA #$A7
L8911   JSR CBM_CHKCHAR                 ; check for a specific value
L8914   LDX $61
L8916   BEQ L8926
L8918   JSR CBM_CHRGOT
L891B   BCS L8923
L891D   JSR CBM_GOTO
L8920   JMP CBM_NEWSTT
---------------------------------
L8923   JMP L8899
---------------------------------
L8926   CMP #$63
L8928   BNE L8932
L892A   LDY #$01
L892C   LDA (CBM_TXTPTR),Y
L892E   CMP #$38
L8930   BEQ L8948
L8932   JSR L86A1
L8935   JSR L8587                       ; LDA($7A+1),y
L8938   BEQ L8923
L893A   CMP #$63
L893C   BNE L8935
L893E   JSR L8587                       ; LDA($7A+1),y
L8941   CMP #$37
L8943   BNE L8935
L8945   JMP OWN_GONE
---------------------------------
L8948   LDX #$39
L894A   STX $02
L894C   LDX #$00
L894E   TAY
L894F   BNE L8968
L8951   JSR INC7A_7B
L8954   JSR L8587                       ; LDA($7A+1),y
L8957   BEQ L8994
L8959   JSR L8587                       ; LDA($7A+1),y
L895C   STA $FD
L895E   JSR L8587                       ; LDA($7A+1),y
L8961   STA $FE
L8963   JSR L8587                       ; LDA($7A+1),y
L8966   BEQ L8951
L8968   CMP #$63
L896A   BNE L8963
L896C   JSR L8587                       ; LDA($7A+1),y
L896F   CMP #$38
L8971   BNE L8974
L8973   INX
L8974   CMP #$3A
L8976   BNE L897B
L8978   DEX
L8979   BMI L8982
L897B   CMP $02
L897D   BNE L8963
L897F   TXA
L8980   BNE L8963
L8982   LDA $FD
L8984   LDX $FE
L8986   STA $39
L8988   STX $3A
L898A   LDA $02
L898C   BEQ L8991
L898E   JMP OWN_GONE
---------------------------------
L8991   JMP CBM_CHRGET
---------------------------------
L8994   LDX #$22                        ; MISSING BEND
L8996   JMP PRINTERR
---------------------------------
L8999   LDY #$00
L899B   LDA (CBM_TXTPTR),Y
L899D   RTS
---------------------------------
; X = $00
L899E   STX $CA1F                       ; BREAK flag
L89A1   STX $CA21                       ; PAGE mode
L89A4   STX $CA0E                       ; STRACE mode
L89A7   STA $CA1A                       ; RESUME flag
L89AA   JMP L80A2
; ----------------------------------------------
; - $89AD Own eval vector ----------------------
; ----------------------------------------------
OWN_EVAL
        LDA #$00
L89AF   STA $0D
L89B1   JSR CBM_CHRGET
L89B4   CMP #$24
L89B6   BEQ L89BF
L89B8   CMP #$25
L89BA   BNE L89D3
L89BC   LDY #$08
L89BE   !by $2c
L89BF   LDY #$04
L89C1   JSR CBM_CHRGET
L89C4   LDA CBM_TXTPTR
L89C6   LDX CBM_TXTPTR+1
L89C8   STA $22
L89CA   STX $23
L89CC   JSR L8658
L89CF   TYA
L89D0   JMP LA456
---------------------------------
L89D3   CMP #$63
L89D5   BEQ L89DD
L89D7   JSR CBM_CHRGOT
L89DA   JMP $AE8D
---------------------------------
L89DD   JSR L8587                       ; LDA($7A+1),y
L89E0   CMP #$20
L89E2   BCS L8A02
L89E4   ASL
L89E5   TAX
L89E6   JSR CBM_CHRGET
L89E9   CPX #$0D
L89EB   BCC L89F6
L89ED   JSR CBM_CHKOPN
L89F0   JSR L89F6
L89F3   JMP CBM_CHKCLS
---------------------------------
L89F6   JSR ROM_OFF
L89F9   LDA $BDFF,X 
L89FC   PHA
L89FD   LDA $BDFE,X 
L8A00   PHA
L8A01   RTS
---------------------------------
L8A02   JMP CBM_SNERR
; ----------------------------------------------
; - $8A05 ERRN ---------------------------------
; ----------------------------------------------
CMD_ERRN
        LDA $CA15                       ; error code number
        !by $2c
; ----------------------------------------------
; - $8A09 YPOS ---------------------------------
; ----------------------------------------------
CMD_YPOS
        LDA $D6                         ; load current physical line number of cursor
        !by $24
L8A0C   TXA
L8A0D   LDX #$00                        ; low byte
L8A0F   STX $62                         ; store for float
        STA $63                         ;
L8A13   JSR ROM_ON                      ; switch ROM on
        LDA #$00                        
        STA $0D                         ; Variable type = 0, = numeric
L8A1A   LDX #$90                        ; load exponent
        SEC                             ; set carry for positive value
        JMP CBM_FLOATC                  ; FLOAT UNSIGNED VALUE IN FAC+1,2
---------------------------------
L8A20   JSR ROM_ON
        JMP CMD_PUTNEW
---------------------------------
L8A26   LDX #$27                        ; ILLEGAL STRING LENGTH
        JMP PRINTERR
---------------------------------
L8A2B   PHA
        JSR ROM_ON
        PLA
        JSR $B68C
        JMP ROM_OFF
---------------------------------
L8A36   JMP CBM_ERRFC                   ; illegal quantity error
; ----------------------------------------------
; - $8A39 ERR$ ---------------------------------
; ----------------------------------------------
CMD_ERR_STR
        JSR ROM_ON
        JSR CBM_GETBYT
        DEX
        CPX #$2A
        BCS L8A36
        TXA
        ASL
        TAX
        CPX #$3B
        BCC +
        LDA L8376-$3C,X                 ; extension error code addresses
        LDY L8376-$3B,X 
        BNE ++
+       LDA $A328,X                     ; basic error code addresses 
        LDY $A329,X 
++      STA $24
        STY $25
        LDY #$FF
-       INY
        LDA ($24),Y
        BPL -
        INY
        TYA
        JSR CBM_STRSPA
        TAY
        DEY
-       LDA ($24),Y
        AND #$7F
        STA ($62),Y
        DEY
        BPL -
        JMP CMD_PUTNEW
; ----------------------------------------------
; - $8A77 ROOT ---------------------------------
; ----------------------------------------------
CMD_ROOT
        JSR ROM_ON
        JSR CBM_FRMNUM
        JSR CBM_CHKCOM
        LDA #$BC
        LDY #$B9
        JSR $BB0F
        LDX #$05
-       LDA $61,X 
        PHA
        DEX
L8A8D   BPL -
        JSR CBM_FRMNUM
        JSR CBM_MOVAF
        LDX #$FA
-       PLA
        STA $67,X 
        INX
        BMI -
        JMP $BF7D
; ----------------------------------------------
; - $8AA0 EXOR ---------------------------------
; ----------------------------------------------
CMD_EXOR
        JSR ROM_ON
        JSR CBM_FRMNUM
        JSR $B1AA
        PHA
        TYA
        PHA
        JSR CBM_CHKCOM
        JSR CBM_FRMNUM
        JSR $B1AA
        PLA
        EOR $65
        TAY
        PLA
        EOR $64
        JMP CBM_INTFAC
---------------------------------
L8ABF   JMP L8A26                       ; ILLEGAL STRING LENGTH
; ----------------------------------------------
; - $8AC2 EVAL ---------------------------------
; ----------------------------------------------
CMD_EVAL
        JSR L85AA                       ; CBM_FRMEV,CBM_FRESTR
        TAY
        JSR ROM_ON
        JSR CBM_CHKDIR
        CPY #$59
        BCS L8ABF
        TYA
        BNE L8AD6
        JMP L8A0D
---------------------------------
L8AD6   LDA CBM_TXTPTR
        PHA
        LDA CBM_TXTPTR+1
        PHA
        LDA $FB
        PHA
        LDA $FC
        PHA
        LDA #$00
        STA CBM_TXTPTR
        STA CBM_COMMANDBUF,Y 
        DEY
-       LDA ($22),Y
        STA CBM_COMMANDBUF,Y 
        DEY
        BPL -
        JSR L84E0
        LDA #$00
        LDX #$02
        STA CBM_TXTPTR
        STX CBM_TXTPTR+1
        JSR CBM_FRMNUM
        LDA #$00
        STA $0D
        PLA
        STA $FC
        PLA
        STA $FB
        PLA
        STA CBM_TXTPTR+1
        PLA
        STA CBM_TXTPTR
        RTS
; ----------------------------------------------
; - $8B11 ROUND --------------------------------
; ----------------------------------------------
CMD_ROUND
        JSR ROM_ON
        JSR CBM_FRMNUM
        TSX
        TXA
        SEC
        SBC #$05
        TAX
        TXS
        INX
        LDY #$01
        JSR CBM_MOVMF
        JSR CBM_COMBYT
        STX $24
        LDA #$BC
        LDY #$B9
        JSR CBM_MOVFM
        LDA $24
        BEQ +
-       JSR $BAE2
        DEC $24
        BNE -
+       JSR $BBCA
        TSX
        INX
        TXA
        LDY #$01
        JSR CBM_FMULT
        TSX
        TXA
        CLC
        ADC #$05
        TAX
        TXS
        JSR CBM_SIGN
        BPL L8B61
        LDA #$5C
        LDY #$8B
        JSR CBM_FADD
        JMP L8B64
---------------------------------
L8B5C   !by $7F,$7F,$FF,$FF,$F8

L8B61   JSR $B849
L8B64   JSR CBM_INT
        JSR CBM_MOVAF
        LDA #$57
        LDY #$00
        JSR CBM_MOVFM
        JMP CBM_FDIVT
; ----------------------------------------------
; - $8B74 get char and mode (c,gk) -------------
; ----------------------------------------------
GET_CHR_MOD   
        JSR L8598                       ; CBM_GETBYT
        STX $14
        LDA #$00
        STA $15
        LDY #$03
-       ASL $14
        ROL $15
        DEY
        BNE -
        JSR L858F                       ; CBM_COMBYT
        LDA #$E0
        DEX
        BMI +
        LDA #$E8
+       CLC
        ADC $15
        STA $15
        RTS
; ----------------------------------------------
; - $8B96 AUTO ---------------------------------
; ----------------------------------------------
CMD_AUTO
        JSR L85D3                       ; CBM_FRMNUM,CBM_GETADR
        STY $F7                         ; start line low byte
        STA $F8                         ; start line high byte
        JSR L85A1                       ; CBM_CHKCOM
        JSR L85D3                       ; CBM_FRMNUM,CBM_GETADR
        STY $F9                         ; step width low byte
        STA $FA                         ; step width high byte
        LDA #$01                        ;
        STA $CA0D                       ; set AUTO flag, $01 = ON
        JSR ROM_ON                      ; seitch on ROM
        PLA                             ;
        PLA                             ;
        JMP OWN_BWSTART                 ;
; ----------------------------------------------
; - $8BB4 OLD ----------------------------------
; ----------------------------------------------
CMD_OLD
        LDY #$01
        TYA
        STA (CBM_TXTTAB),Y
L8BB9   JSR ROM_ON
        JSR CBM_LNKPRG
        LDA $22
        CLC
        ADC #$02
        STA CBM_VARTAB
        LDA $23
        ADC #$00
        STA CBM_VARTAB+1
        JMP CBM_CLR
; ----------------------------------------------
; - $8BCF MONITOR ------------------------------
; ----------------------------------------------
CMD_MONITOR
        JSR ROM_ON
        JMP ($CA26)
; ----------------------------------------------
; - $8BD5 SGOTO --------------------------------
; ----------------------------------------------
CMD_SGOTO
        JSR L85D3                       ; CBM_FRMNUM,CBM_GETADR
        JSR ROM_ON
        JMP $A8A3
; ----------------------------------------------
; - $8BDE POP ----------------------------------
; ----------------------------------------------
CMD_POP
        JSR L8598                       ; CBM_GETBYT
        DEX                             ; decrease input
        BNE L8BFA                       ; branch if >0
; handle GOSUB/RETURN
        TSX                             ; 
        LDA $0103,X 
        CMP #$8D
        BNE L8C0B
        TXA
        ADC #$08
        TAX
        JSR ROM_ON
        TXS
        JMP CBM_NEWSTT
---------------------------------
; handle others
L8BF7   !by $35,$AF,$5E                 ; EXEC/END PROC, REPEAT/UNTIL, LOOP/ENDLOOP

L8BFA   CPX #$04                        ; check value
        BCS L8C0C                       ; make error if to high
        TXA                             ;
        TAY                             ; transfere value to y
        LDX L8BF7-1,Y                   ; load pointer
        LDA $CA00,X                     ; load value
        BEQ L8C0B                       ; branch if it is 0, nothing to do
        DEC $CA00,X                     ; else decrease value
L8C0B   RTS
---------------------------------
L8C0C   JMP L867E                       ; ILLEGAL QUANTITY
; ----------------------------------------------
; - $8C0F CASE OF ------------------------------
; ----------------------------------------------
CMD_CASE_OF
        JSR ROM_ON
        JSR CBM_FRMEV
        LDX #$06
-       LDA $60,X 
; ----------------------------------------------
; - $8C18 ENDCASE ------------------------------
; ----------------------------------------------
CMD_ENDCASE
; L8C18 RTS
L8C19   STA $F6,X 
        DEX
        BNE -
        STX $02
        LDA $0D
        STA $FD
--      JSR L8C57
        CPX #$4D
        BNE L8C19-1                     ; RTS
L8C2B   JSR CBM_FRMEV
        LDX #$06
-       LDA $F6,X 
        STA $68,X 
        DEX
        BNE -
        LDA $FD
        ASL
        LDA #$02
        STA $12
        JSR $B016
        LDX $61
        BNE +
        JSR CBM_CHRGOT
        BEQ --
        JSR CBM_CHKCOM
        JMP L8C2B
---------------------------------
+       JMP CBM_DATA
; ----------------------------------------------
; - $8C53 WHEN , OTHERWISE ---------------------
; ----------------------------------------------
CMD_WHEN
CMD_OTHERWISE
        LDX #$FF
        STX $02
L8C57   LDY #$00
        STY $22
        !by $2c
L8C5C   INC $22
        LDA (CBM_TXTPTR),Y
        BNE L8C74
-       JSR INC7A_7B
        JSR L8587                       ; LDA($7A+1),y
        BEQ L8CA8
        JSR L8587                       ; LDA($7A+1),y
        STA $A8
        JSR L8587                       ; LDA($7A+1),y
        STA $A9
L8C74   JSR L8587                       ; LDA($7A+1),y
        BEQ -
        CMP #$63
        BNE L8C74
        JSR L8587                       ; LDA($7A+1),y
        CMP #$4B
        BEQ L8C5C
        TAX
        CPX #$4C
        BNE +
        LDA $22
        BEQ ++
        DEC $22
+       LDA $02
        ORA $22
        BNE L8C74
        CPX #$4D
        BEQ ++
        CPX #$4E
        BNE L8C74
++      LDA $A8
        LDY $A9
        STA $39
        STY $3A
        JMP CBM_CHRGET
---------------------------------
L8CA8   LDX #$29                        ; MISSING ENDCASE
        JMP PRINTERR
; ----------------------------------------------
; - $8CAD HELP ---------------------------------
; ----------------------------------------------
CMD_HELP
        JSR ROM_ON
        LDA $CA16                       ; ERRLN line number
        LDX $CA17
        STA $14                         ; store for find line in memory
        STX $15
        JSR CBM_FNDLIN                  ; find line in memory
        LDY $CA1A                       ; RESUME flag
        BNE L8CF4                       ; RTS
        LDA $CA18                       ; CONT memory pointer
        LDX $CA19
        STA $F7
        STX $F8
        LDA ($F7),Y
        BNE +
        LDY #$04
+       TYA
        SEC
        ADC $F7
        STA $F7
        LDX #$80                        ; flag for inverted output
        STX $CA1B
        PLA
        PLA
        JMP $A6C9
; ----------------------------------------------
; - $8CE2 NCHAR --------------------------------
; ----------------------------------------------
CMD_NCHAR
        SEI
        LDA $01
        EOR #$05
        STA $01
        LDA #$00
        STA $5F
        STA $5A
        STA $58
        LDX #$D0
        !by $86                         ; STX $60
L8CF4   RTS                             ; used from HELP as RTS
        LDX #$E0
        STX $5B
        LDX #$F0
        STX $59
        JSR $A3BF
        LDA $01
        EOR #$05
        JMP L8695
; ----------------------------------------------
; - $8D07 CIRCLE -------------------------------
; ----------------------------------------------
CMD_CIRCLE
        LDX #$00
        STX $AC
        STX $AD
        LDA #$68
        INX
        STA $AE
        STX $AF
        LDA #$0C
        STA $02
L8D18   !by $2c
; ----------------------------------------------
; - $8D19 ARC ----------------------------------
; ----------------------------------------------
CMD_ARC
        LDA #$00
        PHA
        JSR L8683                       ; CBM_GETNUM
        STY $A7
        STA $A8
        STX $A9
        JSR L85A1                       ; CBM_CHKCOM
        JSR L8683                       ; CBM_GETNUM
        STY $AA
        STA $AB
        STX $A5
        PLA
        BNE L8D66
        JSR L85A1                       ; CBM_CHKCOM
        JSR L85D3                       ; CBM_FRMNUM,CBM_GETADR
        STY $AC
        STA $AD
        JSR L85A1                       ; CBM_CHKCOM
        JSR L85D3                       ; CBM_FRMNUM,CBM_GETADR
        CMP $AD
        BEQ +
        !by $2c
+       CPX $AC
        BCS +
        LDX $AD
        STA $AD
        TYA
        LDY $AC
        STA $AC
        TXA
+       STY $AE
        STA $AF
        JSR L858F                       ; CBM_COMBYT
        TXA
        BNE +
        JMP L867E                       ; ILLEGAL QUANTITY
---------------------------------
+       STX $02
L8D66   JSR L858F                       ; CBM_COMBYT
        STX $F7
        LDA #$00
        STA $F9
        STA $24
        STA $25
L8D73   JSR ROM_ON
         SEC
        LDA #$1C
        SBC $AC
        STA $63
        LDA #$02
        SBC $AD
L8D81   STA $62
        JSR L8A1A
        LDA #$54
        LDY #$8E
        JSR CBM_FMULT
        LDX #$05
-       LDA $61,X 
        PHA
        DEX
        BPL -
        JSR $E26B
        JSR CBM_MOVAF
        LDA $AA
        LDX $AB
        STA $63
        STX $62
        JSR L8A1A
        JSR $BA2B
        JSR $B1AA
        ASL
        TYA
        ADC $A7
        TAY
        LDA $64
        ADC $A8
        LDX $64
        BPL +
        BCS ++
        LDY #$00
        TYA
+       BCS +
        TAX
        BEQ ++
        DEX
        BNE +
        CPY #$40
        BCC ++
+       LDY #$3F
        LDA #$01
++      STY $FB
        STA $FC
        LDX #$FA
-       PLA
        STA $67,X 
        INX
        BMI -
        JSR $E264
        JSR CBM_MOVAF
        LDA $A5
        LDX #$00
        STA $63
        STX $62
        JSR L8A1A
        JSR $BA2B
        JSR $B1AA
        ASL
        TYA
        ADC $A9
        LDX $64
        BMI ++
        BCS +
        CMP #$C8
        BCC +++
+       LDA #$C7
++      BCS +++
        LDA #$00
+++     STA $FD
        LDX #$01
        LDA $24
        STX $24
        BEQ +
        JSR ROM_OFF
        LDA $49
        LDX $4A
        LDY $FF
        STA $14
        STX $15
        STY $FE
        JSR LB9C9
+       LDA $FB
        LDX $FC
        LDY $FD
        STA $49
        STX $4A
        STY $FF
        CLC
        LDA $AC
        ADC $02
        STA $AC
        BCC +
        INC $AD
+       LDA $AF
        LDX $AE
        CMP $AD
        BEQ +
        !by $2c
+       CPX $AC
        BCS ++
        LDY $25
        BNE +
        STX $AC
        STA $AD
        INC $25
        !by $24
+       RTS
++      JMP L8D73
---------------------------------

L8E54   !by $7B,$0E,$FA,$35,$0F
; ----------------------------------------------
; - $8E59 PAUSE --------------------------------
; ----------------------------------------------
CMD_PAUSE
        JSR ROM_ON
        JSR CBM_GETBYT
        PLA
        PLA
        TXA
        BEQ +
--      LDA $A2
        STA $02
-       JSR CBM_BSTOP
        LDA $A2
        SEC
        SBC $02
        CMP #$3C
        BCC -
        DEX
        BNE --
+       JMP CBM_NEWSTT
; ----------------------------------------------
; - $8E7A SBLOCK -------------------------------
; ----------------------------------------------
CMD_SBLOCK
        LDA #$01
        STA $A9
        !by $2c
; ----------------------------------------------
; - $8E7D GBLOCK -------------------------------
; ----------------------------------------------
CMD_GBLOCK
        LDA #$00
        STA $FE
        JSR GET_BLKPARAM
        LDA $14
        LDX $15
        STA $F9
        STX $FA
        JSR L85A1                       ; CBM_CHKCOM
        JSR L8683                       ; CBM_GETNUM
        STY $FB
        STA $FC
        STX $F8
        LDX #$00
        LDA $FE
        BNE +
        JSR L8F37
+       STX $F7
        LDA #$15
        STA $72
L8EA9   LDA $FB
        LDX $FC
        STA $24
        STX $25
        LDA #$03
        STA $23
L8EB5   LDY $FE
        BNE +
        JSR L8699                       ; switch off kernal
        LDA ($F9),Y
        STA $66
        JSR L8691                       ; switch on kernel
        JSR L8EFB
        BEQ L8EE9
+       LDA #$08
        STA $22
L8ECC   LDX $24
        LDY $25
        LDA $F8
        JSR LBC87
        SEC
        BEQ L8ED9
        CLC
L8ED9   ROL $66
        INC $24
        BNE +
        INC $25
+       DEC $22
        BNE L8ECC
        LDA $66
        STA ($F9),Y
L8EE9   INC $F9
        DEC $23
        BNE L8EB5
        CLC
        LDA $F8
        ADC $A9
        STA $F8
        DEC $72
        BNE L8EA9
        RTS
---------------------------------
L8EFB   LDA #$08
        STA $65
L8EFF   ASL $66
        LDA $A8
        BCS L8F0F
        ADC $24
        STA $24
        BCC L8F32
        INC $25
        BCS L8F32
L8F0F   STA $67
--      LDA $A9
        STA $68
        LDA $F8
        STA $69
-       LDX $24
        LDY $25
        LDA $69
        JSR LB908
        INC $69
        DEC $68
        BNE -
        INC $24
        BNE +
        INC $25
+       DEC $67
        BNE --
L8F32   DEC $65
        BNE L8EFF
L8F36   RTS
---------------------------------
L8F37   JSR L858F                       ; CBM_COMBYT
        TXA
        BEQ +
        STA $A8
        JSR L858F                       ; CBM_COMBYT
        TXA
        BEQ +
        STA $A9
        JMP L858F                       ; CBM_COMBYT
---------------------------------
+       JMP L867E                       ; ILLEGAL QUANTITY
; ----------------------------------------------
; - $8F4D TEXT ---------------------------------
; ----------------------------------------------
CMD_TEXT
        JSR L8683                       ; CBM_GETNUM
        STY $FB
        STA $FC
        STX $FD
        JSR L85A1                       ; CBM_CHKCOM
        JSR L85AA                       ; CBM_FRMEV,CBM_FRESTR
        STX $F9
        STY $FA
        STA $FE
        JSR L8F37
        STX $02
        JSR L858F                       ; CBM_COMBYT
        STX $F7
        LDY #$FF
        STY $61
        INY
        STY $62
        !by $2c
--      LDY #$08
-       STY $63
L8F78   INC $61
        LDY $61
        CPY $FE
        BEQ L8F36
        LDA ($F9),Y
        LDY #$00
        CMP #$92
        BEQ +
        CMP #$12
        BNE ++
        LDY #$04
+       STY $62
        BCS L8F78
++      CMP #$08
        BEQ -
        CMP #$0C
        BEQ --
        JSR $A65E
        STY $23
        ASL
        ROL $23
        ASL
        ROL $23
        ASL
        ROL $23
        STA $22
        LDA $23
        ORA $62
        ORA $63
        ORA #$D0
        STA $23
        LDA $FD
        STA $F8
L8FB8   STY $64
        LDA $FB
        LDX $FC
        STA $24
        STX $25
        JSR L86AA
        LDA ($22),Y
        STA $66
        JSR L86B2
        JSR L8EFB
        CLC
        LDA $F8
        ADC $A9
        STA $F8
        LDY $64
        INY
        CPY #$08
        BNE L8FB8
        CLC
        LDA $FB
        ADC $02
        STA $FB
        BCC L8F78
        INC $FC
        BCS L8F78
L8FEA   LDA $FB
        BNE +
        DEC $FC
+       DEC $FB
        CLC
        LDA $FE
        ADC $24
        STA $FD
        RTS
---------------------------------
L8FFA   JMP LADA8                       ; TYPE MISMATCH
---------------------------------
L8FFD   JMP L8670                       ; STRING TO LONG
---------------------------------
L9000   JMP L867E                       ; ILLEGAL QUANTITY
---------------------------------
; ----------------------------------------------
; - $9003 SHAPE --------------------------------
; ----------------------------------------------
CMD_SHAPE
        JSR L85B9                       ; CBM_PTRGET
        LDX $0D
        BEQ L8FFA
        TAX
        JSR L9098
        JSR L85D3                       ; CBM_FRMNUM,CBM_GETADR
        TYA
        PHA
        CLC
        ADC $A8
        STA $FB
        LDA $15
        PHA
        ADC $A9
        STA $FC
        JSR L858F                       ; CBM_COMBYT
        STX $24
        PLA
        STA $02
        STA $5A
        PLA
        PHA
        STA $59
        STX $5B
        JSR LA560
        LDA $57
        ORA $58
        BEQ L9000
        LDA $57
        LDX #$03
        STX $F8
-       LSR $58
        ROR
        DEX
        BNE -
        CLC
        ADC #$04
        BCS L8FFD
        LDX $58
        BNE L8FFD
        JSR L85C5                       ; CBM_STRSPA
        LDY #$00
        STY $F7
        PLA
        STA ($62),Y
        INY
        LDA $02
        STA ($62),Y
        INY
        LDA $24
        STA ($62),Y
-       LDA $0061,Y 
        STA ($F9),Y
        DEY
        BPL -
        LDA #$08
        STA $25
L906D   JSR L8FEA
L9070   DEC $FD
        JSR LBC81
        SEC
        BEQ +
        CLC
+       ROR $60
        DEC $25
        BNE +
        LDA #$08
        STA $25
        LDY $F8
        !by $A5                         ; LDA $60
-       RTS
        STA ($62),Y
        INC $F8
        INY
        CPY $61
        BEQ -                           ; RTS
+       LDY $FD
        CPY $FE
        BNE L9070
        BEQ L906D
L9098   STX $F9
        STY $FA
        JSR L85A1                       ; CBM_CHKCOM
        JSR L8683                       ; CBM_GETNUM
        STY $A8
        STA $A9
        STX $FE
        JMP L85A1                       ; CBM_CHKCOM
; ----------------------------------------------
; - $90AB GSHAPE -------------------------------
; ----------------------------------------------
CMD_GSHAPE
        JSR L85AA                       ; CBM_FRMEV,CBM_FRESTR
        JSR L9098
        JSR L8598                       ; CBM_GETBYT
        STX $F7
        LDY #$00
        CLC
        LDA ($F9),Y
        ADC $A8
        STA $FB
        INY
        STY $23
        LDA ($F9),Y
        ADC $A9
        STA $FC
        STY $02
        CPX #$03
        BNE +
        DEC $02
+       INY
        STY $25
        LDA ($F9),Y
        STA $24
L90D7   JSR L8FEA
L90DA   DEC $FD
        DEC $23
        BNE +
        LDA #$08
        STA $23
        INC $25
        LDY $25
        LDA ($F9),Y
        STA $60
+       LSR $60
        LDA $02
        BNE +
        ROL
        STA $F7
        !by $2c
+       BCC +
        LDX $FB
        LDY $FC
        LDA $FD
        JSR LB908
+       LDA $FD
        CMP $FE
        BNE L90DA
        LDA $A8
        CMP $FB
        BNE L90D7
        LDA $A9
        CMP $FC
        BNE L90D7
        RTS
; ----------------------------------------------
; - $9114 RENUM --------------------------------
; ----------------------------------------------
CMD_RENUM
        BNE +
        LDY #$0A
        LDA #$00
        STY $F7
        STA $F8
        BEQ ++
+       JSR L85D3                       ; CBM_FRMNUM,CBM_GETADR
        STY $F7
        STA $F8
        JSR L85A1                       ; CBM_CHKCOM
        JSR L85D3                       ; CBM_FRMNUM,CBM_GETADR
++      STY $F9
        STA $FA
        JSR L864C
--      JSR INC7A_7B
        JSR L8587                       ; LDA($7A+1),y
        BNE +
        JMP L92D5
---------------------------------
+       JSR L8587                       ; LDA($7A+1),y
        STA $FD
        JSR L8587                       ; LDA($7A+1),y
        STA $FE
L9149   JSR CBM_CHRGET
L914C   CMP #$22
        BNE +
-       JSR CBM_CHRGET
        TAX
        BEQ --
        CMP #$22
        BNE -
        BEQ L9149
+       CMP #$63
        BNE +
        JSR L8587                       ; LDA($7A+1),y
        CMP #$4A
        BNE L9149
        BEQ L91A2
+       TAX
        BEQ --
        BPL L9149
        CMP #$CB
        BNE +
        JSR CBM_CHRGET
        CMP #$A4
        BNE L914C
        BEQ L91A2
+       LDY #$03
-       CMP L92D1,Y 
        BEQ L91A2
        DEY
        BPL -
        CMP #$9B
        BNE L9149
        JSR CBM_CHRGET
        BEQ L914C
        BCC +
L9190   JSR CBM_CHRGET
        BCS L914C
+       LDA CBM_TXTPTR
        LDX CBM_TXTPTR+1
        STA $FB
        STX $FC
        JSR L8607                       ; CBM_CHRGOT, CBM_LINGET
        BNE +
L91A2   JSR CBM_CHRGET
        BCS L914C
        LDA CBM_TXTPTR
        LDX CBM_TXTPTR+1
        STA $FB
        STX $FC
        JSR L85D3                       ; CBM_FRMNUM,CBM_GETADR
+       LDA CBM_TXTTAB
        LDX CBM_TXTTAB+1
        STA $5F
        STX $60
        LDA $F7
        LDX $F8
        STA $63
        STX $62
        LDY #$01
L91C4   LDA ($5F),Y
        TAX
        BNE +
        LDX $22
        LDA $23
        JSR L85E2                       ; CBM_INTOUT
        JSR P_RET
        JMP L92BD
---------------------------------
+       INY
        LDA ($5F),Y
        PHA
        CMP $FD
        BNE +
        INY
        LDA ($5F),Y
        DEY
        CMP $FE
        BNE +
        LDA $63
        STA $22
        LDA $62
        STA $23
+       PLA
        CMP $14
        BNE +
        INY
        LDA ($5F),Y
        CMP $15
        BEQ ++
+       LDY #$00
        LDA ($5F),Y
        STA $5F
        STX $60
        LDA $63
        CLC
        ADC $F9
        STA $63
        LDA $62
        ADC $FA
        STA $62
        INY
        BNE L91C4
++      JSR ROM_ON
        LDX #$90
        SEC
        JSR CBM_FLOATC
        JSR $BDDF
        JSR ROM_OFF
        LDA CBM_TXTPTR
        SEC
        SBC $FB
        STA $62
        LDY #$FF
-       INY
        LDA $0100,Y 
        BNE -
        CPY $62
        BEQ L9290
        BCS ++
        STY $63
        LDA $62
        SEC
        SBC $63
        TAY
        LDA $FB
        CLC
        ADC $63
        STA $5F
        LDA $FC
        ADC #$00
        STA $60
        LDX #$00
-       LDA ($5F),Y
        STA ($5F,X)
        LDA $5F
        CMP CBM_VARTAB
        BNE +
        LDA $60
        CMP CBM_VARTAB+1
        BEQ L9290
+       INC $5F
        BNE -
        INC $60
        BNE -
++      LDA CBM_TXTPTR
        LDX CBM_TXTPTR+1
        STA $5F
        STX $60
        TYA
        SBC $62
        SEC
        ADC CBM_VARTAB
        STA $58
        LDA CBM_VARTAB+1
        ADC #$00
        STA $59
        LDX CBM_VARTAB
        LDY CBM_VARTAB+1
        INX
        BNE +
        INY
+       STX $5A
        STY $5B
        JSR ROM_ON
        JSR $A3BF
        JSR ROM_OFF
L9290   LDY #$00
-       LDA $0100,Y 
        BEQ +
        STA ($FB),Y
        INY
        BNE -
+       TYA
        CLC
        ADC $FB
        STA CBM_TXTPTR
        LDA $FC
        ADC #$00
        STA CBM_TXTPTR+1
        JSR ROM_ON
        JSR CBM_LNKPRG
        JSR ROM_OFF
        TXA
        CLC
        ADC #$02
        STA CBM_VARTAB
        LDA $23
        ADC #$00
        STA CBM_VARTAB+1
L92BD   JSR CBM_CHRGOT
        CMP #CBM_TXTTAB+1
        BNE +
L92C4   JMP L91A2
---------------------------------
+       CMP #$AB
        BNE +
        JMP L9190
---------------------------------
+       JMP L914C
---------------------------------
; TOKEN THEN, GOTO, GOSUB, RUN
L92D1   !by $A7,$89,$8D,$8A
---------------------------------

L92D5   LDA CBM_TXTTAB
        LDX CBM_TXTTAB+1
L92D9   STA $FB
        STX $FC
        LDY #$01
        LDA ($FB),Y
        BEQ L9302
        TAX
        LDA $F7
        INY
        STA ($FB),Y
        LDA $F8
        INY
        STA ($FB),Y
        CLC
        LDA $F7
        ADC $F9
        STA $F7
        LDA $F8
        ADC $FA
        STA $F8
        LDY #$00
        LDA ($FB),Y
        JMP L92D9
---------------------------------
L9302   JSR ROM_ON
        JSR CBM_CLR
        JMP CBM_READY
---------------------------------
; part of MATRX?
L930B   JSR INCFB_FC
        JSR INCFB_FC
        JSR L857A
        STA $02
        LDX #$FF
L9318   TYA
        INX
        STA CBM_COMMANDBUF,X 
        INX
        STA CBM_COMMANDBUF,X 
        JSR L857A
        INX
        STA CBM_COMMANDBUF,X 
        JSR L857A
        BNE +
        DEC CBM_COMMANDBUF,X 
+       INX
        STA CBM_COMMANDBUF,X 
        DEC CBM_COMMANDBUF,X 
        DEC $02
        BNE L9318
        STX $02
        RTS
---------------------------------
L933E   JSR CBM_CHROUT
L9341   LDA #$28
        JSR CBM_CHROUT
        LDX $02
L9348   DEX
        DEX
        LDA CBM_COMMANDBUF,X 
        STA $63
        DEX
        TXA
        PHA
        LDA CBM_COMMANDBUF,X 
        STA $62
        JSR $BDD1
        PLA
        TAX
        BEQ +
        LDA #CBM_TXTTAB+1
        JSR CBM_CHROUT
        DEX
        BNE L9348
+       LDA #$29
        JSR CBM_CHROUT
        LDA #$3D
        JSR CBM_CHROUT
        LDY #$00
        JMP INCFB_FC
---------------------------------
L9375   LDX $02
L9377   DEX
        DEX
        LDA CBM_COMMANDBUF+2,X 
        CMP CBM_COMMANDBUF,X 
        BNE +
        LDA CBM_COMMANDBUF+1,X 
        CMP CBM_COMMANDBUF-1,X 
        BEQ ++
+       INC CBM_COMMANDBUF,X 
        BNE +
        INC CBM_COMMANDBUF-1,X 
+       RTS
---------------------------------
++      LDA #$00
        STA CBM_COMMANDBUF-1,X 
        STA CBM_COMMANDBUF,X 
        DEX
        DEX
        BPL L9377
        JSR INCFB_FC
        PLA
        PLA
        JMP L9411
---------------------------------
L93A6   JSR L947C
        LDA $A4
        JSR CBM_CHROUT
        LDA $A5
        JMP CBM_CHROUT
---------------------------------
L93B3   LDA ($FB),Y
        STA $62
        JSR L857A
        STA $63
        LDX #$90
        SEC
        JSR $BC44
        JSR CBM_FOUT
        LDA #$00
        LDY #$01
        JMP CBM_STROUT
---------------------------------
L93CC   LDA #$22
        JSR CBM_CHROUT
        LDA ($FB),Y
        TAX
        JSR L857A
        STA $14
        JSR L857A
        STA $15
        TXA
        BEQ +
-       LDA ($14),Y
        JSR CBM_CHROUT
        INY
        DEX
        BNE -
+       LDA #$22
        JMP CBM_CHROUT
---------------------------------
L93EF   LDA $FB
        LDY $FC
        JSR CBM_MOVFM
        JSR CBM_FOUT
        LDY #$04
-       JSR INCFB_FC
        DEY
        BNE -
        TYA
        INY
        JMP CBM_STROUT
; ----------------------------------------------
; - $9406 MATRIX -------------------------------
; ----------------------------------------------
CMD_MATRIX
        JSR ROM_ON
        LDA $2F
        LDX $30
        STA $FB
        STX $FC
L9411   LDA $FB
        CMP $31
        BNE +
        LDA $FC
        CMP $32
        BNE +
        JSR P_RET
        JMP CBM_READY
---------------------------------
+       LDY #$00
        LDA ($FB),Y
        TAX
        AND #$7F
        STA $A4
        JSR INCFB_FC
        TXA
        BPL +
        LDA ($FB),Y
        AND #$7F
        STA $A5
        JSR L930B
-       JSR L93A6
        LDA #$25
        JSR L933E
        JSR L93B3
        JSR L9375
        JMP -
---------------------------------
+       LDA ($FB),Y
        TAX
        AND #$7F
        STA $A5
        TXA
        BPL +
        JSR L930B
-       JSR L93A6
        LDA #$24
        JSR L933E
        JSR L93CC
        JSR L9375
        JMP -
---------------------------------
+       JSR L930B
-       JSR L93A6
        JSR L9341
        JSR L93EF
        JSR L9375
        JMP -
---------------------------------
L947C   JSR CBM_BSTOP
        JSR P_RET
-       LDX $028D
        DEX
        BEQ -
        RTS
; ----------------------------------------------
; - $9489 DUMP ---------------------------------
; ----------------------------------------------
CMD_DUMP
        JSR ROM_ON
        LDA CBM_VARTAB
        LDX CBM_VARTAB+1
        STA $FB
        STX $FC
L9494   LDA $FB
        CMP $2F
        BNE +
        LDA $FC
        CMP $30
        BNE +
        JMP P_RET
---------------------------------
+       LDY #$00
        JSR L947C
        LDA ($FB),Y
        TAX
        AND #$7F
        TAY
        JSR L9FEA
        INX
        BPL ++
        TAX
        BMI +
        LDY #$06
        JMP L94D3
---------------------------------
+       JSR L950E
        LDA #$25
        JSR CBM_CHROUT
        LDA #$3D
        JSR CBM_CHROUT
        LDY #$00
        JSR INCFB_FC
        JSR L93B3
        LDY #$04
L94D3   JSR INCFB_FC
        DEY
        BNE L94D3
        BEQ L9494
++      TYA
        JSR CBM_CHROUT
        LDY #$00
        LDA ($FB),Y
        TAX
        AND #$7F
        JSR CBM_CHROUT
        JSR INCFB_FC
        INX
        BPL +
        LDA #$24
        JSR CBM_CHROUT
        LDA #$3D
        JSR CBM_CHROUT
        JSR L93CC
        LDY #$03
        BNE L94D3
+       LDA #$3D
        JSR CBM_CHROUT
        JSR L93EF
        JSR INCFB_FC
        JMP L9494
---------------------------------
L950E   TYA
        JSR CBM_CHROUT
        LDY #$00
        LDA ($FB),Y
        AND #$7F
        JMP CBM_CHROUT
; ----------------------------------------------
; - $951B WINDOW -------------------------------
; ----------------------------------------------
CMD_WINDOW
        BEQ L954B
        JSR L8598                       ; CBM_GETBYT
        CPX #$C8
        BCC +
-       JMP L867E                       ; ILLEGAL QUANTITY
---------------------------------
+       TXA
        ADC #$31
        PHA
        JSR L858F                       ; CBM_COMBYT
        CPX #$C9
        BCS -
        SEI
        PLA
        STA $07F5
        STA $D012
        LDA $D011
        AND #$7F
        STA $D011
        TXA
        ADC #$32
        STA $07F6
        LDA #$81
        !by $2c
L954B   LDA #$00
        STA $D01A
        CLI
        RTS
; ----------------------------------------------
; - $9552 DIR ----------------------------------
; ----------------------------------------------
CMD_DIR
        JSR L95DA
        JSR ROM_ON
        LDA #$24
        STA $FB
        LDA #$FB
        STA $BB
        LDA #$00
        STA $BC
        LDA #$01
        STA $B7
        LDA #$08
        STA $BA
        LDA #$60
        STA $B9
        JSR $F3D5
        LDA $BA
        JSR CBM_TALK
        LDA $B9
        JSR CBM_TKSA
        LDA #$00
        STA $90
        LDY #$03
L9583   STY $FB
        JSR CBM_IECIN
        STA $FC
        LDY $90
        BNE L95D7
        JSR CBM_IECIN
        LDY $90
        BNE L95D7
        LDY $FB
        DEY
        BNE L9583
        LDX $FC
        JSR CBM_INTOUT
        JSR P_SPC
L95A2   JSR CBM_IECIN
        LDX $90
        BNE L95D7
        TAX
        BEQ +
        JSR CBM_CHROUT
-       LDA $C5
        CMP #$40
        BEQ L95A2
        CMP #$3C
        BEQ -
        BNE L95A2
+       JSR P_RET
        JSR $FF9F
        JSR CBM_STOP
        BNE L95CD
        JSR CBM_CLSEI
        SEC
        JMP $A834
---------------------------------
L95CD   LDX $028D
        DEX
        BEQ L95CD
        LDY #$02
        BNE L9583
L95D7   JMP CBM_CLSEI
---------------------------------
L95DA   LDA #$08
        !by $2C
L95DD   LDA #$04
        STA $65
        JSR LA6DF
        BEQ +
        RTS
---------------------------------
+       LDX #$05                        ; DEVICE NOT PRESENT
        JMP PRINTERR
; ----------------------------------------------
; - $95EC CHECK --------------------------------
; ----------------------------------------------
CMD_CHECK
        JSR L8598                       ; CBM_GETBYT
        DEX
        BNE +
        JMP L867E                       ; ILLEGAL QUANTITY
---------------------------------
+       JSR LA6DF
        JMP L8A0D
; ----------------------------------------------
; - $95FB ERROR --------------------------------
; ----------------------------------------------
CMD_ERROR
        LDA #$01
        LDX #$08
        LDY #$0F
        JSR CBM_SETLFS
        LDA #$00
        JSR CBM_SETNAM
        JSR CBM_OPEN
        LDX #$01
        JSR CBM_CHKIN
-       JSR CBM_CHRIN
        JSR CBM_CHROUT
        BIT $90
        BVC -
        JSR CBM_CLRCHN
        LDA #$01
        JMP CBM_CLOSE
; ----------------------------------------------
; - $9523 DISK ---------------------------------
; ----------------------------------------------
CMD_DISK
        JSR L85AA                       ; CBM_FRMEV,CBM_FRESTR
        STA $F7
        TAX
        BEQ L965F
        JSR L95DA
        LDA #$01
        LDX #$08
        LDY #$6F
        JSR CBM_SETLFS
        LDA #$00
        JSR CBM_SETNAM
        JSR CBM_OPEN
        LDA #$08
        JSR CBM_LISTN
        LDA #$6F
        JSR CBM_SECND
        LDY #$00
-       LDA ($22),Y
        JSR CBM_CIOUT
        INY
        CPY $F7
        BNE -
        LDA #$08
        JSR CBM_UNLSN
        LDA #$01
        JMP CBM_CLOSE
---------------------------------
L965F   JMP L8A26                       ; ILLEGAL STRING LENGTH
; ----------------------------------------------
; - $9662 GLOAD --------------------------------
; ----------------------------------------------
CMD_GLOAD
        LDA #$00
        !by $2c
; ----------------------------------------------
; - $9665 GSAVE --------------------------------
; ----------------------------------------------
CMD_GSAVE
        LDA #$80
        !by $2c
; ----------------------------------------------
; - $9668 CLOAD --------------------------------
; ----------------------------------------------
CMD_CLOAD
        LDA #$01
        !by $2c
; ----------------------------------------------
; - $966B CSAVE --------------------------------
; ----------------------------------------------
CMD_CSAVE
        LDA #$81
        STA $02
        JSR L95DA
        JSR L85AA                       ; CBM_FRMEV,CBM_FRESTR
        STX $FB
        STY $FC
        STA $FD
        TAX
        BEQ L965F
        CLC
        ADC #$04
        JSR L85C5                       ; CBM_STRSPA
        LDY #$00
-       LDA ($FB),Y
        STA ($62),Y
        INY
        CPY $FD
        BNE -
        LDX #$02
-       LDA L9759,X 
        STA ($62),Y
        INY
        DEX
        BPL -
        LDA #$57
        BIT $02
        BMI +
        LDA #$52
+       STA ($62),Y
        LDA $61
        LDX $62
        LDY $63
        JSR CBM_SETNAM
        LDA #$02
        LDX #$08
        LDY #$62
        JSR CBM_SETLFS
        JSR CBM_OPEN
        LDA #$08
        LDX $02
        BMI +
        JSR CBM_TALK
        LDA #$62
        JSR CBM_TKSA
        JMP ++
---------------------------------
+       JSR CBM_LISTN
        LDA #$62
        JSR CBM_SECND
++      LDX #$E0
        LDA $02
        LSR
        BCC +
        LDY #$00
        LDA #$10
        JSR L9706
        BEQ ++
+       LDA #$1F
        LDY #$40
        JSR L9706
        LDX #$CC
        LDA #$03
        LDY #$E8
        JSR L9706
++      LDA #$08
        LDX $02
        BMI +
        JSR CBM_UNTALK
        JMP L9701
---------------------------------
+       JSR CBM_UNLSN
L9701   LDA #$02
        JMP CBM_CLOSE
---------------------------------
L9706   STY $FE
        LDY #$00
        STY $FB
        STX $FC
        STA $FD
L9710   BIT $02
        BPL L9726
-       JSR L8699                       ; switch off kernal
        LDA ($FB),Y
        TAX
        JSR L8691                       ; switch on kernel
        TXA
        JSR CBM_CIOUT
        INY
        BNE -
        BEQ +
L9726   JSR CBM_IECIN
        STA ($FB),Y
        INY
        BNE L9726
+       INC $FC
        DEC $FD
        BNE L9710
        BIT $02
        BPL L974C
-       CPY $FE
        BEQ +
        JSR L8699                       ; switch off kernal
        LDA ($FB),Y
        TAX
        JSR L8691                       ; switch on kernel
        TXA
        JSR CBM_CIOUT
        INY
        BNE -
L974C   CPY $FE
        BEQ +
        JSR CBM_IECIN
        STA ($FB),Y
        INY
        BNE L974C
+       RTS
---------------------------------
L9759   !by $2c,$50,$2c     ;BIT $2C50
; ----------------------------------------------
; - $975C DVERIFY ------------------------------
; ----------------------------------------------
CMD_DVERIFY
        LDA #$01
        !by $2c
; ----------------------------------------------
; - $975F DLOAD --------------------------------
; ----------------------------------------------
CMD_DLOAD
        LDA #$00
        STA $0A
        JSR L95DA
        JSR L85AA                       ; CBM_FRMEV,CBM_FRESTR
        JSR CBM_SETNAM
        JSR ROM_ON
        LDX #$08
        LDY #$00
        JSR CBM_SETLFS
        JMP $E16F
; ----------------------------------------------
; - $9779 DSAVE --------------------------------
; ----------------------------------------------
CMD_DSAVE
        JSR L95DA
        LDX #$08
        JSR CBM_SETLFS
        JSR L85AA                       ; CBM_FRMEV,CBM_FRESTR
        JSR CBM_SETNAM
        JSR ROM_ON
        LDA #CBM_TXTTAB
        LDX CBM_VARTAB
        LDY CBM_VARTAB+1
        JMP CBM_SAVE
; ----------------------------------------------
; - $9793 BLOAD --------------------------------
; ----------------------------------------------
CMD_BLOAD
        JSR L95DA
        LDA #$00
        STA $0A
        JSR L85AA                       ; CBM_FRMEV,CBM_FRESTR
        JSR CBM_SETNAM
        JSR CBM_CHRGOT
        BEQ +
        JSR L85A1                       ; CBM_CHKCOM
        JSR L85D3                       ; CBM_FRMNUM,CBM_GETADR
        LDY #$00
        !by $2c
+       LDY #$01
        LDX #$08
        JSR CBM_SETLFS
        LDA $0A
        LDX $14
        LDY $15
        JMP LA3F4
; ----------------------------------------------
; - $97BE BSAVE --------------------------------
; ----------------------------------------------
CMD_BSAVE
        JSR L95DA
        LDX #$08
        JSR CBM_SETLFS
        JSR L85AA                       ; CBM_FRMEV,CBM_FRESTR
        JSR CBM_SETNAM
        JSR L85A1                       ; CBM_CHKCOM
        JSR L85D3                       ; CBM_FRMNUM,CBM_GETADR
        STY $FB
        STA $FC
        JSR L85A1                       ; CBM_CHKCOM
        JSR L85D3                       ; CBM_FRMNUM,CBM_GETADR
        TAY
        LDX $14
        LDA #$FB
        JMP LA3FA
; ----- part of merge and chain -
L97E4   STX $FB
        STA $FC
        JSR L85AA                       ; CBM_FRMEV,CBM_FRESTR
        JSR CBM_SETNAM
        LDX #$08
        LDY #$00
        JSR ROM_ON
        JSR CBM_SETLFS
        TYA
L97F9   LDX $FB
        LDY $FC
        JSR CBM_LOAD
        BCS +
        JSR CBM_READST
        AND #$BF
        BNE L9811
        STX CBM_VARTAB
        STY CBM_VARTAB+1
        RTS
---------------------------------
+       JMP CBM_EREXIT
---------------------------------
L9811   LDX #$1D                        ; LOAD ERROR
        JMP CBM_ERROR
; ----------------------------------------------
; - $9816 CHAIN --------------------------------
; ----------------------------------------------
CMD_CHAIN
        JSR L95DA
        LDX CBM_TXTTAB
        LDA CBM_TXTTAB+1
        JSR L97E4
        JSR CBM_LNKPRG
        LDY #$00
        STY $CA5E
        STY $CAAF
        JSR L9EEB
        JMP $A871
; ----------------------------------------------
; - $9831 DMERGE -------------------------------
; ----------------------------------------------
CMD_DMERGE
        JSR L95DA
        LDY #$FF
        !by $2c
; ----------------------------------------------
; - $9837 MERGE --------------------------------
; ----------------------------------------------
CMD_MERGE
        LDY #$01
        SEC
        LDA CBM_VARTAB
        SBC #$02
        TAX
        LDA CBM_VARTAB+1
        SBC #$00
        DEY
        BEQ +
        JSR L97E4
        JMP CMD_OLD
---------------------------------
+       STX $FB
        STA $FC
        JSR ROM_ON
        JSR $E1D4
        LDA #$00
        JSR L97F9
        JMP CMD_OLD
; ----------------------------------------------
; - $985E TYPE ---------------------------------
; ----------------------------------------------
CMD_TYPE
        JSR L95DD
        LDA #$00
        JSR CBM_SETNAM
        LDY #$FF
        LDA $D018
        AND #$02
        BEQ +
        LDY #$07
+       LDA #$04
        LDX #$04
        JSR CBM_SETLFS
        JSR CBM_OPEN
        LDX #$04
        JSR CBM_CHKOUT
        JSR L8667
        JSR CBM_CLRCHN
        LDA #$04
        JMP CBM_CLOSE
; ----------------------------------------------
; - $988B TEXTCOPY -----------------------------
; ----------------------------------------------
CMD_TEXTCOPY
        JSR L95DD
        LDA #$04
        JSR CBM_CLOSE
        LDA #$00
        JSR CBM_SETNAM
        LDY #$FF
        LDA $D018
        AND #$02
        BEQ +
        LDY #$07
+       LDA #$04
        LDX #$04
        JSR CBM_SETLFS
        JSR CBM_OPEN
        LDX #$04
        JSR CBM_CHKOUT
        LDA #$00
        LDX $0288
        STA $F7
        STX $F8
        LDX #$19
        STX $FB
L98BF   LDY #$03
-       LDA L9909-1,Y 
        JSR CBM_CHROUT
        DEY
        BNE -
L98CA   LDA ($F7),Y
        JSR LA437
        CMP #$22
        BNE +
        LDA #$27
+       LDX $FA
        BPL +
        TAX
        LDA #$12
        JSR CBM_CHROUT
        TXA
        JSR CBM_CHROUT
        LDA #$92
+       JSR CBM_CHROUT
        INY
        JSR L8643                       ; check for stop key pressed
        CPY #$28
        BNE L98CA
        TYA
        CLC
        ADC $F7
        STA $F7
        BCC +
        INC $F8
+       JSR P_RET
        DEC $FB
        BNE L98BF
        JSR CBM_CLRCHN
        LDA #$04
        JMP CBM_CLOSE
---------------------------------

L9909   !by $30,$32,$10

; ----------------------------------------------
; - $990C GRAPHCOPY ----------------------------
; ----------------------------------------------
CMD_GRAPHCOPY
        JSR L95DD
        LDA #$7F
        LDX #$04
        LDY #$00
        JSR CBM_SETLFS
        JSR CBM_OPEN
        LDX #$7F
        STX $FB
        JSR CBM_CHKOUT
        LDA #$FF
        STA $F7
        LDA #$07
        STA $FD
        LDA #$1C
        STA $97
        LDA #$00
        STA $22
L9932   LDA #$28
        STA $23
        LDX #$04
-       LDA L99C4,X 
        JSR CBM_CHROUT
        DEX
        BPL -
        LDA #$00
        STA $F8
        STA $F9
L9947   LDA $22
        STA $FA
        LDA #$00
        STA $FE
L994F   LDA $F8
        LDX $F9
        LDY $FA
        JSR L99C9
        LDY #$00
        JSR L8699                       ; switch off kernal
        LDA ($AC),Y
        LDX $FE
        STA $61,X 
        JSR L8691                       ; switch on kernel
        INC $FA
        INX
        STX $FE
        CPX $FD
        BNE L994F
        LDA #$00
        LDY #$07
--      LDX $FD
-       ASL $61,X 
        ROL
        DEX
        BPL -
        AND $F7
        ORA #$80
        JSR CBM_CHROUT
        DEY
        BPL --
        LDA $F8
        CLC
        ADC #$08
        STA $F8
        BCC +
        INC $F9
+       DEC $23
        BNE L9947
        JSR P_RET
        JSR L8643                       ; check for stop key pressed
        LDA $22
        CLC
        ADC #$07
        STA $22
        DEC $97
        BEQ +
-       JMP L9932
---------------------------------
+       LDA #$04
        CMP $FD
        BEQ +
        STA $FD
        LDA #$01
        STA $97
        LDA #$0F
        STA $F7
        BNE -
+       LDA #$0F
        JSR CBM_CHROUT
        LDA #$7F
        JMP CBM_CLRCHN
---------------------------------
L99C4   !by $50,$00,$10,$1b,$08
---------------------------------
L99C9   STA $14
        STX $15
        TYA
        LSR
        LSR
        LSR
        TAX
        LDA L9A02,X 
        STA $AD
        TXA
        AND #$03
        TAX
        LDA L9A22,X 
        STA $AC
        TYA
        AND #$07
        CLC
        ADC $AC
        STA $AC
        LDA $14
        AND #$F8
        STA $F8
        LDA #$E0
        ORA $AD
        STA $AD
        CLC
        LDA $AC
        ADC $F8
        STA $AC
        LDA $AD
        ADC $15
        STA $AD
        RTS
---------------------------------

L9A02   !by $00,$01,$02,$03,$05,$06,$07,$08
        !by $0A,$0B,$0C,$0D,$0F,$10,$11,$12
        !by $14,$15,$16,$17,$19,$1A,$1B,$1C
        !by $1E,$1F,$00,$40,$80,$C0,$FF,$FF
L9A22   !by $00,$40,$80,$C0

; ----------------------------------------------
; - $9A26 HEADER -------------------------------
; ----------------------------------------------
CMD_HEADER
        LDA #$00
        STA $B7
        JSR $F7D0
        JSR $F817
        BCS L9A90
        JSR $F5AF
        JSR $F72C
        JSR P_RET
        LDY #$00
-       LDA MEM_TXT,Y 
        JSR CBM_CHROUT
        INY
        CPY #$08
        BNE -
        LDA #$3A
        JSR CBM_CHROUT
        JSR P_SPC
        LDY #$01
        LDA ($B2),Y
        STA $FB
        TAX
        INY
        LDA ($B2),Y
        STA $FC
        JSR L85E2                       ; CBM_INTOUT
        JSR P_SPC
        LDA #$2D
        JSR CBM_CHROUT
        JSR P_SPC
        LDY #$03
        LDA ($B2),Y
        TAX
        INY
        LDA ($B2),Y
        JSR L85E2                       ; CBM_INTOUT
        JSR P_SPC
        LDA #$3D
        JSR CBM_CHROUT
        JSR P_SPC
        SEC
        LDY #$03
        LDA ($B2),Y
        SBC $FB
        TAX
        INY
        LDA ($B2),Y
        SBC $FC
        JSR L85E2                       ; CBM_INTOUT
L9A90   JMP P_RET
; ----------------------------------------------
; - $9A93 ←S -----------------------------------
; ----------------------------------------------
CMD_←S
        JSR ROM_ON
        LDX #$05
        STX $AB
        JSR $E1D4
        LDX #$04
-       LDA $2A,X 
        STA $AB,X 
        DEX
        BNE -
        JSR $F838
        JSR $F68F
        JSR L9B23
        JSR L9B37
        LDA $B9
        CLC
        ADC #$01
        DEX
        JSR L9B57
        LDX #$08
-       LDA $00AC,Y 
        JSR L9B57
        LDX #$06
        INY
        CPY #$05
        NOP
        BNE -
        LDY #$00
        LDX #$04
-       LDA ($BB),Y
        CPY $B7
        BCC +
        LDA #$20
        DEX
+       JSR L9B57
        LDX #$05
        INY
        CPY #$BB
        BNE -
        LDA #$02
        STA $AB
        JSR L9B37
        TYA
        JSR L9B57
        STY $D7
        LDX #$07
        NOP
-       LDA ($AC),Y
        JSR L9B57
        LDX #$03
        INC $AC
        BNE +
        INC $AD
        DEX
        DEX
+       LDA $AC
        CMP $AE
        LDA $AD
        SBC $AF
        BCC -
        NOP
-       LDA $D7
        JSR L9B57
        LDX #$07
        DEY
        BNE -
        INY
        STY $C0
        CLI
        CLC
        LDA #$00
        STA $02A0
        JMP $FC93
---------------------------------
L9B23   LDY #$00
        STY $C0
        LDA $D011
        AND #$EF
        STA $D011
-       DEX
        BNE -
        DEY
        BNE -
        SEI
        RTS
---------------------------------
L9B37   LDY #$00
-       LDA #$02
        JSR L9B57
        LDX #$07
        DEY
        CPY #$09
        BNE -
        LDX #$05
        DEC $AB
        BNE -
-       TYA
        JSR L9B57
        LDX #$07
        DEY
        BNE -
        DEX
        DEX
        RTS
---------------------------------
L9B57   STA $BD
        EOR $D7
        STA $D7
        LDA #$08
        STA $A3
-       ASL $BD
        LDA $01
        AND #$F7
        JSR L9B79
        LDX #$11
        NOP
        ORA #$08
        JSR L9B79
        LDX #$0E
        DEC $A3
        BNE -
        RTS
---------------------------------
L9B79   DEX
        BNE L9B79
        BCC +
        LDX #$0B
-       DEX
L9B81   BNE -
+       STA $01
        RTS
; ----------------------------------------------
; - $9B86 ←L -----------------------------------
; ----------------------------------------------
CMD_←L
        LDX #$00
        !by $2c
; ----------------------------------------------
; - $9B89 ←V -----------------------------------
; ----------------------------------------------
CMD_←V
        LDX #$01
        JSR ROM_ON
        LDY CBM_TXTTAB
        LDA CBM_TXTTAB+1
        STX $0A
        STX $93
        STY $C3
        STA $C4
        JSR $E1D4
        JSR L9BA6
        JSR $E17A
        JMP CBM_WARMSTART
---------------------------------
L9BA6   JSR L9C05
        LDA $AB
        CMP #$02
        BEQ +
        CMP #$01
        BNE L9BA6
        LDA $B9
        BEQ ++
+       LDA $033C
        STA $C3
        LDA $033D
        STA $C4
++      JSR $F750
        JSR CBM_BSTOP
        LDY $B7
        BEQ +
-       DEY
        LDA ($BB),Y
        CMP $0341,Y 
        BNE L9BA6
        TYA
        BNE -
+       STY $90
        JSR $F5D2
        LDA $033E
        SEC
        SBC $033C
        PHP
        CLC
        ADC $C3
        STA $AE
        LDA $033F
        ADC $C4
        PLP
        SBC $033D
        STA $AF
        JSR L9C1A
        LDA $BD
        EOR $D7
        ORA $90
        BEQ +
        LDA #$FF
        STA $90
+       JMP $F5A9
---------------------------------
L9C05   JSR L9C53
        CMP #$00
        BEQ L9C05
        STA $AB
-       JSR L9C81
        STA ($B2),Y
        INY
        CPY #$C0
        BNE -
        BEQ L9C47
L9C1A   JSR L9C53
L9C1D   JSR L9C81
        CPY $93
        BNE +
        STA ($C3),Y
+       CMP ($C3),Y
        BEQ +
        STX $90
+       EOR $D7
        STA $D7
        INC $C3
        BNE +
        INC $C4
+       LDA $C3
        CMP $AE
        LDA $C4
        SBC $AF
        BCC L9C1D
        JSR L9C81
        JSR L9B23
        INY
L9C47   STY $C0
        CLI
        CLC
        LDA #$00
        STA $02A0
        JMP $FC93
---------------------------------
L9C53   JSR $F817
        JSR L9B23
        STY $D7
        LDA #$07
        STA $DD06
        LDX #$01
--      JSR L9C94
        ROL $BD
        LDA $BD
        CMP #$02
        BNE --
        LDY #$09
-       JSR L9C81
        CMP #$02
        BEQ -
-       CPY $BD
        BNE --
        JSR L9C81
        DEY
        BNE -
        RTS
---------------------------------
L9C81   LDA #$08
        STA $A3
-       JSR L9C94
        ROL $BD
        NOP
        NOP
        NOP
        DEC $A3
        BNE -
        LDA $BD
        RTS
---------------------------------
L9C94   LDA #$10
-       BIT $DC0D
        BEQ -
        LDA $DD0D
        STX $DD07
        PHA
        LDA #$19
        STA $DD0F
        PLA
        LSR
        LSR
        RTS
; ----------------------------------------------
; - $9CAB ←R -----------------------------------
; ----------------------------------------------
CMD_←R
        LDA #$00
        !by $2c
; ----------------------------------------------
; - $9CAE ←M -----------------------------------
; ----------------------------------------------
CMD_←M
        LDA #$FF
        PHA
        JSR ROM_ON
        JSR $E1D4
        LDA #$00
        STA $0A
        STA $93
        LDX CBM_TXTTAB
        LDY CBM_TXTTAB+1
        PLA
        PHA
        BEQ +
        SEC
        LDA CBM_VARTAB
        SBC #$02
        TAX
        LDA CBM_VARTAB+1
        SBC #$00
        TAY
+       STX $C3
        STY $C4
        JSR L9BA6
        JSR CBM_READST
        AND #$BF
        BNE L9CF7
        PLA
        BNE L9CF4
        STX CBM_VARTAB
        STY CBM_VARTAB+1
        STA $CA5E
        STA $CAAF
        JSR CBM_LNKPRG
        JSR L9EEB
        JMP $A871
---------------------------------
L9CF4   JMP CMD_OLD
---------------------------------
L9CF7   JMP L9811
; ----------------------------------------------
; - $9CFA COMSHIFT -----------------------------
; ----------------------------------------------
CMD_COMSHIFT
        JSR LBD53                       ; check the input for 'ON' or 'OFF'
        EOR #$80
        STA $0291
        RTS
; ----------------------------------------------
; - $9D03 RAPID --------------------------------
; ----------------------------------------------
CMD_RAPID
        JSR LBD53                       ; check the input for 'ON' or 'OFF'
        STA $028A
        RTS
; ----------------------------------------------
; - $9D0A SCREEN -------------------------------
; ----------------------------------------------
CMD_SCREEN
        JSR LBD53                       ; check the input for 'ON' or 'OFF'
        LDA $D011
        DEX
        BPL +
        AND #$EF
        !by $2c
+       ORA #$10
        STA $D011
        RTS
; ----------------------------------------------
; - $9D1C Start message ------------------------
; ----------------------------------------------

OWN_STARTMSG
!if SB = 87 {
L9D1C
        !by $93,$9c,$0d,$20,$20,$20,$20,$75
        !by $b3,$75,$69,$75,$b3,$75,$b3,$b2
        !by $75,$69,$b2,$20,$20,$20,$20,$20
        !by $20,$20,$20,$20,$20,$b2,$69,$75
        !by $69,$75,$b3,$b2,$75,$b3,$0d,$20
        !by $20,$20,$20,$6a,$69,$ab,$6b,$ab
        !by $20,$62,$20,$62,$ab,$b3,$62,$20
        !by $20,$20,$20,$ab,$63,$b3,$20,$20
        !by $20,$ab,$b3,$ab,$b3,$6a,$69,$62
        !by $62,$0d,$20,$20,$20,$20,$ab,$6b
        !by $b1,$20,$6a,$b3,$6a,$b3,$b1,$62
        !by $62,$ad,$b3,$20,$20,$20,$20,$20
        !by $20,$20,$20,$20,$b1,$6b,$62,$62
        !by $ab,$6b,$b1,$6a,$b3,$0d,$0d,$0d
        !by $05
        !pet "    by michael stoerch & lars george",$0d,$0d,$1f
        !pet "      (c) 1987 by markt & technik",$0d,$0d,$90
        !by $20,$20,$20,$20,$20,$20,$20,$20
        !by $20
}
!if SB = 93 {
L9D1C   !by $93,$90,$0D
        !pet "    *** commodore 64 expansion *** ",$0D
        !pet "    special basic for all c64-users"
        !pet "                                    "
        !by $91,$0d,$90
        !pet "    by michael stoerch & lars george ",$0d,$90
        !pet "      (c) 1993 by markt & technik",$0d,$0d,$90
        !pet "         "
}
        !by $00,$00,$00,$00,$00,$00,$00,$00,$00

---------------------------------
L9DEA   JSR L85A1       ; CBM_CHKCOM
; ----------------------------------------------
; - $9DED LOCAL --------------------------------
; ----------------------------------------------
CMD_LOCAL
        LDA $CA28
        LDX $CA29
        CPX #$DF
        BCC ++
        BEQ +
-       JMP LABD2
---------------------------------
+       CMP #$F9
        BCS -
++      STA $FB
        STX $FC
        JSR L85B9                       ; CBM_PTRGET
        SEI
        LDA #$3C
        STA $01
        LDY #$03
        LDA $0D
        BNE +
        DEY
        LDA $0E
        BNE +
        LDY #$05
+       TYA
        STA ($FB),Y
        DEY
        TAX
-       LDA ($47),Y
        STA ($FB),Y
        DEY
        BPL -
        INY
        TXA
        SEC
        ADC $FB
        STA $FB
        BCC +
        INC $FC
+       LDA $47
        STA ($FB),Y
        JSR INCFB_FC
        LDA $48
        STA ($FB),Y
        JSR INCFB_FC
        LDA $FB
        LDX $FC
        STA $CA28
        STX $CA29
        JSR LB617
        JSR CBM_CHRGOT
        BNE L9DEA
        RTS
---------------------------------
L9E51   JSR L85A1       ; CBM_CHKCOM
; ----------------------------------------------
; - $9E54 GLOBAL -------------------------------
; ----------------------------------------------
CMD_GLOBAL
        LDA $CA28
        LDX $CA29
        STA $FB
        STX $FC
        JSR L85B9                       ; CBM_PTRGET
        SEI
        LDA #$3C
        STA $01
        LDY #$00
L9E68   LDX $FC
        LDA $FB
        BNE +
        CPX #$D8
        BNE +
        JSR LB617
        LDX #$2A                        ; UNKNOWN VARIABLE
        JMP PRINTERR
---------------------------------
+       JSR L9EE2
        LDA ($FB),Y
        JSR L9EE2
        CMP $48
        BNE +
        LDA ($FB),Y
        CMP $47
        BEQ ++
+       JSR L9EE2
        SEC
        LDA $FB
        SBC ($FB),Y
        STA $FB
        BCS L9E68
        DEC $FC
        BCC L9E68
++      JSR L9EE2
        LDA ($FB),Y
        TAY
        DEY
        ADC #$02
        PHA
        SEC
        EOR #$FF
        ADC $CA28
        STA $CA28
        BCS L9EB4
        DEC $CA29
L9EB4   JSR L9EE2
        LDX #$00
        LDA ($FB,X)
        STA ($47),Y
        DEY
        BPL L9EB4
        PLA
        TAY
-       LDA ($FB),Y
        STA ($FB,X)
        JSR INCFB_FC
        LDA $FC
        CMP $CA29
        BCC -
        LDA $FB
        CMP $CA28
        BCC -
        JSR LB617
        JSR CBM_CHRGOT
        BEQ ++
        JMP L9E51
---------------------------------
L9EE2   LDX $FB
        BNE +
        DEC $FC
+       DEC $FB
++      RTS
---------------------------------
L9EEB   LDY #$D8
        STY $CA29
        LDY #$00
        STY $CA35
        STY $CA28
L9EF8   RTS
---------------------------------

ERR42   !pet "unknown variablE" 

; ----------------------------------------------
; - $9F09 LOMEM --------------------------------
; ----------------------------------------------
CMD_LOMEM
        LDX #$00
L9F0B   !by $2C
; ----------------------------------------------
; - $9F0C HIMEM --------------------------------
; ----------------------------------------------
CMD_HIMEM
        LDX #$0C
        STX $02
        JSR L85D3                       ; CBM_FRMNUM,CBM_GETADR
        LDX $02
        STY CBM_TXTTAB,X 
        STA CBM_TXTTAB+1,X 
        JSR ROM_ON
        TXA
        BNE L9F2A
        DEC CBM_TXTTAB+1
        LDY #$FF
        STA (CBM_TXTTAB),Y
        INC CBM_TXTTAB+1
        JMP $A646
---------------------------------
L9F2A   JMP CBM_CLR
; ----------------------------------------------
; - $9F2D Go 64 --------------------------------
; ----------------------------------------------
CMD_GO64
        LDX #$13
-       LDA L9F69,X 
        JSR CBM_CHROUT
        DEX
        BPL -
-       JSR $F13E
        CMP #$4E
        BEQ L9EF8
        CMP #$59
        BNE -
        SEI
        LDA #$3C
        STA $01
        LDX #$13
-       LDA L9F55,X 
        STA $02,X 
        DEX
        BPL -
        JMP $0002
---------------------------------
L9F55   LDA #$00
-       STA $07E8
        INC $05
        BNE -
        INC $06
        BNE -
        LDA #$37
        STA $01
        JMP $FCE2
---------------------------------

L9F69   !pet $0d,"? n/y erus uoy era",$0d

; ----------------------------------------------
; - $9F7D GRCOL --------------------------------
; ----------------------------------------------
CMD_GRCOL
        LDA #$CC
        JSR LAFA5
        JSR L86BA                       ; CBM_CHKCOM, get byte, and check for $00 - $0f
        TXA
        ASL
        ASL
        ASL
        ASL
        PHA
        JSR L86BA                       ; CBM_CHKCOM, get byte, and check for $00 - $0f
        PLA
        ORA $65
        JMP LB002
; ----------------------------------------------
; - $9F94 [[ -----------------------------------
; ----------------------------------------------
CMD_SQBROPN
        TAX
        BNE L9FAD
-       LDY #$02
        LDA (CBM_TXTPTR),Y
        BEQ L9FE9
        JSR INC7A_7B
        JSR INC7A_7B
        JSR L8587                       ; LDA($7A+1),y
        STA $39
        JSR L8587                       ; LDA($7A+1),y
        STA $3A
L9FAD   JSR L8587                       ; LDA($7A+1),y
        BEQ -
        CMP #$64
        BNE L9FAD
        JSR L8587                       ; LDA($7A+1),y
        CMP #$60
        BNE L9FAD
        JMP CBM_CHRGET
; ----------------------------------------------
; - $9FC0 BCKGND -------------------------------
; ----------------------------------------------
CMD_BCKGND
        BEQ +
        JSR L86BD                       ; get byte, and check for $00 - $0f
        STX $D021
        JSR L86BA                       ; CBM_CHKCOM, get byte, and check for $00 - $0f
        STX $D022
        JSR L86BA                       ; CBM_CHKCOM, get byte, and check for $00 - $0f
        STX $D023
        JSR L86BA                       ; CBM_CHKCOM, get byte, and check for $00 - $0f
        STX $D024
        LDA $D011
        ORA #$40
        BNE ++
+       LDA $D011
        AND #$BF
++      STA $D011
; ----------------------------------------------
; - $9FE9 ]] -----------------------------------
; ----------------------------------------------
CMD_SQBRCLS
L9FE9   RTS
---------------------------------
L9FEA   STY $F7
        JSR L8578
        LDY $F7
L9FF1   RTS
---------------------------------
L9FF2   BCC L9FF1
        PHA
        JSR ROM_ON
        PLA
        JMP CBM_EREXIT
---------------------------------

L9FFC   !by $00,$00,$00,$00
LA000   !by $55,$00

CMDS
LA002   !pet "ypoS"
        !pet "penX"
        !pet "penY"
        !pet "inkeY"
        !pet "errlN"
        !pet "errN"
        !pet "err",$a4
        !pet "asciI"
        !pet "bsC"
        !pet "deC"
        !pet "hex",$a4
        !pet "bin",$a4
        !pet "roW"
        !pet "duP"
        !pet "inserT"
        !pet "insT"
        !pet "placE"
        !pet "char",$a4
        !pet "sprite",$a4
        !pet "usinG"
        !pet "bY"
        !pet "deeK"
        !pet "ceeK"
        !pet "checK"
        !pet "rooT"
        !pet "rounD"
        !pet "evaL"
        !pet "exoR"
        !pet "joY"
        !pet "bumP"
        !pet "tesT"
        !by $83
        !pet "autO"
        !by $83
        !pet "renuM"
        !pet "deletE"
        !pet "olD"
        !pet "tracE"
        !pet "stracE"
        !pet "monitoR"
        !pet "seT"
        !by $83
        !by $83
        !pet "dumP"
        !by $83
        !pet "matriX"
        !by $83
        !pet "finD"
        !pet "keY"
        !pet "shoW"
        !pet "ofF"
        !pet "delaY"
        !pet "pagE"
        !pet "memorY"
        !pet "elsE"
        !pet "begiN"
        !pet "belsE"
        !pet "benD"
        !pet "repeaT"
        !by $83
        !by $83
        !by $83
        !by $83
        !pet "untiL"
        !pet "looP"
        !pet "exiT"
        !pet "end looP"
        !pet "proC"
        !pet "exeC"
        !pet "calL"
        !pet "end proC"
        !pet "sgotO"
        !pet "poP"
        !pet "reseT"
        !pet "case oF"
        !pet "endcasE"
        !pet "wheN"
        !pet "otherwisE"
        !pet "helP"
        !pet "on erroR"
        !pet "no erroR"
        !pet "resumE"
        !pet "fetcH"
        !pet "getkeY"
        !pet "locatE"
        !pet "centeR"
        !pet "chrhI"
        !pet "chrlO"
        !pet "clS"
        !pet "spelL"
        !pet "presS"
        !pet "coloR"
        !pet "fcoL"
        !by $83
        !pet "fchR"
        !pet "filL"
        !pet "scrinV"
        !pet "scopY"
        !by $83
        !by $83
        !pet "changE"
        !pet "suP"
        !pet "sdowN"
        !pet "srighT"
        !pet "slefT"
        !pet "flasH"
        !pet "dloaD"
        !pet "dsavE"
        !pet "dverifY"
        !pet "dmergE"
        !pet "chaiN"
        !pet "gloaD"
        !pet "gsavE"
        !pet "bloaD"
        !pet "bsavE"
        !pet "cloaD"
        !pet "csavE"
        !pet "diR"
        !pet "disK"
        !pet "erroR"
        !pet "mergE"
        !pet "headeR"
        !pet $5f,"L"
        !pet $5f,"S"
        !pet $5f,"V"
        !pet $5f,"R"
        !pet $5f,"M"
;page 2 commands
        !pet "typE"
        !pet "textcopY"
        !pet "graphcopY"
        !pet "nchaR"
        !pet "switcH"
        !pet "chrinV"
        !pet "twisT"
        !pet "mirX"
        !pet "mirY"
        !pet "chaR"
        !pet "chrcopY"
        !pet "chroR"
        !pet "chranD"
        !pet "scrolL"
        !pet "emptY"
        !pet "defmoB"
        !pet "multI"
        !pet "mobeX"
        !pet "cleaR"
        !pet "mobseT"
        !pet "mmoB"
        !pet "movE"
        !pet "clrviC"
        !pet "creatE"
        !pet "moB"
        !pet "turnmoB"
        !pet "blcopY"
        !pet "bloR"
        !pet "blanD"
        !pet "erasE"
        !pet "blinV"
        !by $83
        !pet "reflectX"
        !by $83
        !pet "reflectY"
        !pet "scrmoB"
        !pet "hireS"
        !pet "graphiC"
        !pet "hicoL"
        !pet "nrM"
        !pet "ploT"
        !by $83
        !by $83
        !pet "draW"
        !by $83
        !pet "reC"
        !by $83
        !pet "boX"
        !pet "circlE"
        !pet "arC"
        !pet "painT"
        !pet "gshapE"
        !pet "sshapE"
        !pet "gblocK"
        !pet "sblocK"
        !pet "texT"
        !pet "windoW"
        !pet "reverS"
        !pet "scnclR"
        !by $83
        !by $83
        !by $83
        !by $83
        !pet "grcoL"
        !pet "voL"
        !pet "envelopE"
        !pet "wavE"
        !pet "sounD"
        !pet "pulsE"
        !pet "clrsiD"
        !pet "musiC"
        !pet "plaY"
        !pet "beeP"
        !pet "swaP"
        !pet "dokE"
        !pet "biT"
        !pet "kilL"
        !pet "breaK"
        !pet "varY"
        !pet "fiX"
        !pet "pausE"
        !pet "commandS"
        !pet "comshifT"
        !by $83
        !pet "rapiD"
        !pet "screeN"
        !pet "globaL"
        !pet "locaL"
        !pet "go 6",$b4
        !pet "lomeM"
        !pet "himeM"
        !pet "clreoL"
        !pet "bckgnD"
        !by $83
        !pet "[",$db    ;[[
        !pet "]",$dd    ;]]
        !by $a4         ;"$"
        !by $a5         ;"%"
        
        !by $00,$00,$00,$00,$00,$00,$00,$00
        !by $00,$00,$00,$00,$00,$00,$00,$00
        !by $00

---------------------------------
LA3F4   JSR CBM_LOAD
        JMP L9FF2
---------------------------------
LA3FA   JSR CBM_SAVE
        JMP L9FF2
---------------------------------
; ----------------------------------------------
; - $A400 ERRLN --------------------------------
; ----------------------------------------------
CMD_ERRLN
        LDA $CA16                       ; load ERRLN line number
        LDX $CA17
        JMP L8A0F                       ; ouput
; ----------------------------------------------
; - $A409 PENX ---------------------------------
; ----------------------------------------------
CMD_PENX
        LDA $D013
        JMP L8A0D
; ----------------------------------------------
; - $A40F PENY ---------------------------------
; ----------------------------------------------
CMD_PENY
        LDA $D014
        JMP L8A0D
; ----------------------------------------------
; - $A415 INKEY --------------------------------
; ----------------------------------------------
CMD_INKEY
        JSR $F13E
        LDX #$08
-       CMP FKEY_CODE-1,X 
        BEQ +
        DEX
        BNE -
+       JMP L8A0C
---------------------------------
FKEY_CODE
   !by $85,$89,$86,$8A,$87,$8B,$88,$8C
; ----------------------------------------------
; - $A42D ASCII --------------------------------
; ----------------------------------------------
CMD_ASSCII
        JSR L8598                       ; CBM_GETBYT
        TXA
        JSR LA439
        JMP L8A0D
---------------------------------
LA437   STA $FA
LA439   AND #$7F
        CMP #$20
        BCC ++
        CMP #$60
        BCS +
        CMP #$40
        BCC +++
        ORA #$20
        !by $2c
+       EOR #$C0
        !by $2c
++      ORA #$40
+++     RTS
---------------------------------
-       JMP L8A26                       ; ILLEGAL STRING LENGTH
; ----------------------------------------------
; - $A453 DEC ----------------------------------
; ----------------------------------------------
CMD_DEC
        JSR L85AA                       ; CBM_FRMEV,CBM_FRESTR
LA456   CMP #$05
        BCC ++
        CMP #$08
        BNE -
        LDY #$07
-       LDA ($22),Y
        CMP #$31
        BEQ +
        CMP #$30
        BNE +++
        CLC
+       TXA
        ROR
        TAX
        DEY
        BPL -
        JMP L8A0C
---------------------------------
++      STA $24
        LDY #$00
        STY $62
        STY $63
LA47C   CPY $24
        BEQ LA4A3
        LDA ($22),Y
        INY
        LDX #$0F
-       CMP HEXCHARS,X 
        BEQ +
        DEX
        BPL -
+++     LDX #$28                        ; WRONG STRING
        JMP PRINTERR
---------------------------------
+       TXA
        ASL
        ASL
        ASL
        ASL
        LDX #$04
-       ASL
        ROL $63
        ROL $62
        DEX
        BNE -
        BEQ LA47C
LA4A3   JMP L8A13
---------------------------------
HEXCHARS
        !pet "0123456789abcdef"
---------------------------------
; ----------------------------------------------
; - $A4B6 BIN$ ---------------------------------
; ----------------------------------------------
CMD_BIN_STR
        JSR L8598                       ; CBM_GETBYT
        STX $64
        LDA #$08
        JSR L85C5                       ; CBM_STRSPA
        LDY #$07
-       LDA #$18
        LSR $64
        ROL
        STA ($62),Y
        DEY
        BPL -
        JMP L8A20
; ----------------------------------------------
; - $A4CF HEX$ ---------------------------------
; ----------------------------------------------
CMD_HEX_STR
        LDA $14
        PHA
        LDA $15
        PHA
        JSR L85D3                       ; CBM_FRMNUM,CBM_GETADR
        LDA #$04
        JSR L85C5                       ; CBM_STRSPA
        LDY #$03
-       TYA
        LSR
        EOR #$01
        TAX
        LDA $14,X 
        PHA
        TYA
        AND #$01
        BNE +
        PLA
        LSR
        LSR
        LSR
        LSR
        !by $24
+       PLA
        AND #$0F
        TAX
        LDA HEXCHARS,X 
        STA ($62),Y
        DEY
        BPL -
        PLA
        STA $15
        PLA
        STA $14
        JMP L8A20
; ----------------------------------------------
; - $A507 DEEK ---------------------------------
; ----------------------------------------------
CMD_DEEK
        LDA $14
        PHA
        LDA $15
        PHA
        JSR L85D3                       ; CBM_FRMNUM,CBM_GETADR
        LDY #$01
        LDA ($14),Y
        TAX
        DEY
        LDA ($14),Y
        TAY
        PLA
        STA $15
        PLA
        STA $14
        TYA
        JMP L8A0F
; ----------------------------------------------
; - $A523 DUP ----------------------------------
; ----------------------------------------------
CMD_DUP
        JSR L85AA                       ; CBM_FRMEV,CBM_FRESTR
        TAX
        LDA $22
        PHA
        TYA
        PHA
        TXA
        PHA
        JSR L858F                       ; CBM_COMBYT
        STX $59
        STX $56
        LDX #$00
        STX $5A
        PLA
        PHA
        STA $5B
        JSR LA560
        LDA $57
        LDX $58
        BNE LA5BD
        JSR L85C5                       ; CBM_STRSPA
        TAY
        PLA
        TAX
        PLA
        STA $23
        PLA
        STA $22
        TYA
        BEQ +
-       TXA
        JSR L8A2B
        DEC $56
        BNE -
+       JMP L8A20
LA560   LDA #$00
        STA $57
        STA $58
        LDY #$08
        CLC
-       ROL $5B
        BCC +
        CLC
        LDA $57
        ADC $59
        STA $57
        LDA $58
        ADC $5A
        STA $58
+       DEY
        BEQ +
        ROL $57
        ROL $58
        BCC -
+       RTS
; ----------------------------------------------
; - $A584 INSERT -------------------------------
; ----------------------------------------------
CMD_INSERT
        LDA #$00
        !by $2c
; ----------------------------------------------
; - $A587 INST ---------------------------------
; ----------------------------------------------
CMD_INST
        LDA #$FF
        PHA
        JSR L85AA                       ; CBM_FRMEV,CBM_FRESTR
        PHA
        TXA
        PHA
        TYA
        PHA
        JSR L858F                       ; CBM_COMBYT
        TXA
        BEQ LA5C0
        DEX
        TXA
        PHA
        JSR L85A1                       ; CBM_CHKCOM
        JSR L85AA                       ; CBM_FRMEV,CBM_FRESTR
        STA $69
        STX $6A
        STY $6B
        LDX #$03
-       PLA
        STA $6C,X 
        DEX
        BPL -
        PLA
        PHA
        BNE +
        LDA $69
        CLC
        ADC $6C
        TAX
        LDA $69
        BCC ++
LA5BD   JMP L8670                       ; STRING TO LONG
---------------------------------
LA5C0   JMP L867E                       ; ILLEGAL QUANTITY
---------------------------------
+       LDA $69
        TAX
        SEC
        SBC $6C
        BCC LA5C0
++      SEC
        SBC $6F
        BCC LA5C0
        TXA
        JSR L85C5                       ; CBM_STRSPA
        LDA $6A
        LDX $6B
        STA $22
        STX $23
        LDA $6F
        JSR L8A2B
        LDA $6D
        LDY $6E
        STA $22
        STY $23
        LDA $6C
        JSR L8A2B
        PLA
        BNE +
        STA $6C
+       CLC
        LDA $6A
        ADC $6F
        BCC +
        INX
+       CLC
        ADC $6C
        STA $22
        BCC +
        INX
+       STX $23
        LDA $69
        SEC
        SBC $6C
        SBC $6F
        JSR L8A2B
        JMP L8A20
; ----------------------------------------------
; - $A612 BY -----------------------------------
; ----------------------------------------------
CMD_BY
        JSR L8598                       ; CBM_GETBYT
        TXA
        PHA
        JSR L858F                       ; CBM_COMBYT
        PLA
        CMP #$28
        BCS LA5C0
        CPX #$19
        BCS LA5C0
        STA $D3
        STX $D6
        JSR $E56C
        LDA #$00
        STA $61
        JMP L8A20
; ----------------------------------------------
; - $A631 CEEK ---------------------------------
; ----------------------------------------------
CMD_CEEK
        LDA $14
        PHA
        LDA $15
        PHA
        JSR L85D3                       ; CBM_FRMNUM,CBM_GETADR
        SEI
        LDA $01
        PHA
        LDA #$3C
        STA $01
        LDY #$00
        LDA ($14),Y
        TAX
        PLA
        STA $01
        CLI
        PLA
        STA $15
        PLA
        STA $14
        JMP L8A0C
; ----------------------------------------------
; - $A654 BSC ----------------------------------
; ----------------------------------------------
CMD_BSC
        JSR L8598                       ; CBM_GETBYT
        TXA
        JSR LA65E
        JMP L8A0D
---------------------------------
LA65E   CMP #$FF
        BEQ +
        CMP #$C0
        BCS ++
        TAX
        BMI +++
        CMP #$60
        BCS ++++
        CMP #$40
        BCC +++++
        AND #$BF
        !by $2c
+       LDA #$5E
        !by $2c
++      AND #$7F
        !by $2c
+++     EOR #$C0
        !by $2c
++++    AND #$DF
+++++   RTS
---------------------------------
; ----------------------------------------------
; - $A680 ROW ----------------------------------
; ----------------------------------------------
CMD_ROW
        JSR L8598                       ; CBM_GETBYT
        TXA
        PHA
        JSR L858F                       ; CBM_COMBYT
        PLA
        STA $24
        INX
        TXA
        PHA
        SEC
        SBC $24
        JSR L85C5                       ; CBM_STRSPA
        TAY
        BEQ +
        PLA
-       DEY
        SEC
        SBC #$01
        STA ($62),Y
        CMP $24
        BNE -
        JMP L8A20
---------------------------------
+       JMP L8670                       ; STRING TO LONG
; ----------------------------------------------
; - $A6A8 JOY ----------------------------------
; ----------------------------------------------
CMD_JOY
        JSR L8598                       ; CBM_GETBYT
        DEX
        CPX #$02
        BCS LA6D9
        TXA
        EOR #$01
        TAX
        LDA $DC00,X 
        TAY
        AND #$10
        PHP
        TYA
        AND #$0F
        LDX #$08
-       CMP LA6D1-1,X 
        BEQ +
        DEX
        BNE -
+       TXA
        PLP
        BNE +
        ORA #$80
+       JMP L8A0D
---------------------------------
LA6D1   !by $0E,$06,$07,$05,$0D,$09,$0B,$0A

LA6D9   JMP L867E                       ; ILLEGAL QUANTITY
---------------------------------
LA6DC   JSR L8598                       ; CBM_GETBYT

; check if a device exists
LA6DF   LDA #$01
        LDX #$0E
        LDY #$A0
        JSR CBM_SETNAM
        LDA #$4D
        LDY #$0F
        LDX $65
        JSR CBM_SETLFS
        JSR CBM_OPEN
        BCC +
        LDA #$00
        !by $2c
+       LDA #$01
        PHA
        LDA #$4D
        JSR CBM_CLOSE
        PLA
        RTS
; ----------------------------------------------
; - $A703 PLACE --------------------------------
; ----------------------------------------------
CMD_PLACE
        JSR L85AA                       ; CBM_FRMEV,CBM_FRESTR
        PHA
        TXA
        PHA
        TYA
        PHA
        JSR L85A1                       ; CBM_CHKCOM
        JSR L85AA                       ; CBM_FRMEV,CBM_FRESTR
        PHA
        JSR CBM_CHRGOT
        CMP #$29
        BEQ ++
        TYA
LA71A   PHA
        TXA
        PHA
        JSR L858F                       ; CBM_COMBYT
        TXA
        BNE +
        JMP L867E                       ; ILLEGAL QUANTITY
---------------------------------
+       DEX
        STX $24
        PLA
        CLC
        ADC $24
        STA $22
        PLA
        ADC #$00
        STA $23
        !by $2C
++      LDX #$00
        LDY #$03
-       PLA
        STA $0061,Y 
        DEY
        BPL -
LA740   TXA
        CLC
        ADC $61
        BCS LA765
        CMP $64
        BEQ +
        BCS LA765
+       INX
        LDY $61
-       TYA
        BEQ +
        DEY
        LDA ($62),Y
        CMP #$23
        BEQ -
        CMP ($22),Y
        BEQ -
        INC $22
        BNE LA740
        INC $23
        BNE LA740
LA765   LDX #$00
+       JMP L8A0C
; ----------------------------------------------
; - $A76A BUMP ---------------------------------
; ----------------------------------------------
CMD_BUMP
        LDA $02
        PHA
        LDA $D01E
        LDA $D01F
        JSR L86C7                       ; get byte into Y, set bit 0 to 7 in accu, and save to $02
        LDX $A2
        INX
        INX
-       CPX $A2
        BNE -
        JSR CBM_CHRGOT
        TAX
        LDA $D01F
        AND $02
        CPX #$29
        BEQ +
        LDA $02
        PHA
        JSR L85A1                       ; CBM_CHKCOM
        JSR L86C7                       ; get byte into Y, set bit 0 to 7 in accu, and save to $02
        LDA $D01E
        STA $62
        PLA
        AND $62
        BEQ +
        LDA $02
        AND $62
+       TAX
        BEQ +
        LDX #$01
+       PLA
        STA $02
        JMP L8A0C
; ----------------------------------------------
; - $A7AD get parameter (b,d) for block usage --
; ----------------------------------------------
GET_BLKPARAM
        JSR L8598                       ; CBM_GETBYT
        LDA #$00
        STA $15
        STX $14
        LDX #$06
-       ASL $14
        ROL $15
        DEX
        BNE -
        JSR L858F                       ; CBM_COMBYT
        CPX #$03
        BCC +
LA7C6   JMP L867E                       ; ILLEGAL QUANTITY
---------------------------------
+       TXA
        BEQ +
        LDA #$40
-       ORA $15
        STA $15
        DEX
        BEQ +
        LDA #$80
        BNE -
+       RTS
; ----------------------------------------------
; - $A7DA SPRITE$ ------------------------------
; ----------------------------------------------
CMD_SPRIT_STR
        LDA $14
        PHA
        LDA $15
        PHA
        JSR GET_BLKPARAM
        JSR L858F                       ; CBM_COMBYT
        DEX
        CPX #$15
        BCS LA7C6
        TXA
        STA $62
        ASL
        ADC $62
        ADC $14
        STA $14
        JSR L858F                       ; CBM_COMBYT
        STX $25
        LDA #$0C
        DEX
        BPL +
        ASL
+       JSR L85C5                       ; CBM_STRSPA
        TAY
        DEY
        STY $22
        LDY #$02
--      STY $23
        JSR L8699                       ; switch off kernal
        LDA ($14),Y
        STA $24
        JSR L8691                       ; switch on kernel
        LDX #$08
-       LDY $22
        LSR $24
        LDA $25
        BEQ +++
        DEX
        BCC ++
        ROR $24
        LDA #$2F
        BCC +
        LDA #$3D
        BCS +
++      ROR $24
+++     LDA #$2E
        BCC +
        LDA #$2A
+       STA ($62),Y
        DEC $22
        DEX
        BNE -
        LDY $23
        DEY
        BPL --
        PLA
        STA $15
        PLA
        STA $14
        JMP L8A20
; ----------------------------------------------
; - $A849 USING --------------------------------
; ----------------------------------------------
CMD_USING
        JSR L85AA                       ; CBM_FRMEV,CBM_FRESTR
        TAX
        BEQ +
        TAY
        DEY
        LDA ($22),Y
        CMP #$2E
        BNE ++
        DEX
        BNE +++
+       JMP L8A26                       ; ILLEGAL STRING LENGTH
---------------------------------
-       DEY
        LDA ($22),Y
        CMP #$2E
        BEQ +++
++      TYA
        BNE -
        TXA
        TAY
+++     INX
        TXA
        PHA
        TYA
        PHA
        JSR L85A1                       ; CBM_CHKCOM
        JSR L8675
        JSR L863A
        PLA
        STA $25
        PLA
        JSR L85C5                       ; CBM_STRSPA
        LDX #$FF
-       INX
        LDA $0101,X 
        BEQ +
        CMP #$2E
        BNE -
+       LDY #$FF
        TXA
        SEC
        SBC $25
        TAX
        BCS +
        LDA #$20
-       INY
        STA ($62),Y
        INX
        BNE -
+       INY
        LDA $0100
-       STA ($62),Y
        INX
        INY
        LDA $0100,X 
        BEQ +
        CMP #$2E
        BNE -
+       CPY $61
        BEQ ++
        AND #$FF
        BNE +
        STA $0101,X 
+       LDA #$2E
        STA ($62),Y
        INY
-       LDA $0101,X 
        BNE +
        STA $0102,X 
        LDA #$30
+       STA ($62),Y
        INX
        INY
        CPY $61
        BNE -
++      JMP L8A20
; ----------------------------------------------
; - $A8D1 CHAR$ --------------------------------
; ----------------------------------------------
CMD_CHAR_STR
        LDA $14
        PHA
        LDA $15
        PHA
        LDA $FB
        PHA
        LDA $FC
        PHA
        JSR LA91A
        JSR L8598                       ; CBM_GETBYT
        DEX
        CPX #$08
        BCS LA917
        TXA
        TAY
        JSR L86AA
        LDA ($14),Y
        STA $FB
        JSR L86B2
        LDA #$08
        JSR L85C5                       ; CBM_STRSPA
        LDY #$07
-       LDA #$2E
        LSR $FB
        BCC +
        LDA #$2A
+       STA ($62),Y
        DEY
        BPL -
        PLA
        STA $FC
        PLA
        STA $FB
        PLA
        STA $15
        PLA
        STA $14
        JMP L8A20
---------------------------------
LA917   JMP L867E                       ; ILLEGAL QUANTITY
---------------------------------
LA91A   JSR GET_CHR_MOD
        JSR L858F                       ; CBM_COMBYT
        TXA
        BNE +
        SEC
        LDA $15
        SBC #$10
        STA $15
+       LDA $14
        LDX $15
        STA $FB
        STX $FC
        JMP L85A1                       ; CBM_CHKCOM
; ----------------------------------------------
; - $A935 ELSE , PROC --------------------------
; ----------------------------------------------
CMD_ELSE
CMD_PROC
LA935   JSR L8999                       ; get last single char
        BEQ +
-       JSR L8589                       ; get next single char
        BNE -
+       RTS
; ----------------------------------------------
; - $A940 BELSE --------------------------------
; ----------------------------------------------
CMD_BELSE
        LDX #$00
        JMP L894A
---------------------------------
LA945   !by $00,$00,$00,$00,$00,$00,$00,$00
LA94D   !by $00,$00,$00,$00,$00,$00,$00,$00
LA955   !by $00,$00,$00,$00,$00,$00,$00,$00
LA95D   !by $00,$00,$00,$00,$00,$00,$00,$00
LA965   !by $00,$00,$00,$00,$00,$00,$00,$00
LA96D   !by $00,$00,$00,$00,$00,$00
; ----------------------------------------------
; - $A973 TRACE --------------------------------
; ----------------------------------------------
; if nothing is insert, the single step will be switched off by putting a zero to $CA0E
; if a value is insert, it will be increase by one, and stored into $CA0F,
; additional the trace value will be loaded with 2
CMD_TRACE
        BEQ +                           ; branch if nothing insert
        JSR L86F1                       ; get byte and increase by one
        STX $CA0F                       ; store to flag
        LDA #$02                        ; load with 2, goto sta $CA0E
        !by $2c
+       LDA #$00                        ; load with 0, goto sta $CA0E
        !by $2c
; ----------------------------------------------
; - $A981 STRACE -------------------------------
; ----------------------------------------------
; switch on the single step by storing a 1 to $CA0E
CMD_STRACE
        LDA #$01                        ; load with 1
        STA $CA0E                       ; switch on single step
        RTS
---------------------------------
LA987   LDX #$0B                        ; SYNTAX ERROR
        JMP PRINTERR
; ----------------------------------------------
; - $A98C DELETE -------------------------------
; ----------------------------------------------
CMD_DELETE
        CMP #$AB
        BEQ LA9BA
        JSR L8607                       ; CBM_CHRGOT, CBM_LINGET
        JSR L861D
        LDA $5F
        LDX $60
        STA $FB
        STX $FC
        JSR CBM_CHRGOT
        CMP #$AB
        BNE LA987
        JSR CBM_CHRGET
        BNE +
        LDA CBM_VARTAB
        SEC
        SBC #$02
        STA $5F
        LDA CBM_VARTAB+1
        SBC #$00
        STA $60
        JMP LA9ED
---------------------------------
LA9BA   LDA CBM_TXTTAB
        LDX CBM_TXTTAB+1
        STA $FB
        STX $FC
        JSR CBM_CHRGET
+       JSR L8607                       ; CBM_CHRGOT, CBM_LINGET
        JSR L861D
        BCC +
        LDY #$00
        LDA ($5F),Y
        TAX
        INY
        LDA ($5F),Y
        STX $5F
        STA $60
+       INC CBM_VARTAB
        BNE +
        INC CBM_VARTAB+1
+       LDA $FC
        CMP $60
        BEQ +
        BNE ++
+       LDA $FB
        CMP $5F
++      BCS LAA04
LA9ED   LDY #$00
        LDX CBM_VARTAB+1
-       LDA ($5F),Y
        STA ($FB),Y
        JSR INCFB_FC
        INC $5F
        BNE +
        INC $60
+       CPX $60
        BEQ +
        BCS -
LAA04   JMP L8BB9                       ; part of OLD
---------------------------------
+       LDA CBM_VARTAB
        CMP $5F
        BCC LAA04
        BCS -
; ----------------------------------------------
; - $AA0F SET ----------------------------------
; ----------------------------------------------
CMD_SET
        JSR L85D3                       ; CBM_FRMNUM,CBM_GETADR
        STY $CA26
        STA $CA27
        RTS
; ----------------------------------------------
; - $AA19 DELAY --------------------------------
; ----------------------------------------------
CMD_DELAY
        JSR L86F1                       ; get byte and increase by one
        STX $CA22
        RTS
; ----------------------------------------------
; - $AA20 PAGE ---------------------------------
; ----------------------------------------------
CMD_PAGE
        BEQ +                           ; branch if nothing insert
        JSR L8598                       ; else, CBM_GETBYT
        !by $2c
+       LDX #$00                        ; zero for switch off page mode
        STX $CA21                       ; store PAGE mode
        RTS
; ----------------------------------------------
; - $AA2C KEY ----------------------------------
; ----------------------------------------------
CMD_KEY
        JSR L86C7                       ; get byte and check valid range
        DEY                             ; 0 - 7
        TYA                             ; transfer into accu
        ASL                             ;
        ASL                             ;
        ASL                             ; multiply with 32
        ASL                             ;
        ASL                             ;
        PHA                             ; save value
        JSR L85A1                       ; CBM_CHKCOM
        JSR L85AA                       ; CBM_FRMEV,CBM_FRESTR
        CMP #$20                        ; max char amount
        BCC +                           ; branch if ok
        JMP L8A26                       ; ILLEGAL STRING LENGTH
---------------------------------
+       STA $02                         ; store amount
        STX $FB                         ; store string pointer low byte
        STY $FC                         ; store string pointer high byte
        PLA                             ; get back multiplied value
        TAX                             ; transfer to x
        LDY #$00                        ; load y pointer with zero
-       CPY $02                         ; compare with char amount
        BEQ +                           ; branch if finished
        LDA ($FB),Y                     ; else copy string
        STA $CB00,X                     ; to F_Key buffer
        INX                             ; next x
        INY                             ; next y
        BNE -                           ; loop next char copy
+       LDA #$00                        ; store a zero 
        STA $CB00,X                     ; to the buffer end
        RTS
; ----------------------------------------------
; - $AA61 SHOW ---------------------------------
; ----------------------------------------------
CMD_SHOW
        LDA #$31                        ; start key number
        STA $FB
        LDX #$00                        ; load f-key pointer
LAA67   STX $FC
; print keyX,"                          ; X is defined by the value in $FB
        LDY #$05                        ; char amount
-       LDA KEYCHARS,Y                  ; get char from table 
        CPY #$02                        ; if it is char no 2
        BNE +                           ; no, go on with print
        LDA $FB                         ; else load key number from $FB
+       JSR CBM_CHROUT                  ; print on screen
        DEY                             ; decrease char amount
        BPL -                           ; loop next char

        DEX                             ;
-       INX                             ; pointer for key string
        LDA $CB00,X                     ; get key string char
        BEQ +                           ; branch if it is last char in string
        JSR CBM_CHROUT                  ; else print char on screen
        CMP #$5F                        ; compare with $5F (return)
        BNE -                           ; loop if not
+       LDA #$22                        ; else load qoute
        JSR CBM_CHROUT                  ; and print on screen
        JSR P_RET                       ; print a return code
        INC $FB                         ; increase key number
        LDA $FC                         ; load f-key pointer
        CLC                             ;
        ADC #$20                        ; add to point to next f-key string
        STA $FC                         ; store it
        TAX                             ; set pointer in X
        BNE LAA67                       ; loop if it is not last
        RTS                             ; else finished
---------------------------------
KEYCHARS
        !pet $22,$2c,"0yek"
; ----------------------------------------------
; - $AAA3 OFF ----------------------------------
; ----------------------------------------------
; switches the f-key off by deleting the content in $CB00 to $CBFF
CMD_OFF
        LDX #$00
        TXA
-       STA $CB00,X 
        INX
        BNE -
LAAAC   RTS
; ----------------------------------------------
; - $AAAD FIND ---------------------------------
; ----------------------------------------------
CMD_FIND
        TAX                             ; the first search char
        BEQ LAAFC                       ; if nothing, print a return only
        LDA CBM_TXTTAB                  ; load basic start
        LDX CBM_TXTTAB+1
        STA $FB                         ; store
        STX $FC
        BNE +                           ; (jmp)
LAABA   JSR INCFB_FC                    ; inc. fb/fc , to low byte of next line address
+       JSR L8578                       ; inc. fb/fc, lda (fb),0, high byte of next line address
        BEQ LAAF7                       ; branch if found zero (end of basic)
        JSR L8578                       ; else inc. fb/fc, lda (fb),0
        STA $FD                         ; store as act. line number low byte
        JSR L8578                       ; inc. fb/fc, lda (fb),0
        STA $FE                         ; store as act. line number high byte
--      JSR L8578                       ; inc. fb/fc, lda (fb),0
        BEQ LAABA                       ; branch if it was end of act. line, go find in next line
        DEY                             ; need for next iny
-       INY                             ; next char
        LDA (CBM_TXTPTR),Y              ; load search char 
        BEQ +                           ; branch if no more search char available (found all)
        CMP #$23                        ; text place holder
        BEQ -                           ; skip it
        CMP ($FB),Y                     ; compare with char in text
        BEQ -                           ; branch if it matches, compare next search char
        BNE --                          ; (jmp) go set pointer to next char in memory

+       LDX $FD                         ; get low and
        LDA $FE                         ; high byte act. line no.
        JSR L85E2                       ; CBM_INTOUT

; print additonal spaces
-       INY                             ; holds the line number char amount
        JSR P_SPC                       ; print space
        CPY #$0A                        ;
        BNE -                           ; loop until 10

-       JSR L8578                       ; inc. fb/fc, lda (fb),0
        BNE -                           ; skip rest of line (until found a zero)
        BEQ LAABA                       ; (jmp) else it was zero, go find in next line
;  delete rest of input, to avoid syntax error
LAAF7   JSR L8587                       ; LDA($7A+1),y
        BNE LAAF7
LAAFC   JMP P_RET                       ; print return
; ----------------------------------------------
; - $AAFF MEMORY -------------------------------
; ----------------------------------------------
CMD_MEMORY
        LDA CBM_MEMSIZ                  ; Low Byte, highest BASIC RAM address / bottom of string stack 
        LDX CBM_MEMSIZ+1
        STA CBM_FRESPC                  ; Low Byte FRESPC, utility pointer for strings 
        STX CBM_FRESPC+1
        LDA #$00
        TAX
LAB0A   TAY                             ; pointer to act. char of string
        JSR P_RET                       ; output one return

-       LDA MEM_TXT,Y                   ; load char from message string
        BMI +                           ; branch if last char of string
        JSR CBM_CHROUT                  ; output to screen
        INY                             ; inc. pointer
        BNE -                           ; loop next char

+       AND #$7F                        ; convert char
        JSR CBM_CHROUT                  ; output to screen
        JSR P_SPC                       ; print space
        LDA #$3A                        ; ':'
        JSR CBM_CHROUT                  ; print to screen
        JSR P_SPC                       ; print space
        INY                             ; inc. MEM_TXT pointer
        TYA                             ; transfer to accu
        PHA                             ; save
        STX $02                         ; save x
        LDA CBM_TXTTAB+1,X              
        TAY
        LDA CBM_TXTTAB,X 
        TAX
        TYA
        JSR L85E2                       ; CBM_INTOUT
        JSR P_SPC
        LDA #$2D                        ; '-'
        JSR CBM_CHROUT
        JSR P_SPC
        LDX $02
        LDA CBM_VARTAB+1,X 
        TAY
        LDA CBM_VARTAB,X 
        TAX
        TYA
        JSR L85E2                       ; CBM_INTOUT
        JSR P_SPC
        LDA #$3D
        JSR CBM_CHROUT
        JSR P_SPC
        LDX $02
        SEC
        LDA CBM_VARTAB,X 
        SBC CBM_TXTTAB,X 
        PHA
        LDA CBM_VARTAB+1,X 
        SBC CBM_TXTTAB+1,X 
        TAY
        PLA
        TAX
        TYA
        JSR L85E2                       ; CBM_INTOUT
        PLA
        LDX $02
        INX
        INX
        CPX #$0A
        BNE LAB0A
        JMP P_RET
---------------------------------
MEM_TXT
        !pet "program ",$a0
        !pet "variableS"
        !pet "arrays  ",$a0
        !pet "free",$00
        !pet "    ",$a0
        !pet "strings ",$a0
; ----------------------------------------------
; - $ABA7 REPEAT -------------------------------
; ----------------------------------------------
CMD_REPEAT
        LDX #$51
        !by $2c
; ----------------------------------------------
; - $ABAA LOOP ---------------------------------
; ----------------------------------------------
CMD_LOOP
        LDX #$00
        STX $02
        LDA $CA5E,X 
        CMP #$14
        BCS LABD2
        INC $CA5E,X 
        ASL
        ASL
        ADC $02
        TAY
        LDA CBM_TXTPTR
        STA $CA5F,Y 
        LDA CBM_TXTPTR+1
        STA $CA60,Y 
        LDA $39
        STA $CA61,Y 
        LDA $3A
        STA $CA62,Y 
        RTS
---------------------------------
LABD2   LDX #$10                        ; OUT OF MEMORY
        JMP PRINTERR
; ----------------------------------------------
; - $ABD7 UNTIL --------------------------------
; ----------------------------------------------
CMD_UNTIL
        JSR L8675
        LDA $CAAF
        BEQ LAC0D
        LDX $61
        BEQ LABEF
        DEC $CAAF
        RTS
; ----------------------------------------------
; - $ABE7 END LOOP -----------------------------
; ----------------------------------------------
CMD_END_LOOP
        LDA $CA5E
        BEQ LAC10
        LDX #$00
        !by $2c
LABEF   LDX #$51
        STX $02
        ASL
        ASL
        ADC $02
        TAY
        LDA $CA5E,Y 
        STA $3A
        LDA $CA5D,Y 
        STA $39
        LDA $CA5C,Y 
        STA CBM_TXTPTR+1
        LDA $CA5B,Y 
        STA CBM_TXTPTR
LAC0C   RTS
---------------------------------
LAC0D   LDX #$1F                        ; UNTIL WITHOUT REPEAT
        !by $2c
LAC10   LDX #$20                        ; END LOOP WITHOUT LOOP
        !by $2c
LAC13   LDX #$21                        ; MISSING END LOOP
        JMP PRINTERR
; ----------------------------------------------
; - $AC18 EXIT ---------------------------------
; ----------------------------------------------
CMD_EXIT
        BEQ +
        LDA #$8B
        JSR L862F                       ; $AEFF, check for a specific value
        JSR L8675
        LDX $61
        BEQ LAC0C
+       LDX #$01
        JSR L86A1
LAC2B   JSR L8587                       ; LDA($7A+1),y
        BNE +
        JSR L8587                       ; LDA($7A+1),y
        JSR L8587                       ; LDA($7A+1),y
        BEQ LAC13
        JSR L8587                       ; LDA($7A+1),y
        STA $FD
        JSR L8587                       ; LDA($7A+1),y
        STA $FE
        JSR L8587                       ; LDA($7A+1),y
+       CMP #$63
        BNE LAC2B
        JSR L8587                       ; LDA($7A+1),y
        CMP #$41
        BNE +
        INX
        BNE LAC2B
+       CMP #$43
        BNE LAC2B
        DEX
        BNE LAC2B
        LDX $FD
        LDY $FE
        LDA $CA5E
        BEQ LAC13
        DEC $CA5E
        STX $39
        STY $3A
        JMP CBM_CHRGET
; ----------------------------------------------
; - $AC6D RESET --------------------------------
; ----------------------------------------------
CMD_RESET
        JSR L85D3                       ; CBM_FRMNUM,CBM_GETADR
        JSR L8613                       ; get line, do error if not exists
        LDY $60
        LDX $5F
        BNE +
        DEY
+       DEX
        STX $41
        STY $42
        RTS
; ----------------------------------------------
; - $AC80 ENDPROC ------------------------------
; ----------------------------------------------
CMD_END_PROC
        LDA $CA35
        BEQ LACA4
        DEC $CA35
        ASL
        TAY
        LDA $CA34,Y 
        STA CBM_TXTPTR
        LDA $CA35,Y 
        STA CBM_TXTPTR+1
        JMP LA935
; ----------------------------------------------
; - $AC97 EXEC ---------------------------------
; ----------------------------------------------
CMD_EXEC
        LDA $CA35
        CMP #$14
        BCC LACA9
        LDX #$10                        ; OUT OF MEMORY
        !by $2c
LACA1   LDX #$23                        ; PROC NOT FOUND
        !by $2c
LACA4   LDX #$24                        ; END PROC WITHOUT EXEC
        JMP PRINTERR
---------------------------------
LACA9   ASL
        TAY
        INC $CA35
        LDA CBM_TXTPTR
        STA $CA36,Y 
        LDA CBM_TXTPTR+1
        STA $CA37,Y 
; ----------------------------------------------
; - $ACB8 CALL ---------------------------------
; ----------------------------------------------
CMD_CALL
        LDA CBM_TXTPTR
        LDX CBM_TXTPTR+1
        STA $FB
        STX $FC
        JSR L864C
LACC3   JSR LA935
--      JSR INC7A_7B
        JSR L8587                       ; LDA($7A+1),y
        BEQ LACA1
        JSR INC7A_7B
        JSR INC7A_7B
-       JSR L8589
        BEQ --
        CMP #$63
        BNE -
        JSR L8589
        CMP #$44
        BNE -
        JSR CBM_CHRGET
-       LDA (CBM_TXTPTR),Y
        CMP ($FB),Y
        BNE LACC3
        TAX
        BEQ LAD3D
        INY
        CMP #$28
        BNE -
        CLC
        TYA
        ADC $FB
        STA $FB
        BCC +
        INC $FC
+       JSR L8655
LAD02   JSR L85B9                       ; CBM_PTRGET
        STA $49
        STY $4A
        LDA CBM_TXTPTR
        PHA
        LDA CBM_TXTPTR+1
        PHA
        LDA $FB
        LDX $FC
        STA CBM_TXTPTR
        STX CBM_TXTPTR+1
        JSR L865E
        JSR CBM_CHRGOT
        CMP #$29
        BEQ +
        JSR L85A1                       ; CBM_CHKCOM
        LDA CBM_TXTPTR
        LDX CBM_TXTPTR+1
        STA $FB
        STX $FC
        PLA
        STA CBM_TXTPTR+1
        PLA
        STA CBM_TXTPTR
        JSR L85A1                       ; CBM_CHKCOM
        BNE LAD02
+       PLA
        STA CBM_TXTPTR+1
        PLA
        STA CBM_TXTPTR
LAD3D   JMP LA935
; ----------------------------------------------
; - $AD40 ON ERROR -----------------------------
; ----------------------------------------------
CMD_ON_ERROR
        LDA #$89
        JSR L862F                       ; $AEFF, check for a specific value
        JSR L8607                       ; CBM_CHRGOT, CBM_LINGET
        JSR L8613                       ; get line address, do error if not exists
        LDA $5F                         ; low byte line address
        LDX $60                         ; high byte line address
        STA $CA13                       ; ON ERROR line address low byte
        STX $CA14                       ; ON ERROR line address high byte
        LDA #$FF                        ; switch on ON ERROR handling
LAD57   !by $2c
; ----------------------------------------------
; - $AD58 NO ERROR -----------------------------
; ----------------------------------------------
CMD_NO_ERROR
        LDA #$00                        ; switch off ON ERROR handling
        STA $CA20                       ; flag for ON ERROR handling
LAD5D   RTS
; ----------------------------------------------
; - $AD5E RESUME -------------------------------
; ----------------------------------------------
CMD_RESUME
        LDX $CA1A                       ; RESUME flag
        BNE LADA5                       ; if not 0, can't resume
        LDX $CA16                       ; ERRLN line number
        LDY $CA17
        STX $39
        STY $3A
        LDX $CA18                       ; CONT memory pointer
        LDY $CA19
        STX CBM_TXTPTR
        STY CBM_TXTPTR+1
        CMP #$82
        BNE LAD5D
        JSR L8999
        BNE LAD90
        JSR INC7A_7B
        JSR INC7A_7B
        JSR L8587                       ; LDA($7A+1),y
        STA $39
        JSR L8587                       ; LDA($7A+1),y
        STA $3A
LAD90   JSR CBM_CHRGET
        BEQ LAD5D
        CMP #$22
        BNE LAD90
-       JSR CBM_CHRGET
        TAX
        BEQ LAD5D
        CMP #$22
        BNE -
        BEQ LAD90
LADA5   LDX #$25                        ; CAN'T RESUME
        !by $2c
LADA8   LDX #$16                        ; TYPE MISMATCH
        !by $2c
LADAB   LDX #$15                        ; ILLEGAL DIRECT
        JMP PRINTERR
; ----------------------------------------------
; - $ADB0 GETKEY -------------------------------
; ----------------------------------------------
CMD_GETKEY
        JSR L85B9                       ; CBM_PTRGET
        LDX $0D
        BEQ LADA8                       ; TYPE MISMATCH
        STA $FB
        STY $FC
        LDA #$01
        JSR L85C5                       ; CBM_STRSPA
        LDA #$00
        STA $C6
-       JSR $F13E
        TAX
        BEQ -
        LDY #$00
        STA ($62),Y
        LDY #$02
-       LDA $0061,Y 
        STA ($FB),Y
        DEY
        BPL -
        RTS
---------------------------------
LADD9   JMP L867E                       ; ILLEGAL QUANTITY
; ----------------------------------------------
; - $ADDC FETCH --------------------------------
; ----------------------------------------------
CMD_FETCH
        LDX $3A
        INX
        BEQ LADAB
        JSR L85AA                       ; CBM_FRMEV,CBM_FRESTR
        STA $FD
        STX $FB
        STY $FC
        JSR L858F                       ; CBM_COMBYT
        CPX #$59
        BCS LADD9
        STX $02
        JSR L85A1                       ; CBM_CHKCOM
        JSR L85B9                       ; CBM_PTRGET
        LDX $0D
        BEQ LADA8                       ; TYPE MISMATCH
        STA $F7
        STY $F8
        LDY #$00
        STY $FE
LAE05   LDA #$00
        STA $D4
LAE09   LDA #$12
        JSR CBM_CHROUT
        JSR P_SPC
        LDA #$92
        JSR CBM_CHROUT
LAE16   JSR $F13E
LAE19   TAX
        BEQ LAE16
        CMP #$14
        BNE +
        LDY $FE
        BEQ LAE16
        JSR CBM_CHROUT
        JSR CBM_CHROUT
        DEC $FE
        CLC
        BCC LAE09
+       CMP #$0D
        BEQ +
        LDY $FE
        CPY $02
        BEQ LAE16
        LDY $FD
        BEQ LAE16
-       CPY #$00
        BEQ LAE16
        DEY
        CMP ($FB),Y
        BNE -
        LDY $FE
        STA CBM_COMMANDBUF,Y 
        LDA #$9D
        JSR CBM_CHROUT
        TXA
        JSR CBM_CHROUT
        INC $FE
        BNE LAE05
+       LDA #$14
        JSR CBM_CHROUT
        LDA $FE
        JSR L85C5                       ; CBM_STRSPA
        TAY
        BEQ +
        DEY
-       LDA CBM_COMMANDBUF,Y 
        STA ($62),Y
        DEY
        BPL -
+       LDY #$02
-       LDA $0061,Y 
        STA ($F7),Y
        DEY
        BPL -
LAE78   JMP P_RET
---------------------------------
LAE7B   JMP L867E                       ; ILLEGAL QUANTITY
; ----------------------------------------------
; - $AE7E LOCATE -------------------------------
; ----------------------------------------------
CMD_LOCATE
        JSR L8598                       ; CBM_GETBYT
        TXA
        PHA
        JSR L858F                       ; CBM_COMBYT
        PLA
        CMP #$28
        BCS LAE7B
        CPX #$19
        BCS LAE7B
        STA $D3
        STX $D6
        JSR $E56C
        JSR CBM_CHRGOT
        BEQ LAEB3
        JSR L85A1                       ; CBM_CHKCOM
        JMP L8667
; ----------------------------------------------
; - $AEA1 COLOR --------------------------------
; ----------------------------------------------
CMD_COLOR
        JSR L86BD                       ; get byte, and check for $00 - $0f
        STX $0286
        JSR L86BA                       ; CBM_CHKCOM, get byte, and check for $00 - $0f
        STX $D020
        JSR L86BA                       ; CBM_CHKCOM, get byte, and check for $00 - $0f
        STX $D021
LAEB3   RTS
; ----------------------------------------------
; - $AEB4 CENTER -------------------------------
; ----------------------------------------------
CMD_CENTER
        JSR L85AA                       ; CBM_FRMEV,CBM_FRESTR
        STA $02
        SEC
        SBC #$01
        CMP #$28
        BCS +
        LSR
        EOR #$FF
        CLC
        ADC #$14
        STA $D3
        JSR $E510
+       LDY #$00
-       CPY $02
        BEQ LAE78
        LDA ($22),Y
        JSR CBM_CHROUT
        INY
        BNE -
; ----------------------------------------------
; - $AED9 SPELL --------------------------------
; ----------------------------------------------
CMD_SPELL
        JSR L85AA                       ; CBM_FRMEV,CBM_FRESTR
        STX $FB
        STY $FC
        STA $02
        JSR L858F                       ; CBM_COMBYT
        LDA $02
LAEE7   BEQ LAEB3
        LDY #$00
LAEEB   LDA ($FB),Y
        JSR CBM_CHROUT
        LDA #$00
        STA $D4
        LDA $C7
        PHA
        LDA #$01
        STA $C7
        JSR P_SPC
        LDA #$9D
        JSR CBM_CHROUT
        LDX $65
        INX
--      LDA #$00
-       ADC #$01
        BNE -
        DEX
        BNE --
        STX $C7
        JSR P_SPC
        LDA #$9D
        JSR CBM_CHROUT
        PLA
        STA $C7
        INY
        CPY $02
        BNE LAEEB
        JMP P_RET
; ----------------------------------------------
; - $AF24 PRESS --------------------------------
; ----------------------------------------------
CMD_PRESS
        JSR L86C7                       ; get byte and check valid range
        STY $02                         ; store byte
        JSR L85A1                       ; CBM_CHKCOM
        JSR L85AA                       ; CBM_FRMEV,CBM_FRESTR
        STA $FB
        LDY #$00
LAF33   CPY $FB
        BEQ LAEE7
        LDA ($22),Y
        INY
        JSR CBM_CHROUT
        LDA #$00
        STA $D4
        LDX $02
        CPX #$01
        BNE +
        LDA #$91
        JSR CBM_CHROUT
        LDA #$9D
        JSR CBM_CHROUT
+       CPX #$02
        BNE +
        LDA #$91
        JSR CBM_CHROUT
+       CPX #$04
        BNE +
        LDA #$11
        JSR CBM_CHROUT
+       CPX #$05
        BNE +
        LDA #$11
        JSR CBM_CHROUT
        LDA #$9D
        JSR CBM_CHROUT
+       CPX #$06
        BNE +
        LDA #$9D
        JSR CBM_CHROUT
        JSR CBM_CHROUT
        LDA #$11
        JSR CBM_CHROUT
+       CPX #$07
        BNE +
        LDA #$9D
        JSR CBM_CHROUT
        JSR CBM_CHROUT
+       CPX #$08
        BNE +
        LDA #$9D
        JSR CBM_CHROUT
        JSR CBM_CHROUT
        LDA #$91
        JSR CBM_CHROUT
+       JMP LAF33
; ----------------------------------------------
; - $AFA2 Get 4 bytes ; s,z,b,h ----------------
; ----------------------------------------------
GET_4BYTE
        LDA $0288
LAFA5   STA $FC
        JSR L8598                       ; CBM_GETBYT getbyte
        STX $FB
        JSR L858F                       ; CBM_COMBYT combyte
        STX $02
        JSR L858F                       ; CBM_COMBYT combyte
        DEX
        STX $FD
        JSR L858F                       ; CBM_COMBYT combyte
        TXA
        BEQ LAFEF
        STX $FE
LAFBF   CLC
        ADC $02
        BCS LAFEF
        CMP #$1A
        BCS LAFEF
        LDA $FD
        ADC $FB
        BCS LAFEF
        CMP #$28
        BCS LAFEF
        LDA $02
        LDY #$00
        STA $59
        STY $5A
        LDA #$28
        STA $5B
        JSR LA560
        CLC
        LDA $57
        ADC $FB
        STA $FB
        LDA $58
        ADC $FC
        STA $FC
        RTS
---------------------------------
LAFEF   LDX #$26                        ; OUT OF RANGE
        JMP PRINTERR
; ----------------------------------------------
; - $AFF4 FCOL ---------------------------------
; ----------------------------------------------
CMD_FCOL
        LDA #$D8
        JSR LAFA5
        BCC LAFFE
; ----------------------------------------------
; - $AFFB FCHR ---------------------------------
; ----------------------------------------------
CMD_FCHR
        JSR GET_4BYTE
LAFFE   JSR L858F                       ; CBM_COMBYT
        TXA
LB002   LDX #$00
LB004   STX $02
LB006   LDX $FE
LB008   LDY $FD
-       BIT $02
        BVC +
        LDA ($FB),Y
        EOR #$80
        BIT $02
        BPL +
        LDA ($14),Y
+       STA ($FB),Y
        DEY
        BPL -
        PHA
        LDA $FB
        CLC
        ADC #$28
        STA $FB
        BCC +
        INC $FC
+       LDA $14
        CLC
        ADC #$28
        STA $14
        BCC +
        INC $15
+       PLA
        DEX
        BNE LB008
LB038   RTS
; ----------------------------------------------
; - $B039 FILL ---------------------------------
; ----------------------------------------------
CMD_FILL
        LDA #$00
        JSR LAFA5
        PHA
        ADC $0288
        STA $FC
        LDA $FB
        PHA
        JSR LAFFE
        JSR L858F                       ; CBM_COMBYT
LB04D   PLA
        STA $FB
        PLA
        CLC
        ADC #$D8
        STA $FC
        TXA
        JMP LB006
; ----------------------------------------------
; - $B05A SCRINV -------------------------------
; ----------------------------------------------
CMD_SCRINV
        JSR GET_4BYTE
        LDX #$40
        JMP LB004
; ----------------------------------------------
; - $B062 SCOPY --------------------------------
; ----------------------------------------------
CMD_SCOPY
        LDA #$00
        JSR LAFA5
        STA $15
        LDA $FB
        STA $14
        JSR L858F                       ; CBM_COMBYT
        STX $FB
        JSR L858F                       ; CBM_COMBYT
        STX $02
        LDX #$00
        STX $FC
        LDA $FE
        JSR LAFBF
        PHA
        ADC $0288
        STA $FC
        LDA $FB
        PHA
        LDA $15
        PHA
        ADC $0288
        STA $15
        LDA $14
        PHA
        LDX #$FF
        JSR LB004
        PLA
        STA $14
        PLA
        CLC
        ADC #$D8
        STA $15
        JMP LB04D
; ----------------------------------------------
; - $B0A5 CHANGE -------------------------------
; ----------------------------------------------
CMD_CHANGE
        JSR L8699                       ; switch off kernel
        LDA $0288                       ; screen start high byte
        STA $FC
        LDY #$00                        ; low byte
        STY $FB
        STY $FD
        STY $22
        STY $24
        LDA #$F0                        ; exchange screen start high byte
        STA $FE
        LDA #$D8                        ; low byte
        STA $23
        LDA #$F4                        ; high byte color ram
        STA $25
        LDA #$03                        ; page counter
        STA $02
-       JSR LB0D6                       ; exchange
        DEC $02
        BNE -                           ; next page
        LDY #$E8                        ; byte counter
        JSR LB0D6                       ; exchange
        JMP L8691                       ; switch on kernel
---------------------------------
; exchang two areas ; ($FB)<>($FB), and ($22)<>($24)
LB0D6   DEY
        LDA ($FB),Y
        TAX
        LDA ($FD),Y
        STA ($FB),Y
        TXA
        STA ($FD),Y
        LDA ($22),Y
        TAX
        LDA ($24),Y
        STA ($22),Y
        TXA
        STA ($24),Y
        TYA
        BNE LB0D6                       ; loop
        INC $FC
        INC $FE
        INC $23
        INC $25
        RTS
; ----------------------------------------------
; - $B0F7 Get 4 + 1 byte ; s,z,h,b,m -----------
; ----------------------------------------------
GET_4PLUS1
LB0F7   JSR GET_4BYTE
        JSR L858F                       ; CBM_COMBYT
        STX $02
LB0FF   LDA $FB
        JMP LB10F
---------------------------------
LB104   CLC
        LDA $FB
        ADC #$28
        STA $FB
        BCC LB10F
        INC $FC
LB10F   STA $F9
        CLC
        LDA $FC
        AND #$03
        ADC #$D8
        STA $FA
        RTS
; ----------------------------------------------
; - $B11B SLEFT --------------------------------
; ----------------------------------------------
CMD_SLEFT
        JSR GET_4PLUS1
LB11E   LDY #$00
        LDA ($F9),Y
        PHA
        LDA ($FB),Y
        PHA
-       CPY $FD
        BEQ +
        INY
        LDA ($F9),Y
        TAX
        LDA ($FB),Y
        DEY
        STA ($FB),Y
        TXA
        STA ($F9),Y
        INY
        BNE -
+       PLA
        LDX $02
        BNE +
        LDA #$20
+       STA ($FB),Y
        PLA
        STA ($F9),Y
        JSR LB104
        DEC $FE
        BNE LB11E
        RTS
; ----------------------------------------------
; - $B14D SRIGHT -------------------------------
; ----------------------------------------------
CMD_SRIGHT
        JSR GET_4PLUS1
LB150   LDY $FD
        LDA ($F9),Y
        PHA
        LDA ($FB),Y
        PHA
-       DEY
        BMI +
        LDA ($F9),Y
        TAX
        LDA ($FB),Y
        INY
        STA ($FB),Y
        TXA
        STA ($F9),Y
        DEY
        BPL -
+       PLA
        LDX $02
        BNE +
        LDA #$20
+       INY
        STA ($FB),Y
        PLA
        STA ($F9),Y
        JSR LB104
        DEC $FE
        BNE LB150
        RTS
; ----------------------------------------------
; - $B17E SUP ----------------------------------
; ----------------------------------------------
CMD_SUP
        LDA #$00
        !by $2c
; ----------------------------------------------
; - $B181 SDOWN --------------------------------
; ----------------------------------------------
CMD_SDOWN
        LDA #$80
        STA $F8
        JSR GET_4PLUS1
        LDA $F8
        BNE +
        LDX $FE
        DEX
        STX $59
        STA $5A
        LDX #$28
        STX $5B
        JSR LA560
        CLC
        LDA $FB
        ADC $57
        STA $FB
        LDA $FC
        ADC $58
        STA $FC
        JSR LB0FF
+       LDA $FB
        LDX $FC
        STA $14
        STX $15
        LDY $FD
LB1B4   LDA $FE
        STA $FD
        LDA ($F9),Y
        STA $F7
        LDA ($FB),Y
LB1BE   DEC $FD
        BEQ LB1EF
        TAX
        LDA $F8
        BNE LB1D8
        SEC
        LDA $FB
        SBC #$28
        STA $FB
        BCS +
        DEC $FC
+       JSR LB10F
        JMP LB1DB
---------------------------------
LB1D8   JSR LB104
LB1DB   LDA ($FB),Y
        PHA
        LDA ($F9),Y
        PHA
        TXA
        STA ($FB),Y
        LDA $F7
        STA ($F9),Y
        PLA
        STA $F7
        PLA
        JMP LB1BE
---------------------------------
LB1EF   LDX $02
        BNE +
        LDA #$20
+       LDX $14
        STX $FB
        LDX $15
        STX $FC
        STA ($FB),Y
        JSR LB0FF
        LDA $F7
        STA ($F9),Y
        DEY
        BPL LB1B4
        RTS
; ----------------------------------------------
; - $B20A FLASH --------------------------------
; ----------------------------------------------
CMD_FLASH
        BEQ +
        JSR L86BD                       ; get byte, and check for $00 - $0f
        STX $CA01                       ; color
        JSR L86EE                       ; CBM_CHKCOM, CBM_GETBYT increased by one
        STX $CA02                       ; flash frequency
        LDA #$01                        ; 1 = ON
        STA $CA03                       ; used in IRQ
        !by $2c
+       LDA #$00                        ; 0 = OFF
        STA $CA00                       ; switch flash mode on or off
        RTS
; ----------------------------------------------
; - $B224 VOL ----------------------------------
; ----------------------------------------------
CMD_VOL
        JSR L86BD                       ; get byte, and check for $00 - $0f
        STX $D418
        RTS
; ----------------------------------------------
; - $B22B ENVELOPE -----------------------------
; ----------------------------------------------
CMD_ENVELOPE
        JSR L86DC                       ; input voice register 0-2 high and low byte into $14/$15
        LDY #$05
-       STY $FB
        JSR L86BA                       ; CBM_CHKCOM, get byte, and check for $00 - $0f
        TXA
        ASL
        ASL
        ASL
        ASL
        PHA
        JSR L86BA                       ; CBM_CHKCOM, get byte, and check for $00 - $0f
        PLA
        ORA $65
        LDY $FB
        STA ($14),Y
        INY
        CPY #$07
        BNE -
        RTS
; ----------------------------------------------
; - $B24B WAVE ---------------------------------
; ----------------------------------------------
CMD_WAVE
        JSR L86DC                       ; input voice register 0-2 high and low byte into $14/$15
        JSR L858F                       ; CBM_COMBYT
        LDY #$04
        TXA
        STA ($14),Y
        LDX $14
        STA $07E9,X 
        RTS
; ----------------------------------------------
; - $B25C MUSIC --------------------------------
; ----------------------------------------------
CMD_MUSIC
        JSR L86F1                       ; get byte and increase by one
        STX $07EB
        JSR L85A1                       ; CBM_CHKCOM
        JSR L85AA                       ; CBM_FRMEV,CBM_FRESTR
        STA $07F3
        STX $07F1
        STY $07F2
        LDA #$00
        STA $07F4
        RTS
; ----------------------------------------------
; - $B277 PLAY ---------------------------------
; ----------------------------------------------
CMD_PLAY
        JSR L8598                       ; CBM_GETBYT
        SEI
        LDY #$00
        STY $07F4
        STX $07EE
        TXA
        BNE +
        CLI
        JMP L82A3
---------------------------------
+       STY $07EF
        INY
        STY $07EC
        STY $07EA
        STY $07ED
        DEX
        BNE +
        CLI
-       LDA $07EE
        BNE -
+       CLI
LB2A1   RTS
; ----------------------------------------------
; - $B2A2 SOUND --------------------------------
; ----------------------------------------------
CMD_SOUND
        JSR L86DC                       ; input voice register 0-2 high and low byte into $14/$15
        STY $02
        JSR L85A1                       ; CBM_CHKCOM
        JSR L85D3                       ; CBM_FRMNUM,CBM_GETADR
        LDX $02
        STA $D401,X 
        TYA
        STA $D400,X 
        JSR CBM_CHRGOT
        BEQ LB2A1                       ; RTS
        JSR L85A1                       ; CBM_CHKCOM
        JSR L85D3                       ; CBM_FRMNUM,CBM_GETADR
        LDX $02
        LDA $07E9,X 
        ORA #$01
        STA $D404,X 
--      LDY #$52
-       DEY
        BNE -
        LDA $14
        BNE +
        DEC $15
+       DEC $14
        LDA $14
        ORA $15
        BNE --
        JMP L82A6
; ----------------------------------------------
; - $B2E1 CLRSID -------------------------------
; ----------------------------------------------
CMD_CLRSID
        LDA #$00
        STA $07EE
        LDX #$18
-       STA $D400,X 
        DEX
        BPL -
        RTS
; ----------------------------------------------
; - $B2EF PULSE --------------------------------
; ----------------------------------------------
CMD_PULSE
        JSR L86DC                       ; input voice register 0-2 high and low byte into $14/$15
        STY $02
        JSR L85A1                       ; CBM_CHKCOM
        JSR L85D3                       ; CBM_FRMNUM,CBM_GETADR
        CMP #$10
        BCS LB308
        LDX $02
        STA $D403,X 
        TYA
        STA $D402,X 
        RTS
---------------------------------
LB308   JMP L867E                       ; ILLEGAL QUANTITY
; ----------------------------------------------
; - $B30B BEEP ---------------------------------
; ----------------------------------------------
CMD_BEEP
        JSR L8598                       ; CBM_GETBYT
        TXA
        BEQ LB344
        ASL $65
        LDA #$0F
        STA $D418
        LDA #$FF
        STA $D414
        LDA #$09
        STA $D413
        LDA #$67
        STA $D40F
        LDA #$67
        STA $D40E
LB32C   LDA #$11
        STA $D412
        LDX #$50
--      LDY #$00
-       DEY
        BNE -
        DEX
        BNE --
        LDA #$00
        STA $D412
        DEC $65
        BNE LB32C
LB344   RTS
; ----------------------------------------------
; - $B345 SWITCH -------------------------------
; ----------------------------------------------
CMD_SWITCH
        JSR L8598                       ; CBM_GETBYT
        LDA #$13
        JSR CBM_CHROUT
        TXA
        BEQ LB360
        LDA #$94
        STA $DD00
        LDA #$39
        STA $D018
        LDA #$CC
        STA $0288
LB35F   RTS
---------------------------------
LB360   JMP L84B8
; ----------------------------------------------
; - $B363 CHRINV -------------------------------
; ----------------------------------------------
CMD_CHRINV
        JSR GET_CHR_MOD
        LDY #$07
LB368   JSR L8699                       ; switch off kernal
-       LDA ($14),Y
        EOR #$FF
        STA ($14),Y
        DEY
        BPL -
        JMP L8691                       ; switch on kernel
; ----------------------------------------------
; - $B377 TWIST --------------------------------
; ----------------------------------------------
CMD_TWIST
        JSR GET_CHR_MOD
        JSR L858F                       ; CBM_COMBYT
        TXA
        BEQ LB35F
LB380   JSR L8699                       ; switch off kernal
LB383   LDA #$00
        LDX #$07
-       STA $F7,X 
        DEX
        BPL -
        LDY #$07
LB38E   LDA ($14),Y
        STA $02
        LDX #$00
-       ROR $02
        LDA $F7,X 
        BCC +
        ORA LB3B8,Y 
        STA $F7,X 
+       INX
        CPX #$08
        BNE -
        DEY
        BPL LB38E
        LDY #$07
-       LDA $00F7,Y 
        STA ($14),Y
        DEY
        BPL -
        DEC $65
        BNE LB383
        JMP L8691                       ; switch on kernel
---------------------------------
LB3B8   !by $80,$40,$20,$10,$08,$04,$02,$01
; ----------------------------------------------
; - $B3C0 MIRX ---------------------------------
; ----------------------------------------------
CMD_MIRX
        JSR GET_CHR_MOD
LB3C3   LDX #$04
        LDY #$00
        LDA #$07
LB3C9   CLC
        ADC $14
        STA $FB
        LDA $15
        STA $FC
        STY $02
        JSR L8699                       ; switch off kernal
--      LDY $02
-       LDA ($14),Y
        PHA
        LDA ($FB),Y
        STA ($14),Y
        PLA
        STA ($FB),Y
        DEY
        BPL -
        LDY $02
-       INC $14
        DEC $FB
        DEY
        BPL -
        DEX
        BNE --
        JMP L8691                       ; switch on kernel
; ----------------------------------------------
; - $B3F5 MIRY ---------------------------------
; ----------------------------------------------
CMD_MIRY
        JSR GET_CHR_MOD
        LDX #$02
        STX $65
        JSR LB380
        JMP LB3C3
---------------------------------
LB402   !bY $4c,$52,$55,$44 ;"LRUD"
LB406   !by $43,$55,$6c,$86 ;"CU.."
; ----------------------------------------------
; - $B40A SCROLL -------------------------------
; ----------------------------------------------
CMD_SCROLL
        LDY #$03
-       CMP LB402,Y 
        BEQ +
        DEY
        BPL -
        JMP LA987
---------------------------------
+       JSR CBM_CHRGET
        LDA LB406,Y 
        PHA
        JSR GET_CHR_MOD
        JSR L858F                       ; CBM_COMBYT
        STX $FB
        JSR L858F                       ; CBM_COMBYT
        STX $02
        PLA
        LDX $FB
        BEQ LB454                       ; RTS
        STA $55
        LDA #$B4
        STA $56
        JSR L8699                       ; switch off kernal
-       JSR $0054
        DEC $FB
        BNE -
        JMP L8691                       ; switch on kernel
---------------------------------
        LDY #$07
-       LDA ($14),Y
        ASL
        LDX $02
        BNE +
        CLC
+       ADC #$00
        STA ($14),Y
        DEY
        BPL -
LB454   RTS
---------------------------------
        LDY #$07
LB457   LDA ($14),Y
        PHA
        AND #$01
        CLC
        ADC #$FF
        PLA
        LDX $02
        BNE +
        CLC
+       ROR
        STA ($14),Y
        DEY
        BPL LB457
        RTS
---------------------------------
        LDY #$00
        LDA ($14),Y
        PHA
-       INY
        LDA ($14),Y
        DEY
        STA ($14),Y
        INY
        CPY #$07
        BNE -
        PLA
        LDX $02
        BNE +
        LDA #$00
+       STA ($14),Y
        RTS
---------------------------------
        LDY #$07
        LDA ($14),Y
        PHA
-       DEY
        LDA ($14),Y
        INY
        STA ($14),Y
        DEY
        BNE -
        PLA
        LDX $02
        BNE +
        LDA #$00
+       STA ($14),Y
        RTS
; ----------------------------------------------
; - $B49E CHRCOPY ------------------------------
; ----------------------------------------------
CMD_CHRCOPY
        JSR LA91A
        JSR GET_CHR_MOD
        LDY #$07
LB4A6   JSR L86AA
-       LDA ($FB),Y
        STA ($14),Y
        DEY
        BPL -
        JMP L86B2
; ----------------------------------------------
; - $B4B3 CHROR --------------------------------
; ----------------------------------------------
CMD_CHROR
        LDA #$00
        !by $2c
; ----------------------------------------------
; - $B4B6 CHRAND -------------------------------
; ----------------------------------------------
CMD_CHRAND
        LDA #$FF
        STA $02
        JSR LA91A
        LDA $FB
        LDX $FC
        STA $FD
        STX $FE
        JSR LA91A
        JSR GET_CHR_MOD
        LDY #$07
LB4CD   JSR L86AA
-       LDA ($FB),Y
        BIT $02
        BMI +
        ORA ($FD),Y
        !by $2c
+       AND ($FD),Y
        STA ($14),Y
        DEY
        BPL -
        JMP L86B2
; ----------------------------------------------
; - $B4E3 EMPTY --------------------------------
; ----------------------------------------------
CMD_EMPTY
        JSR GET_CHR_MOD
        LDY #$07
LB4E8   LDA #$00
-       STA ($14),Y
        DEY
        BPL -
        RTS
; ----------------------------------------------
; - $B4F0 CREATE -------------------------------
; ----------------------------------------------
CMD_CREATE
        JSR L8598                       ; CBM_GETBYT
        JSR L85A1                       ; CBM_CHKCOM
        TXA
        BNE LB552
        JSR GET_CHR_MOD
        LDA #$00
        STA $CA0A
        LDA $14
        STA $CA0B
        LDA $15
        STA $CA0C
        RTS
; ----------------------------------------------
; - $B50C CHAR ---------------------------------
; ----------------------------------------------
CMD_CHAR
        JSR L85AA                       ; CBM_FRMEV,CBM_FRESTR
        CMP #$08
        BEQ +
        JMP L8A26                       ; ILLEGAL STRING LENGTH
---------------------------------
+       STX $FB
        STY $FC
        JSR CBM_CHRGOT
        BEQ +
        JSR L858F                       ; CBM_COMBYT
        DEX
        STX $CA0A
+       LDX $CA0A
        CPX #$08
        BCC +
        JMP L867E                       ; ILLEGAL QUANTITY
---------------------------------
+       LDY #$07
-       LDA ($FB),Y
        EOR #$04
        ADC #$D2
        ROR $02
        DEY
        BPL -
        LDA $CA0B
        LDX $CA0C
        STA $FB
        STX $FC
        LDY $CA0A
        LDA $02
        STA ($FB),Y
        INC $CA0A
        RTS
---------------------------------
LB552   JSR GET_BLKPARAM
        LDA #$00
        STA $CA23
        LDA $14
        LDX $15
        STA $CA24
        STX $CA25
        RTS
; ----------------------------------------------
; - $B565 MOB ----------------------------------
; ----------------------------------------------
CMD_MOB
        JSR L85AA                       ; CBM_FRMEV,CBM_FRESTR
        STA $FD
        DEC $FD
        STX $FB
        STY $FC
        CMP #$18
        BEQ ++
        CMP #$0C
        BEQ +
        JMP L8A26                       ; ILLEGAL STRING LENGTH
---------------------------------
+       LDA #$80
++      STA $FE
        JSR CBM_CHRGOT
        BEQ +
        JSR L858F                       ; CBM_COMBYT
        DEX
        STX $CA23
+       LDA $CA23
        CMP #$15
        BCC +
        JMP L867E                       ; ILLEGAL QUANTITY
---------------------------------
+       ADC $CA23
        ADC $CA23
        ADC $CA24
        STA $14
        LDA $CA25
        STA $15
        LDY #$02
LB5A7   STY $FA
        LDY $FD
        LDX #$08
LB5AD   LDA ($FB),Y
        BIT $FE
        BPL +
        LSR
        ROR $02
        DEX
        CMP #$15
        BEQ ++
        CMP #$1E
        BEQ ++
        TXA
+       EOR #$04
        ADC #$D2
++      ROR $02
        DEY
        DEX
        BNE LB5AD
        STY $FD
        LDY $FA
        LDA $02
        STA ($14),Y
        DEY
        BPL LB5A7
        INC $CA23
LB5D8   RTS
; ----------------------------------------------
; - $B5D9 TURNMOB ------------------------------
; ----------------------------------------------
CMD_TURNMOB
        JSR GET_BLKPARAM
        JSR L858F                       ; CBM_COMBYT
        TXA
        AND #$03
        BEQ LB5D8
        STA $FB
        SEI
        LDA #$3C
        STA $01
LB5EB   LDY #$3F
-       LDA ($14),Y
        STA $D000,Y 
        LDA #$00
        STA ($14),Y
        DEY
        BPL -
        STA $FD
        STA $FE
LB5FD   JSR LB649
        AND $D000,Y 
        BNE LB626
LB605   LDX $FD
        INX
        CPX #$15
        BCC LB621
        LDY $FE
        INY
        CPY #$15
        BCC +
        DEC $FB
        BNE LB5EB
LB617   LDA #$36
        STA $01
        CLI
        RTS
---------------------------------
+       STY $FE
        LDX #$00
LB621   STX $FD
        JMP LB5FD
---------------------------------
LB626   LDX $FD
        LDY $FE
        STX $50
        STY $51
        STY $FD
        LDA #$14
        SEC
        SBC $50
        STA $FE
        JSR LB649
        ORA ($14),Y
        STA ($14),Y
        LDX $50
        LDY $51
        STX $FD
        STY $FE
        JMP LB605
---------------------------------
LB649   LDA $FD
        AND #$07
        PHA
        LDA $FD
        LSR
        LSR
        LSR
        STA $35
        LDA $FE
        CLC
        ADC $35
        STA $35
        LDA $FE
        ASL
        CLC
        ADC $35
        TAY
        PLA
        STA $35
        TAX
        LDA #$00
        SEC
-       ROR
        DEX
        BPL -
        LDX $35
        RTS
; ----------------------------------------------
; - $B671 BLCOPY -------------------------------
; ----------------------------------------------
CMD_BLCOPY
        JSR GET_BLKPARAM
        LDA $14
        LDX $15
        STA $FB
        STX $FC
        JSR L85A1                       ; CBM_CHKCOM
        JSR GET_BLKPARAM
        LDY #$3F
        JMP LB4A6
; ----------------------------------------------
; - $B687 BLOR ---------------------------------
; ----------------------------------------------
CMD_BLOR
        LDA #$00
        !by $2c
; ----------------------------------------------
; - $B68A BLAND --------------------------------
; ----------------------------------------------
CMD_BLAND
        LDA #$FF
        STA $02
        JSR GET_BLKPARAM
        LDA $14
        LDX $15
        STA $FD
        STX $FE
        JSR L85A1                       ; CBM_CHKCOM
        JSR GET_BLKPARAM
        LDA $14
        LDX $15
        STA $FB
        STX $FC
        JSR L85A1                       ; CBM_CHKCOM
        JSR GET_BLKPARAM
        LDY #$3E
        JMP LB4CD
; ----------------------------------------------
; - $B6B2 ERASE --------------------------------
; ----------------------------------------------
CMD_ERASE
        JSR GET_BLKPARAM
        LDY #$3E
        JMP LB4E8
; ----------------------------------------------
; - $B6BA BLINV --------------------------------
; ----------------------------------------------
CMD_BLINV
        JSR GET_BLKPARAM
        LDY #$3E
        JMP LB368
; ----------------------------------------------
; - $B6C2 REFLECTX -----------------------------
; ----------------------------------------------
CMD_REFLECTX
        JSR GET_BLKPARAM
        LDX #$0A
        LDY #$02
        LDA #$3C
        JMP LB3C9
; ----------------------------------------------
; - $B6CE REFLECTY -----------------------------
; ----------------------------------------------
CMD_REFLECTY
        JSR GET_BLKPARAM
        JSR L858F                       ; CBM_COMBYT
        DEX
        STX $FE
        JSR L8699                       ; switch off kernal
        LDA #$15
        STA $02
LB6DE   LDY #$02
        LDX #$02
--      LDA #$08
        STA $22
        LDA ($14),Y
-       LSR
        BIT $FE
        BMI +
        PHP
        LSR
        ROL $FB,X 
        DEC $22
        PLP
+       ROL $FB,X 
        DEC $22
        BNE -
        DEX
        DEY
        BPL --
        INY
        LDX #$02
-       LDA $FB,X 
        STA ($14),Y
        INC $14
        DEX
        BPL -
        DEC $02
        BNE LB6DE
        JMP L8691                       ; switch on kernel
---------------------------------
LB711   LDY #$00
LB713   LDA ($14),Y
LB715   ASL
LB716   LDA $02
LB718   BNE $B71B
LB71A   CLC
LB71B   LDY #$02
LB71D   LDA ($14),Y
LB71F   ROL
LB720   STA ($14),Y
LB722   DEY
LB723   BPL $B71D
LB725   INC $14
LB727   INC $14
LB729   INC $14
LB72B   DEX
LB72C   BPL $B711
LB72E   RTS
---------------------------------
LB72F   LDY #$02
LB731   LDA ($14),Y
LB733   LSR
LB734   LDA $02
LB736   BNE $B739
LB738   CLC
LB739   LDY #$00
LB73B   BIT $28
LB73D   LDA ($14),Y
LB73F   ROR
LB740   STA ($14),Y
LB742   INY
LB743   PHP
LB744   CPY #$03
LB746   BNE $B73C
LB748   PLA
LB749   INC $14
LB74B   INC $14
LB74D   INC $14
LB74F   DEX
LB750   BPL LB72F
LB752   RTS
---------------------------------
LB753   LDA $14
LB755   CLC
LB756   ADC #$3C
LB758   STA $14
LB75A   LDA #$00
LB75C   BIT $03A9
LB75F   STA $22
LB761   EOR #$03
LB763   STA $23
LB765   STX $FC
LB767   LDY #$02
LB769   LDA ($14),Y
LB76B   LDX $02
LB76D   BNE $B770
LB76F   TXA
LB770   PHA
LB771   DEY
LB772   BPL $B769
LB774   LDX #$03
LB776   LDY $22
LB778   BNE $B77C
LB77A   DEC $14
LB77C   LDA ($14),Y
LB77E   LDY $23
LB780   STA ($14),Y
LB782   TYA
LB783   BNE $B787
LB785   INC $14
LB787   DEX
LB788   BNE $B776
LB78A   DEC $FC
LB78C   BNE $B774
LB78E   LDY #$00
LB790   PLA
LB791   STA ($14),Y
LB793   INY
LB794   CPY #$03
LB796   BNE $B790
LB798   RTS
---------------------------------
LB799   !by $11,$2f,$5d,$53
; ----------------------------------------------
; - $B79D SCRMOB -------------------------------
; ----------------------------------------------
CMD_SCRMOB
        LDY #$03
-       CMP LB402,Y 
        BEQ LB7AA
        DEY
        BPL -
        JMP LA987
---------------------------------
LB7AA   JSR CBM_CHRGET
        LDA LB799,Y 
        PHA
        JSR GET_BLKPARAM
        JSR L858F                       ; CBM_COMBYT
        STX $FB
        JSR L858F                       ; CBM_COMBYT
        STX $02
        PLA
        LDX $FB
        BEQ LB798
        STA $55
        LDA #$B7
        STA $56
        JSR L8699                       ; switch off kernal
-       LDA $14
        PHA
        LDX #$14
        JSR $0054
        PLA
        STA $14
        DEC $FB
        BNE -
        JMP L8691                       ; switch on kernel
; ----------------------------------------------
; - $B7DE MULTI --------------------------------
; ----------------------------------------------
CMD_MULTI
        JSR L86BD                       ; get byte, and check for $00 - $0f
        STX $D025
        JSR L86BA                       ; CBM_CHKCOM, get byte, and check for $00 - $0f
        STX $D026
        RTS
---------------------------------
LB7EB   PHA
        JSR L8598                       ; CBM_GETBYT
        PLA
        TAY
        LDA $02
LB7F3   DEX
        BMI LB7FC
        ORA $D000,Y 
        JMP LB801
---------------------------------
LB7FC   EOR #$FF
        AND $D000,Y 
LB801   STA $D000,Y 
        RTS
; ----------------------------------------------
; - $B805 MOBEX --------------------------------
; ----------------------------------------------
CMD_MOBEX
        JSR L86C7                       ; set bit 0 to 7 and save to $02
        JSR L85A1                       ; CBM_CHKCOM
        LDA #$1D
        JSR LB7EB
        JSR L85A1                       ; CBM_CHKCOM
        LDA #$17
        BNE LB7EB
; ----------------------------------------------
; - $B817 CLEAR --------------------------------
; ----------------------------------------------
CMD_CLEAR
        BNE +
        LDA #$00
        STA $D015
LB81E   RTS
---------------------------------
+       JSR L86C7                       ; get byte into Y, set bit 0 to 7 in accu, and save to $02
        LDY #$15
        BNE LB7FC
; ----------------------------------------------
; - $B826 DEFMOB -------------------------------
; ----------------------------------------------
CMD_DEFMOB
        JSR L86C7                       ; get byte into Y, set bit 0 to 7 in accu, and save to $02
        STY $FB
        ORA $D015
        STA $D015
        JSR L858F                       ; CBM_COMBYT
        LDA $D018
        AND #$04
        BNE +
        LDA #$CC
+       CLC
        ADC #$03
        STA $15
        LDA #$F7
        STA $14
        LDY $FB
        TXA
        STA ($14),Y
        JSR L86BA                       ; CBM_CHKCOM, get byte, and check for $00 - $0f
        TXA
        LDX $FB
        STA $D026,X 
        JSR L85A1                       ; CBM_CHKCOM
        LDA #$1B
        JSR LB7EB
        JSR L85A1                       ; CBM_CHKCOM
        LDA #$1C
        BNE LB7EB
LB863   JSR L8683                       ; CBM_GETNUM
        CMP #$02
        BCC LB81E
        JMP L867E                       ; ILLEGAL QUANTITY
; ----------------------------------------------
; - $B86D MOBSET -------------------------------
; ----------------------------------------------
CMD_MOBSET
        JSR L86C7                       ; get byte into Y, set bit 0 to 7 in accu, and save to $02
        STA $FA
        TYA
        ASL
        STA $F9
        JSR L85A1                       ; CBM_CHKCOM
        JSR LB863
        TXA
LB87D   LDY $F9
        STA $CFFF,Y 
        LDA $14
        STA $CFFE,Y 
        LDA $FA
        LDX $15
        LDY #$10
        JMP LB7F3
; ----------------------------------------------
; - $B890 HIRES --------------------------------
; ----------------------------------------------
CMD_HIRES
; clear graphic area
        LDA #$00
        LDX #$E0
        STA $FB
        STX $FC
        LDX #$1F
        TAY
-       STA ($FB),Y
        INY
        BNE -
        INC $FC
        DEX
        BNE -
        LDY #$3F
-       STA ($FB),Y
        DEY
        BPL -
; end clear area
LB8AC   JSR L86BD                       ; get byte, and check for $00 - $0f
        TXA
        ASL                             ;
        ASL                             ; move low nibble
        ASL                             ; to high nibble
        ASL                             ;
        STA $CA09                       ; store
        JSR L86BA                       ; CBM_CHKCOM, get byte, and check for $00 - $0f
        TXA
        ORA $CA09                       ; ORA with high nibble
        STA $CA09                       ; store it
        LDX #$FB                        ;
-       STA $CBFF,X                     ;
        STA $CCF9,X                     ; set color
        STA $CDF3,X                     ;
        STA $CEEC,X                     ;
        DEX
        BNE -                           ; loop, else switch on hires graphic mode
; ----------------------------------------------
; - $B8D2 GRAPHIC ------------------------------
; ----------------------------------------------
CMD_GRAPHIC
        BNE LB8AC                       ; branch if we have values
        LDA #$94                        ;
        STA $DD00                       ;
        LDA #$3B                        ; switch on
        STA $D011                       ; hires graphic mode
        LDA #$39                        ;
        STA $D018                       ;
        RTS
; ----------------------------------------------
; - $B8E4 HICOL --------------------------------
; ----------------------------------------------
CMD_HICOL
        JSR L86BD                       ; get byte, and check for $00 - $0f
        TXA
        ASL
        ASL
        ASL
        ASL
        STA $CA09
        JSR L86BA                       ; CBM_CHKCOM, get byte, and check for $00 - $0f
        TXA
        ORA $CA09
        STA $CA09
        RTS
; ----------------------------------------------
; - $B8FA PLOT ---------------------------------
; ----------------------------------------------
CMD_PLOT
        JSR L8683                       ; CBM_GETNUM
        TXA
        PHA
        JSR L858F                       ; CBM_COMBYT
        STX $F7
        PLA
        JMP LB90C
---------------------------------
LB908   STX $14
        STY $15
LB90C   JSR LB93F
        BCS LB93C
        LDX $F7
        BEQ ++
        DEX
        BEQ +
        EOR ($14),Y
        !by $2c
+       ORA ($14),Y
        JMP LB924
---------------------------------
++      EOR #$FF
        AND ($14),Y
LB924   STA ($14),Y
        LDA $15
        SBC #$DF
        LSR
        ROR $14
        LSR
        ROR $14
        LSR
        ROR $14
        ORA #$CC
        STA $15
        LDA $CA09
        STA ($14),Y
LB93C   JMP L8691                       ; switch on kernel
---------------------------------
LB93F   CMP #$C8                        ; 
        BCS LB981
        TAX
        LDA $14
        LDY $15
        BEQ +
        DEY
        SEC
        BNE LB981
        CMP #$40
        BCS LB981
+       TAY
        AND #$F8
        STA $14
        TYA
        AND #$07
        TAY
        TXA
        AND #$07
        ADC $14
        STA $14
        TXA
        LSR
        LSR
        LSR
        STA $5B
        TAX
        LDA #$00
        LSR $5B
        ROR
        LSR $5B
        ROR
        ADC $14
        STA $14
        TXA
        ADC $15
        ADC $5B
        ADC #$E0
        STA $15
        LDA LB3B8,Y 
LB981   LDY #$00
        TAX
        JSR L8699                       ; switch off kernal
        TXA
        RTS
---------------------------------
LB989   LDX #$00
        STX $5C
        STX $5D
        LDY #$10
-       ASL $57
        ROL $58
        ROL $5C
        ROL $5D
        SEC
        LDA $5C
        SBC $5F
        TAX
        LDA $5D
        SBC $60
        BCC +
        STX $5C
        STA $5D
        INC $57
+       DEY
        BNE -
        RTS
; ----------------------------------------------
; - $B9AF DRAW ---------------------------------
; ----------------------------------------------
CMD_DRAW
        LDA #$00
        STA $F9
        JSR L8683                       ; CBM_GETNUM
        STY $FB
        STA $FC
        STX $FD
        JSR L85A1                       ; CBM_CHKCOM
        JSR L8683                       ; CBM_GETNUM
        STX $FE
        JSR L858F                       ; CBM_COMBYT
LB9C7   STX $F7
LB9C9   LDX #$00
        STX $23
        SEC
        LDA $14
        SBC $FB
        STA $71
        LDA $15
        SBC $FC
        STA $72
        BCS +
        SEC
        LDA $FB
        SBC $14
        STA $71
        LDA $FC
        SBC $15
        STA $72
        LDX #$FF
+       STX $22
        SEC
        LDA $FE
        SBC $FD
        BCS +
        DEC $23
        EOR #$FF
        ADC #$01
+       STA $61
        ORA $71
        ORA $72
        BNE +
        LDA $FB
        LDX $FC
        STA $14
        STX $15
        LDA $FD
        JMP LBACA
---------------------------------
+       LDX #$00
        LDA $72
        BNE +
        LDA $71
        CMP $61
        BCC LBA76
+       STX $59
        STX $5A
LBA1F   LDY $61
        STY $5B
        JSR LA560
        LDA $71
        LDX $72
        STA $5F
        STX $60
        JSR LB989
        LDA $FB
        BIT $22
        BMI +
        CLC
        ADC $59
        STA $14
        LDA $FC
        ADC $5A
        JMP ++
---------------------------------
+       SEC
        SBC $59
        STA $14
        LDA $FC
        SBC $5A
++      STA $15
        LDA $FD
        BIT $23
        BMI +
        CLC
        ADC $57
        JMP ++
---------------------------------
+       SEC
        SBC $57
++      JSR LBACA
        INC $59
        BNE +
        INC $5A
+       LDA $5A
        CMP $72
        BEQ +
        BCC LBA1F
        RTS
---------------------------------
+       LDA $71
        CMP $59
        BCS LBA1F
        RTS
---------------------------------
LBA76   STX $F8
        STX $60
        LDA $71
        LDX $72
        STA $59
        STX $5A
LBA82   LDA $F8
        STA $5B
        JSR LA560
        LDA $61
        STA $5F
        JSR LB989
        LDA $FB
        BIT $22
        BMI +
        CLC
        ADC $57
        STA $14
        LDA $FC
        ADC $58
        JMP ++
---------------------------------
+       SEC
        SBC $57
        STA $14
        LDA $FC
        SBC $58
++      STA $15
        LDA $FD
        BIT $23
        BMI +
        CLC
        ADC $F8
        JMP ++
---------------------------------
+       SEC
        SBC $F8
++      JSR LBACA
        INC $F8
        BEQ +
        LDA $61
        CMP $F8
        BCS LBA82
+       RTS
---------------------------------
LBACA   LDX $F9
        BNE +
        JMP LB90C
---------------------------------
+       LDX $F7
--      LDY #$96
-       DEY
        BNE -
        DEX
        BNE --
        JMP LB87D
; ----------------------------------------------
; - $BADE MMOB ---------------------------------
; ----------------------------------------------
CMD_MMOB
        JSR L86C7                       ; get byte into Y, set bit 0 to 7 in accu, and save to $02
        STA $FA
        TYA
        ASL
        STA $F9
        JSR L85A1                       ; CBM_CHKCOM
        JSR LB863
        STY $FB
        STA $FC
        STX $FD
LBAF3   JSR L85A1                       ; CBM_CHKCOM
        JSR LB863
        STX $FE
        JSR L86EE                       ; CBM_CHKCOM, CBM_GETBYT increased by one
        JMP LB9C7
; ----------------------------------------------
; - $BB01 MOVE ---------------------------------
; ----------------------------------------------
CMD_MOVE
        JSR L86C7                       ; get byte into Y, set bit 0 to 7 in accu, and save to $02
        STA $FA
        AND $D010
        BEQ +
        LDA #$01
+       STA $FC
        TYA
        ASL
        STA $F9
        TAY
        LDA $CFFE,Y 
        STA $FB
        LDA $CFFF,Y 
        STA $FD
        JMP LBAF3
; ----------------------------------------------
; - $BB21 CLRVIC -------------------------------
; ----------------------------------------------
CMD_CLRVIC
        LDY #$0A
-       LDA $ECDC,Y 
        STA $D024,Y 
        DEY
        BNE -
        TAX
        TYA
-       STA $D01A,X 
        DEX
        BNE -
        STA $D017
        STA $D015
        LDX #$11
-       STA $CFFF,X 
        DEX
        BNE -
        RTS
; ----------------------------------------------
; - $BB43 REC ----------------------------------
; ----------------------------------------------
CMD_REC
        LDA #$00
        !by $2c
; ----------------------------------------------
; - $BB46 BOX ----------------------------------
; ----------------------------------------------
CMD_BOX
        LDA #$FF
        PHA
        JSR L8683                       ; CBM_GETNUM
        STY $FB
        STA $FC
        STX $FD
        JSR L85A1                       ; CBM_CHKCOM
        JSR L8683                       ; CBM_GETNUM
        STY $F9
        STA $FA
        STX $F8
        JSR L858F                       ; CBM_COMBYT
        STX $F7
        SEC
        LDA $FB
        ADC $F9
        STA $22
        TAX
        LDA $FC
        ADC $FA
        STA $23
        STA $25
        CLC
        LDA $FD
        ADC $F8
        STA $02
        PLA
        BEQ LBBA8
        INC $02
LBB7F   TXA
        BNE +
LBB82   DEC $23
+       DEC $22
        LDA $02
        STA $FE
-       DEC $FE
        LDX $22
        LDY $23
        LDA $FE
        JSR LB908
        LDA $FE
        CMP $FD
        BNE -
        LDX $22
        CPX $FB
        BNE LBB7F
        LDA $23
        CMP $FC
        BNE LBB7F
        RTS
---------------------------------
LBBA8   STX $24
LBBAA   TXA
        BNE +
        DEC $23
+       DEC $22
        DEX
        LDY $23
        LDA $FD
        JSR LB908
        LDX $22
        LDY $23
        LDA $02
        JSR LB908
        LDX $22
        CPX $FB
        BNE LBBAA
        LDA $23
        CMP $FC
        BNE LBBAA
        LDA $24
        BNE +
        DEC $25
+       DEC $24
        LDX $F8
        BEQ LBBF9
        DEX
        BEQ LBBDF
        INC $FD
LBBDF   DEC $02
        LDX $FB
        LDY $FC
        LDA $02
        JSR LB908
        LDX $24
        LDY $25
        LDA $02
        JSR LB908
        LDA $FD
        CMP $02
        BNE LBBDF
LBBF9   RTS
; ----------------------------------------------
; - $BBFA PAINT --------------------------------
; ----------------------------------------------
CMD_PAINT
        JSR L8683                       ; CBM_GETNUM
        STY $FB
        STA $FC
        STX $FD
        JSR L858F                       ; CBM_COMBYT
        STX $F7
        JSR LBC81
        BNE LBBF9
        LDX #$D0
        STY $22
        STX $23
LBC13   STY $24
        STY $25
-       DEC $FD
        JSR LBC81
        BEQ -
        INC $FD
LBC20   LDX $FB
        LDY $FC
        LDA $FD
        JSR LB908
        LDX $FB
        BNE +
        DEC $FC
+       DEC $FB
        LDA $24
        JSR LBCA3
        STX $24
        CLC
        LDA $FB
        ADC #$02
        STA $FB
        BCC +
        INC $FC
+       LDA $25
        JSR LBCA3
        STX $25
        LDX $FB
        BNE +
        DEC $FC
+       DEC $FB
        INC $FD
        JSR LBC81
        BEQ LBC20
        LDX #$02
        LDA $23
        CMP #$D0
        BNE +
        LDA $22
        BEQ LBCA2
+       SEI
        LDA #$3C
        STA $01
-       LDA $22
        BNE +
        DEC $23
+       DEC $22
        LDA ($22),Y
        STA $FB,X 
        DEX
        BPL -
        JSR LB617
        JSR L8643                       ; check for stop key pressed
        BNE LBC13
LBC81   LDX $FB
        LDY $FC
        LDA $FD
LBC87   STX $14
        STY $15
        JSR LB93F
        BCS +
        STA $02
        AND ($14),Y
        LDX $F7
        BNE ++
        EOR $02
        !by $2c
+       LDA #$FF
++      TAX
        JSR L8691                       ; switch on kernel
        TXA
LBCA2   RTS
---------------------------------
LBCA3   PHA
        JSR LBC81
        BNE LBCD4
        PLA
        BNE LBCD7
        LDA $23
        CMP #$DF
        BCC ++
        BNE +
        LDA $22
        CMP #$FE
        BCC ++
+       JMP LABD2
---------------------------------
++      SEI
        LDA #$3C
        STA $01
-       LDA $FB,X 
        STA ($22),Y
        INC $22
        BNE +
        INC $23
+       INX
        CPX #$03
        BNE -
        JMP LB617
---------------------------------
LBCD4   PLA
        LDX #$FF
LBCD7   INX
        RTS
; ----------------------------------------------
; - $BCD9 TEST ---------------------------------
; ----------------------------------------------
CMD_TEST
        LDA $14                         ;
        PHA                             ; save $14/$15
        LDA $15                         ;
        PHA                             ;
        JSR L8683                       ; CBM_GETNUM, get address and byte
        TXA                             ; get byte into accu
        JSR LB93F
        LDX #$00
        BCS +
        AND ($14),Y
        BEQ +
        INX
+       PLA                             ;
        STA $15                         ; restore $14/$15
        PLA                             ;
        STA $14                         ;
        JSR L8691                       ; switch on kernel
        JMP L8A0C
; ----------------------------------------------
; - $BCFB SWAP ---------------------------------
; ----------------------------------------------
CMD_SWAP
        JSR L85B9                       ; CBM_PTRGET
        STA $FB
        STY $FC
        LDA $0D                         ; variables type $00=num,$ff=string,
        PHA
        LDA $0E                         ; Numeric var type; $00=floating-point, $80=integer 
        PHA
        JSR L85A1                       ; CBM_CHKCOM
        JSR L85B9                       ; CBM_PTRGET
        STA $FD
        STY $FE
        PLA                             ; $0e first variable numeric type
        TAX
        PLA                             ; $0d first variable type
        CMP $0D                         ; compare the 2 variable types
        BNE ++                          ; if it not match, type mismatch error
        TAY                             ; variable type
        BNE +++                         ; branch if string variable
        CPX $0E                         ; check if numeric type match
        BNE ++                          ; type mismatch error
        TXA                             ; 
        BPL +                           ; branch if floating-point
        LDY #$01                        ; integer variable pointer size
        !by $2c
+       LDY #$04                        ; floating-point variable pointer size
        !by $2c
+++     LDY #$02                        ; string variable pointer size
-       LDA ($FB),Y                     ;
        TAX                             ;
        LDA ($FD),Y                     ; exchange variables pointer
        STA ($FB),Y                     ;
        TXA                             ;
        STA ($FD),Y
        DEY
        BPL -                           ; loop 
        RTS
---------------------------------
++      JMP LADA8                       ; TYPE MISMATCH
; ----------------------------------------------
; - $BD3C DOKE ---------------------------------
; ----------------------------------------------
; writes an 16bit value into a memory address
CMD_DOKE
        JSR L85D3                       ; CBM_FRMNUM,CBM_GETADR
        STY $FB                         ; store low byte
        STA $FC                         ; store high byte
        JSR L85A1                       ; CBM_CHKCOM
        JSR L85D3                       ; CBM_FRMNUM,CBM_GETADR
        LDY #$01                        ; pointer
        STA ($FB),Y                     ; save content from $15 as high byte
        LDA $14                         ; get low byte
        DEY                             ; decrement pointer
        STA ($FB),Y                     ; save low byte
        RTS
---------------------------------
; check the input for 'ON' or 'OFF'
LBD53   LDX #$80                        ; preload for ON
        CMP #$91                        ; if 'ON'
        BEQ +
        LDA #$63                        ; check for 'OFF'
        JSR L862F                       ; $AEFF, check for a specific value
        LDX #$00                        ; preload for OFF
        LDA #$33                        ; token 'OFF'
+       JSR L862F                       ; $AEFF, check for a specific value
        TXA
        RTS                             ; returns #$80 ON, $00 OFF
; ----------------------------------------------
; - $BD67 BIT ----------------------------------
; ----------------------------------------------
; set or clear a bit in defined memory address
CMD_BIT
        JSR LBD53                       ; check the input for 'ON' or 'OFF'
        STA $FB                         ; indicator for set or clear
        JSR L85D3                       ; CBM_FRMNUM,CBM_GETADR
        JSR L85A1                       ; CBM_CHKCOM
        JSR L86C7                       ; get byte into Y, set bit 0 to 7 in accu, and save to $02
        JSR L8699                       ; switch off kernal
        LDA $02                         ; get bit no. from $02
        LDY #$00
        LDX $FB                         ; indicator
        BNE +                           ; branch for 'ON'
        EOR #$FF                        ; 
        AND ($14),Y                     ; clear bit
        !by $2c
+       ORA ($14),Y                     ; set bit
        STA ($14),Y                     ; save to memory address
        JMP L8691                       ; switch on kernel
; ----------------------------------------------
; - $BD8C BREAK --------------------------------
; ----------------------------------------------
; switches the function of the break key on or off
CMD_BREAK
        JSR LBD53                       ; check the input for 'ON' or 'OFF'
        EOR #$80                        ; 
        STA $CA1F                       ; switch BREAK mode
        RTS
; ----------------------------------------------
; - $BD95 VARY ---------------------------------
; ----------------------------------------------
; switches a memory address between 2 values, with a defined frequency
; the memory address must be difined in FIX command
CMD_VARY
        BEQ +
        JSR L8598                       ; CBM_GETBYT
        STX $CA06                       ; set as first value
        JSR L858F                       ; CBM_COMBYT
        STX $CA05                       ; set as second value
        JSR L86EE                       ; CBM_CHKCOM, CBM_GETBYT increased by one
        STX $CA07                       ; set as change frequency
        LDA #$02                        ; $02 = vary on
        STA $CA08                       ; used in IRQ handling
        !by $2c
+       LDA #$00                        ; $000 = vary off
        STA $CA04                       ; switch vary on or off
        RTS
; ----------------------------------------------
; - $BDB5 FIX ----------------------------------
; ----------------------------------------------
; defines the memory address for the vary command
CMD_FIX
        JSR L85D3                       ; CBM_FRMNUM,CBM_GETADR
        SEI                             ; prevent changes from IRQ
        STY $CA1D                       ; set memory address
        STA $CA1E
        CLI
        RTS
; ----------------------------------------------
; - $BDC1 COMMANDS -----------------------------
; ----------------------------------------------
; list all available commands in 3 pages on the screen
; a key press switches to the next screen
CMD_COMMANDS
        LDA #<CMDS-1                    ; load command table
        LDX #>CMDS-1
        STA $FB                         ; store it into FB/FC
        STX $FC
LBDC9   JSR CMD_CLS                     ; clear screen
LBDCC   LDX #$09                        ; single command char amount
LBDCE   JSR L8578                       ; increase $FB/$FC by 1, and load accu with the value from ($FB),y
        BEQ LBDFD                       ; print return if finished
        BMI LBDDC                       ; branch if it is the last char in one command
        DEX                             ; else decrement char counter
        JSR CBM_CHROUT                  ; output the char
        JMP LBDCE                       ; next char
---------------------------------
LBDDC   CMP #$83                        ; check for a placeholder
        BEQ LBDCE                       ; get next command
        AND #$7F                        ; else it was the last char of a command, switch to lower case
        JSR CBM_CHROUT                  ; print on screen
-       JSR P_SPC                       ; add a space                       
        DEX                             ; decrement char counter
        BNE -                           ; loop print space
        LDA $D6                         ; load value of actual screen line
        CMP #$11                        ; check amount
        BCC LBDCC                       ; next line
-       JSR $F13E                       ; else wait for key press
        TAX                             
        BEQ -
        JSR L8643                       ; check for stop key pressed
        JMP LBDC9                       ; go output next page
---------------------------------
LBDFD   JMP P_RET
---------------------------------

CMDADD1
LBE00   !word CMD_YPOS-1
        !word CMD_PENX-1
        !word CMD_PENY-1
        !word CMD_INKEY-1
        !word CMD_ERRLN-1
        !word CMD_ERRN-1
        !word CMD_ERR_STR-1
        !word CMD_ASSCII-1
LBE10   !word CMD_BSC-1
        !word CMD_DEC-1
        !word CMD_HEX_STR-1
        !word CMD_BIN_STR-1
        !word CMD_ROW-1
        !word CMD_DUP-1
        !word CMD_INSERT-1
        !word CMD_INST-1
LBE20   !word CMD_PLACE-1
        !word CMD_CHAR_STR-1
        !word CMD_SPRIT_STR-1
        !word CMD_USING-1
        !word CMD_BY-1
        !word CMD_DEEK-1
        !word CMD_CEEK-1
        !word CMD_CHECK-1
LBE30   !word CMD_ROOT-1
        !word CMD_ROUND-1
        !word CMD_EVAL-1
        !word CMD_EXOR-1
        !word CMD_JOY-1
        !word CMD_BUMP-1
        !word CMD_TEST-1
        !word $F1F1     ; $83
LBE40   !word CMD_AUTO-1
        !word $F1F1     ; $83
        !word CMD_RENUM-1
        !word CMD_DELETE-1
        !word CMD_OLD-1
        !word CMD_TRACE-1
        !word CMD_STRACE-1
        !word CMD_MONITOR-1
LBE50   !word CMD_SET-1
        !word $F1F1     ; $83
        !word $F1F1     ; $83
        !word CMD_DUMP-1
        !word $F1F1     ; $83
        !word CMD_MATRIX-1
        !word $F1F1     ; $83
        !word CMD_FIND-1
LBE60   !word CMD_KEY-1
        !word CMD_SHOW-1
        !word CMD_OFF-1
        !word CMD_DELAY-1
        !word CMD_PAGE-1
        !word CMD_MEMORY-1
        !word CMD_ELSE-1
        !word CMD_BEGIN-1
LBE70   !word CMD_BELSE-1
        !word CMD_BEND-1
        !word CMD_REPEAT-1
        !word $F1F1     ; $83
        !word $F1F1     ; $83
        !word $F1F1     ; $83
        !word $F1F1     ; $83
        !word CMD_UNTIL-1
LBE80   !word CMD_LOOP-1
        !word CMD_EXIT-1
        !word CMD_END_LOOP-1
        !word CMD_PROC-1
        !word CMD_EXEC-1
        !word CMD_CALL-1
        !word CMD_END_PROC-1
        !word CMD_SGOTO-1
LBE90   !word CMD_POP-1
        !word CMD_RESET-1
        !word CMD_CASE_OF-1
        !word CMD_ENDCASE-2
        !word CMD_WHEN-1
        !word CMD_OTHERWISE-1
        !word CMD_HELP-1
        !word CMD_ON_ERROR-1
LBEA0   !word CMD_NO_ERROR-1
        !word CMD_RESUME-1
        !word CMD_FETCH-1
        !word CMD_GETKEY-1
        !word CMD_LOCATE-1
        !word CMD_CENTER-1
        !word CMD_CHRHI-1
        !word CMD_CHRLO-1
LBEB0   !word CMD_CLS-1
        !word CMD_SPELL-1
        !word CMD_PRESS-1
        !word CMD_COLOR-1
        !word CMD_FCOL-1
        !word $F1F1     ; $83
        !word CMD_FCHR-1
        !word CMD_FILL-1
LBEC0   !word CMD_SCRINV-1
        !word CMD_SCOPY-1
        !word $F1F1     ; $83
        !word $F1F1     ; $83
        !word CMD_CHANGE-1
        !word CMD_SUP-1
        !word CMD_SDOWN-1
        !word CMD_SRIGHT-1
LBED0   !word CMD_SLEFT-1
        !word CMD_FLASH-1
        !word CMD_DLOAD-1
        !word CMD_DSAVE-1
        !word CMD_DVERIFY-1
        !word CMD_DMERGE-1
        !word CMD_CHAIN-1
        !word CMD_GLOAD-1
LBEE0   !word CMD_GSAVE-1
        !word CMD_BLOAD-1
        !word CMD_BSAVE-1
        !word CMD_CLOAD-1
        !word CMD_CSAVE-1
        !word CMD_DIR-1
        !word CMD_DISK-1
        !word CMD_ERROR-1
LBEF0   !word CMD_MERGE-1
        !word CMD_HEADER-1
        !word CMD_←L-1
        !word CMD_←S-1
        !word CMD_←V-1
        !word CMD_←R-1
        !word CMD_←M-1
        !word $F1F1     ; $83
---------------------------------
CMDADD2
LBF00   !word CMD_TYPE-1
        !word CMD_TEXTCOPY-1
        !word CMD_GRAPHCOPY-1
        !word CMD_NCHAR-1
        !word CMD_SWITCH-1
        !word CMD_CHRINV-1
        !word CMD_TWIST-1
        !word CMD_MIRX-1
LBF10   !word CMD_MIRY-1
        !word CMD_CHAR-1
        !word CMD_CHRCOPY-1
        !word CMD_CHROR-1
        !word CMD_CHRAND-1
        !word CMD_SCROLL-1
        !word CMD_EMPTY-1
        !word CMD_DEFMOB-1
LBF20   !word CMD_MULTI-1
        !word CMD_MOBEX-1
        !word CMD_CLEAR-1
        !word CMD_MOBSET-1
        !word CMD_MMOB-1
        !word CMD_MOVE-1
        !word CMD_CLRVIC-1
        !word CMD_CREATE-1
LBF30   !word CMD_MOB-1
        !word CMD_TURNMOB-1
        !word CMD_BLCOPY-1
        !word CMD_BLOR-1
        !word CMD_BLAND-1
        !word CMD_ERASE-1
        !word CMD_BLINV-1
        !word $F1F1     ; $83
LBF40   !word CMD_REFLECTX-1
        !word $F1F1     ; $83
        !word CMD_REFLECTY-1
        !word CMD_SCRMOB-1
        !word CMD_HIRES-1
        !word CMD_GRAPHIC-1
        !word CMD_HICOL-1
        !word CMD_NRM-1
LBF50   !word CMD_PLOT-1
        !word $F1F1     ; $83
        !word $F1F1     ; $83
        !word CMD_DRAW-1
        !word $F1F1     ; $83
        !word CMD_REC-1
        !word $F1F1     ; $83
        !word CMD_BOX-1
LBF60   !word CMD_CIRCLE-1
        !word CMD_ARC-1
        !word CMD_PAINT-1
        !word CMD_GSHAPE-1
        !word CMD_SHAPE-1
        !word CMD_GBLOCK-1
        !word CMD_SBLOCK-1
        !word CMD_TEXT-1
LBF70   !word CMD_WINDOW-1
        !word CMD_REVERS-1
        !word CMD_SCNCLR-1
        !word $F1F1     ; $83
        !word $F1F1     ; $83
        !word $F1F1     ; $83
        !word $F1F1     ; $83
        !word CMD_GRCOL-1
LBF80   !word CMD_VOL-1
        !word CMD_ENVELOPE-1
        !word CMD_WAVE-1
        !word CMD_SOUND-1
        !word CMD_PULSE-1
        !word CMD_CLRSID-1
        !word CMD_MUSIC-1
        !word CMD_PLAY-1
LBF90   !word CMD_BEEP-1
        !word CMD_SWAP-1
        !word CMD_DOKE-1
        !word CMD_BIT-1
        !word $FCE1                     ; kilL
        !word CMD_BREAK-1
        !word CMD_VARY-1
        !word CMD_FIX-1
LBFA0   !word CMD_PAUSE-1
        !word CMD_COMMANDS-1
        !word CMD_COMSHIFT-1
        !word $F1F1     ; $83
        !word CMD_RAPID-1
        !word CMD_SCREEN-1
        !word CMD_GLOBAL-1
        !word CMD_LOCAL-1
LBFB0   !word CMD_GO64-1
        !word CMD_LOMEM-1
        !word CMD_HIMEM-1
        !word CMD_CLREOL-1
        !word CMD_BCKGND-1
        !word $F1F1     ; $83
        !word CMD_SQBROPN-1     ; "[",$db
        !word CMD_SQBRCLS-1     ; "]",$dd
LBFC0   !word $F1F1     ; $83
        !word $F1F1     ; $83
        !word $F1F1     ; $83
        !word $F1F1     ; $83
; ----------------------------------------------
; - $BFC8 CLREOL -------------------------------
; ----------------------------------------------
; clears from cursor position to the end of a basic line
; there is an eror by mixing logical and physical values
CMD_CLREOL
        LDY $D3                         ; LOGICAL column (#0 - #80)
        LDA #$20                        ;
-       STA ($D1),Y                     ; clr position
        INY                             ;
        CPY #$28                        ; PHYSICAL column amount
        BCC -                           ; loop
        RTS
; ----------------------------------------------
; - $BFD4 SCNCLR -------------------------------
; ----------------------------------------------
; clers the graphic scrren, colors stays untouched
CMD_SCNCLR
        LDA #$00                        ; byte for clr
        !by $2c
; ----------------------------------------------
; - $BFD7 REVERS -------------------------------
; ----------------------------------------------
; inverts the whole graphic screen
CMD_REVERS
        LDA #$FF
        STA $02                         ; temp store
        LDY #$00                        ; low byte grphic area
        LDX #$E0                        ; high byte graphic area
        STY $FB                         ;
        STX $FC                         ;
        JSR L8699                       ; switch off kernal
        LDX #$1F                        ; page amount
-       BNE LBFEC
        LDY #$40                        ; byte amount
LBFEC   DEY
        LDA ($FB),Y
        EOR #$FF
        AND $02
        STA ($FB),Y
        TYA
        BNE LBFEC                       ; loop bytes
        INC $FC
        DEX
        BPL -                           ; next page
        JMP L8691                       ; switch on kernel
---------------------------------
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;				  MAIN OF THE Q3				  ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;LABEL			DIRECTIVE	VALUE				COMMENT	
				AREA main,	CODE,	READONLY,	ALIGN=2
				THUMB				
				
				IMPORT		OutStr
				IMPORT		CONVRT
				IMPORT		PULSE_INIT
				IMPORT		EDGE_TIMER
				IMPORT		OutChar
				EXPORT		__main
					
TIMER1_ICR		EQU 0x40031024 ; Timer Interrupt Clear
TIMER1_RIS		EQU 0x4003101C ; Timer Interrupt Status
GPIO_PORTB_DATA	EQU 0x40005040 ; Access BIT4
GPIO_PORTB_DATA0 EQU 0x40005004
TIMER1_TAR		EQU	0x40031048 ; Timer register
TIMER0_CTL		EQU 0x4003000C
	
NUM				EQU	0X20000500
;R5 KACINCI EDGE
;R6 BIR ONCEKI TIME
;R7 HIGH = PULSE WIDTH
;R8 LOW
;R0 PERIOD
;R1 DUTY CYCLE

;pb4 echo
;pf2 trig

MSG     	DCB     	"DISTANCE IN MM: "
			;DCB			0x0D		; Carriage return is like new line
			DCB			0x04		; it is like EOF or \0	

	
__main			PROC
				BL		EDGE_TIMER
				BL		PULSE_INIT
				MOV		R5,#0			;KACINCI EDGE OLDUGUNU ANLAYACAGIZ	
				
LOOP			LDR		R1,=TIMER1_RIS
				LDR		R0,[R1]
				CMP		R0,#0X04
				BNE 	LOOP
			
				LDR		R1,=TIMER1_ICR
				LDR		R0,[R1]
				ORR		R0,#0X04
				STR		R0,[R1]
				
				LDR		R1,=GPIO_PORTB_DATA
				LDR		R0,[R1]
			
				ADD		R5,#1
				CMP		R5,#1
				BEQ		FIRST
				B		SECOND
				
FIRST			LDR		R1,=TIMER1_TAR
				LDR		R6,[R1]
				;LDR R1, =TIMER0_CTL ; disable timer during setup LDR R2, [R1]	;BUNU KALDIRMAK YANLIS DEGER ALMA SORUNUNU COZDU
				;BIC R2, R2, #0x01
				;STR R2, [R1]
				B		FINISH



SECOND			LDR		R1,=TIMER1_TAR
				LDR		R2,[R1]
				B		POSEDGE

POSEDGE			;SUB		R7,R6,R2
				CMP		R6,R2
				SUBLO	R7,R2,R6
				SUBHI	R7,R6,R2
				B		EXIT

				
CALC			CPY		R4,R7
				LDR		R5,=NUM
				BL		CONVRT
				LDR		R5,=NUM
				BL		OutStr




				LDR		R5,=34
				LDR		R6,=3200
				MUL		R7,R5
				UDIV	R7,R6	;MM DISTANCE
				CPY		R4,R7
				LDR		R5,=MSG
				BL		OutStr
				
				LDR		R5,=NUM
				BL		CONVRT
				LDR		R5,=NUM
				BL		OutStr

				MOV		R5,#0
				MOV		R6,#0
				MOV		R7,#0
				LDR 	R1, =TIMER0_CTL
				LDR 	R2, [R1]
				ORR 	R2, R2, #0x03 ; set bit0 to enable
				STR 	R2, [R1] ; and bit 1 to stall on debug					
				B		FINISH


EXIT			CMP		R5,#0X02
				BEQ		CALC
FINISH			LDR		R0,=TIMER1_ICR
				ORR		R1,#0X04			;CLEAR BIT2, BECAUSE CAPTURE MODE
				STR		R1,[R0]

				B		LOOP
	
				ENDP				
				END

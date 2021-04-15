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
	
SYSCTL_RCGCGPIO 	EQU 0x400FE608 ; GPIO Gate Control
SYSCTL_RCGCTIMER 	EQU 0x400FE604 ; GPTM Gate Control

	
	
;GPIO Registers
GPIO_PORTF_DATA		EQU 0x40025008 ; Access BIT1
GPIO_PORTF_DIR 		EQU 0x40025400 ; Port Direction
GPIO_PORTF_AFSEL	EQU 0x40025420 ; Alt Function enable
GPIO_PORTF_DEN 		EQU 0x4002551C ; Digital Enable
GPIO_PORTF_AMSEL 	EQU 0x40025528 ; Analog enable
GPIO_PORTF_PCTL 	EQU 0x4002552C ; Alternate Functions
	
NUM				EQU	0X20000500
;R5 KACINCI EDGE
;R6 BIR ONCEKI TIME
;R7 HIGH = PULSE WIDTH
;R8 LOW
;R0 PERIOD
;R1 DUTY CYCLE

;PB4 ECHO
;PB6 TRIG

MSG     	DCB     	"DISTANCE IN MM: "
			;DCB			0x0D		; Carriage return is like new line
			DCB			0x04		; it is like EOF or \0	

	
__main			PROC
	
				;LEDI YAKMAK ICIN AYARLAMA
				LDR R1, =SYSCTL_RCGCGPIO ; start GPIO clock
				LDR R0, [R1]
				ORR R0, R0, #0x20 ; set bit 5 for port F
				STR R0, [R1]
				NOP ; allow clock to settle
				NOP
				NOP
				LDR R1, =GPIO_PORTF_DIR ; set direction of PF1
				LDR R0, [R1]
				ORR R0, R0, #0x02 ; set bit1 for output
				STR R0, [R1]
				LDR R1, =GPIO_PORTF_AFSEL ; regular port function
				LDR R0, [R1]
				BIC R0, R0, #0x02
				STR R0, [R1]
				LDR R1, =GPIO_PORTF_PCTL ; no alternate function
				LDR R0, [R1]
				BIC R0, R0, #0x000000F0
				STR R0, [R1]
				LDR R1, =GPIO_PORTF_AMSEL ; disable analog
				MOV R0, #0
				STR R0, [R1]
				LDR R1, =GPIO_PORTF_DEN ; enable port digital
				LDR R0, [R1]
				ORR R0, R0, #0x02
				STR R0, [R1]	
	
	
	
	
	
	
	
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
				;LSR		R0,#4
				
				;ADD		R0,R0,R5
				;CMP		R0,#1
				;BNE		LOOP
				
				ADD		R5,#1
				CMP		R5,#1
				BEQ		FIRST
				B		SECOND
				
FIRST			LDR		R1,=TIMER1_TAR
				LDR		R6,[R1]
				;PUSH	{R5,LR,R0,R6}
				;CPY		R4,R6
				;LDR		R5,=NUM
				;BL		CONVRT
				;LDR		R5,=NUM
				;BL		OutStr
				;POP		{R5,LR,R0,R6}
				LDR R1, =TIMER0_CTL ; disable timer during setup LDR R2, [R1]
				BIC R2, R2, #0x01
				STR R2, [R1]
				B		FINISH



SECOND			LDR		R1,=TIMER1_TAR
				LDR		R2,[R1]
				;PUSH	{R5,LR,R0,R6}
				;CPY		R4,R2
				;LDR		R5,=NUM
				;BL		CONVRT
				;LDR		R5,=NUM
				;BL		OutStr
				;POP		{R5,LR,R0,R6}
				
				
				B		POSEDGE

POSEDGE			SUB		R7,R6,R2
				;CMP		R6,R2
				;CPYHI	R6,R2
				;BHI		EXIT
				;SUB		R7,R2,R6
				;LDR		R0,=0X10000	;FULL CYCLE
				;ADD		R7,R0
				CPY		R6,R2
				B		EXIT

				
CALC			LDR		R5,=34
				LDR		R6,=3200
				MUL		R7,R5
				UDIV	R7,R6	;MM DISTANCE
				CPY		R4,R7
				PUSH	{R4}
				;LDR		R5,=MSG
				;BL		OutStr
				
				
				;OUTPUT PART
				LDR		R5,=NUM
				BL		CONVRT
				LDR		R5,=NUM
				BL		OutStr
				
				
				;DELAY PART
				POP		{R4}
				CMP		R4,#420
				BHI		EXIT2
				LSL		R4,#1
LOOP2			SUB		R4,#1
				CMP		R4,#0
				BNE		LOOP2

EXIT2			MOV		R5,#0
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

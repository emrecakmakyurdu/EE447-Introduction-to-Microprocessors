;LABEL			DIRECTIVE	VALUE				COMMENT	
				AREA main,	CODE,	READONLY,	ALIGN=2
				THUMB				
				
				IMPORT		PWM_INIT
				IMPORT		InChar
				EXPORT		__main
					
;TIMER0A AND PB6 IS USED TO GENERATE PWM
;TIMER1A AND PF2 IS USED TO TEST THE PWM


;GPIO Registers
GPIO_PORTF_DATA		EQU 0x40025008 ; Access BIT1
GPIO_PORTF_DIR 		EQU 0x40025400 ; Port Direction
GPIO_PORTF_AFSEL	EQU 0x40025420 ; Alt Function enable
GPIO_PORTF_DEN 		EQU 0x4002551C ; Digital Enable
GPIO_PORTF_AMSEL 	EQU 0x40025528 ; Analog enable
GPIO_PORTF_PCTL 	EQU 0x4002552C ; Alternate Functions

;System Registers
SYSCTL_RCGCGPIO 	EQU 0x400FE608 ; GPIO Gate Control
SYSCTL_RCGCTIMER 	EQU 0x400FE604 ; GPTM Gate Control
	
TIMER0_MATCHR		EQU	0X40030030	;TIMER MATCH

MATCH			EQU		0X19
LOAD			EQU		0XFA
			

__main			PROC
				BL		PWM_INIT
				
				;GPIO INITIALIZATION FOR READING THE PWM
				;USIGN ANY PF0-1-2, ALL OF THEM ARE INPUT

				LDR R1, =SYSCTL_RCGCGPIO ; start GPIO clock
				LDR R0, [R1]
				ORR R0, R0, #0x20 ; set bit 5 for port F
				STR R0, [R1]
				NOP ; allow clock to settle
				NOP
				NOP
				
				LDR R1, =GPIO_PORTF_DIR ; set direction of PF1
				LDR R0, [R1]
				BIC R0, R0, #0xFF ; set ALL INPUT
				STR R0, [R1]
				LDR R1, =GPIO_PORTF_AFSEL ; regular port function
				LDR R0, [R1]
				BIC R0, R0, #0x02 ;PF1
				STR R0, [R1]
				LDR R1, =GPIO_PORTF_PCTL ; no alternate function
				LDR R0, [R1]
				BIC R0, R0, #0x000000F0 ;PF1
				STR R0, [R1]
				LDR R1, =GPIO_PORTF_AMSEL ; disable analog
				MOV R0, #0
				STR R0, [R1]
				LDR R1, =GPIO_PORTF_DEN ; enable port digital
				LDR R0, [R1]
				ORR R0, R0, #0x02
				STR R0, [R1]

LOOP			BL		InChar
				SUB		R5,#0X30
				CMP		R5,#0
				BLO		EXIT
				CMP		R5,#9
				BHI		EXIT
				
				LDR		R1,=LOAD
				LDR		R0,=MATCH
				MUL		R5,R0
				;SUB		R5,R1,R5
				LDR		R0,=TIMER0_MATCHR
				STR		R5,[R0]
				
EXIT			NOP
				B		LOOP

				ENDP
				END
					
					
	
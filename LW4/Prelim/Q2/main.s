;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;				  MAIN OF THE Q2				  ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;LABEL			DIRECTIVE	VALUE				COMMENT	
				AREA main,	CODE,	READONLY,	ALIGN=2
				THUMB				
				
				IMPORT		PULSE_INIT
				IMPORT		EDGE_TIMER
				EXPORT		__main
					
TIMER1_ICR		EQU 0x40031024 ; Timer Interrupt Clear
TIMER1_RIS		EQU 0x4003101C ; Timer Interrupt Status
GPIO_PORTB_DATA	EQU 0x40005040 ; Access BIT4
TIMER1_TAR		EQU	0x40031048 ; Timer register
;R5 KACINCI EDGE
;R6 BIR ONCEKI TIME
;R7 HIGH = PULSE WIDTH
;R8 LOW
;R0 PERIOD
;R1 DUTY CYCLE

	
__main			PROC
				BL		PULSE_INIT
				BL		EDGE_TIMER
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
				LSR		R0,#4
				
				ADD		R5,#1
				CMP		R5,#1
				BEQ		FIRST
				CMP		R5,#2
				BEQ		SECOND
				B		THIRD
				
FIRST			LDR		R1,=TIMER1_TAR
				LDR		R6,[R1]
				B		FINISH



SECOND			LDR		R1,=TIMER1_TAR
				LDR		R2,[R1]
				CMP		R0,#0
				BEQ		POSEDGE
				B		NEGEDGE



THIRD			LDR		R1,=TIMER1_TAR
				LDR		R2,[R1]
				CMP		R0,#0
				BEQ		POSEDGE
				B		NEGEDGE
				



POSEDGE			SUB		R7,R6,R2
				CMP		R6,R2
				CPYHI	R6,R2
				BHI		EXIT
				SUB		R7,R2,R6
				LDR		R0,=0X10000	;FULL CYCLE
				ADD		R7,R0
				CPY		R6,R2
				B		EXIT



NEGEDGE			SUB		R8,R6,R2
				CMP		R6,R2
				CPYHI	R6,R2
				BHI		EXIT
				SUB		R8,R2,R6
				LDR		R0,=0X10000	;FULL CYCLE
				ADD		R8,R0
				CPY		R6,R2
				B		EXIT
				
CALC			ADD		R0,R7,R8		;PERIOD
				;MOV		R3,#625
				;MOV		R4,#10
				;MUL		R2,R3
				;UDIV	R2,R4			;PERIOD IN NANOSECONDS
				
				;CPY		R0,R7 			;PULSE WIDTH
				;MUL		R0,R3
				;UDIV	R0,R4			;PULSE WIDTH IN NANOSECONDS
				;R7						;PULSE WIDTH
				
				MOV		R1,#100
				MUL		R1,R7
				ADD		R8,R7
				UDIV	R1,R8			;DUTY CYCLE
				MOV		R5,#0
				MOV		R6,#0
				MOV		R7,#0
				MOV		R8,#0
				B		FINISH


EXIT			CMP		R5,#0X03
				BEQ		CALC
FINISH			LDR		R0,=TIMER1_ICR
				ORR		R1,#0X04			;CLEAR BIT2, BECAUSE CAPTURE MODE
				STR		R1,[R0]

				B		LOOP
	
				ENDP				
				END

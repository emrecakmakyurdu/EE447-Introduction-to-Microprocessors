;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;				  ISR OF THE Q1					  ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PB_OUT				EQU		0X400053C0
GPIO_PORTB_ICR		EQU		0X4000541C
GPIO_PORTB_RIS		EQU		0X40005414	
	
ADC0_RIS 			EQU 0x40038004 	; Interrupt status
ADC0_PSSI 			EQU 0x40038028 	; Initiate sample
ADC0_SSFIFO3 		EQU 0x400380A8 	; Channel 3 results ADC0_PC EQU 0x40038FC4 ; Sample rate
ADC0_ISC			EQU	0X4003800C	;INTERRUPT STATUS AND CLEAR REGISTER
	
TIMER0_MBTCHR		EQU	0X40030034	;TIMER MATCH
TIMER1_MATCHR		EQU	0X40031030	;TIMER MATCH


;LABEL			DIRECTIVE	VALUE				COMMENT	
				AREA isr,	CODE,	READONLY,	ALIGN=2
				THUMB
					
				EXPORT	My_ST_ISR

My_ST_ISR		PROC
				PUSH		{LR}
				; initiate sampling by enabling sequencer 3 in ADC0_PSSI
Smpl 			LDR			R1,=ADC0_PSSI
				LDR 		R0, [R1]
				ORR 		R0, R0, #0x08 		; set bit 3 for SS3
				STR 		R0, [R1]
				; check for sample complete (bit 3 of ADC0_RIS set)
				LDR			R1, =ADC0_RIS
Cont 			LDR 		R0, [R1]
				ANDS 		R0, R0, #8
				BEQ 		Cont
				;branch fails if the flag is set so data can be read and flag is cleared
				LDR			R1, =ADC0_SSFIFO3
				LDR 		R0,[R1]
				;STR 		R0,[R5],#4 			;store the data
				LDR			R1,	=0X13ACA			;80586
				MUL			R0,	R1
				LDR			R1,	=0XF4240			;1000000
				UDIV		R0,	R1		
				CPY			R7, R0				;UPDATE R7
				
				MOV			R0,#165
				CMP			R7,R0
				BEQ			REDOFF
				BLO			RED
				BHI			BLUE
				
RED				MOV			R0,#0XFFFF
				MUL			R7,R0
				MOV			R0,#165
				UDIV		R7,R0
				LDR			R0,=TIMER0_MBTCHR	;RED
				STR			R7,[R0]			;DUTY CYCLE
				LDR			R0,=TIMER1_MATCHR
				LDR			R1,=0X01
				STR			R1,[R0]
				B			EXIT



BLUE			MOV			R0,#0XFFFF
				MUL			R7,R0
				MOV			R0,#165
				UDIV		R7,R0
				MOV			R0,#0XFFFF
				SUB			R7,R0
				LDR			R0,=TIMER1_MATCHR	;BLUE
				STR			R7,[R0]			;DUTY CYCLE
				LDR			R0,=TIMER0_MBTCHR
				LDR			R1,=0XFFFE
				STR			R1,[R0]
				B			EXIT	

REDOFF			LDR			R0,=TIMER1_MATCHR	;BLUE
				MOV			R7,#01
				STR			R7,[R0]			;DUTY CYCLE
				LDR			R0,=TIMER0_MBTCHR
				LDR			R1,=0XFFFE
				STR			R1,[R0]
				B			EXIT

				
EXIT			MOV 		R0, #8
				LDR			R1, =ADC0_ISC
				STR 		R0, [R1] 			; clear flag
				
				

				POP			{LR}
				BX			LR
				ALIGN
				ENDP
				END

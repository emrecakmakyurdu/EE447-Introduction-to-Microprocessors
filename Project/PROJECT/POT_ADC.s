ADC0_RIS 			EQU 0x40038004 	; Interrupt status
ADC0_PSSI 			EQU 0x40038028 	; Initiate sample
ADC0_SSFIFO3 		EQU 0x400380A8 	; Channel 3 results ADC0_PC EQU 0x40038FC4 ; Sample rate
ADC0_ISC			EQU	0X4003800C	;INTERRUPT STATUS AND CLEAR REGISTER

;LABEL			DIRECTIVE	VALUE				COMMENT	
				AREA pot,	CODE,	READONLY,	ALIGN=2
				THUMB				
				
				EXPORT		POT_ADC
					
;R7 STORES THE VOLTAGE VALUES BETWEEN 0-999
;GND PE3 3.3V
					
POT_ADC			PROC
				PUSH		{LR}
				; start sampling routine
				MOV			R7,#0				;R7 STORES THE VOLTAGE VALUES
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
				LDR			R1,=0X3B8F4			;CONVERT FFF TO 999 (MAX VALUE)
				MUL			R0,R1
				LDR			R1,=0XF4240
				UDIV		R0,R1
				MOV			R10,#10
				UDIV		R0,R10
				MUL			R0,R10
				CPY			R7,R0
				
EXIT			MOV 		R0, #8
				LDR			R1, =ADC0_ISC
				STR 		R0, [R1] 			; clear flag
				POP			{LR}
				BX			LR
				ENDP
				END
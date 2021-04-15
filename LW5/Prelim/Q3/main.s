;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;		   			MAIN OF Q3					  ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ADC0_RIS 			EQU 0x40038004 	; Interrupt status
ADC0_PSSI 			EQU 0x40038028 	; Initiate sample
ADC0_SSFIFO3 		EQU 0x400380A8 	; Channel 3 results ADC0_PC EQU 0x40038FC4 ; Sample rate
ADC0_ISC			EQU	0X4003800C	;INTERRUPT STATUS AND CLEAR REGISTER

;LABEL			DIRECTIVE	VALUE				COMMENT	
				AREA main,	CODE,	READONLY,	ALIGN=2
				THUMB				
				
				IMPORT		GPIOE_Init
				IMPORT		ADC0_Init
				IMPORT		OutChar
				EXPORT		__main
					
;R7 STORES THE VOLTAGE VALUES BETWEEN 0-330
					
__main			PROC
				BL			GPIOE_Init
				BL			ADC0_Init
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
				;STR 		R0,[R5],#4 			;store the data
				LDR			R1,	=0X13ACA			;80586
				MUL			R0,	R1
				LDR			R1,	=0XF4240			;1000000
				UDIV		R0,	R1
				CMP			R0,	R7
				BEQ			EXIT
				SUBHI		R2,	R0,R7
				SUBLO		R2,	R7,R0
				CMP			R2,	#0X14			;IF THE CHANGE IS HIGHER THAN 0.2V PRINT
				BLO			EXIT
					
PRINT			CPY			R7, R0				;UPDATE R7
				MOV			R10,#100
				UDIV		R5,	R0, R10
				MUL			R1,	R5,R10
				SUB			R0,	R1
				ADD			R5,	#48
				BL			OutChar
				LDR			R5,	=0X2E
				BL			OutChar
				MOV			R10,#10
				UDIV		R5, R0, R10
				MUL			R1,R5,R10
				SUB			R0,R1
				ADD			R5, #48
				BL			OutChar
				CPY			R5,R0
				ADD			R5, #48
				BL			OutChar
				MOV			R5, #0X0A
				BL			OutChar
				
EXIT			MOV 		R0, #8
				LDR			R1, =ADC0_ISC
				STR 		R0, [R1] 			; clear flag
				B 			Smpl
				


				ENDP
				END
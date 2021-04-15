;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;		  			MAIN OF Q1		  			  ;
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
				EXPORT		__main
					
;R0 STORES THE VOLTAGE VALUE BETWEEN 0X000-0XFFF
					
__main			PROC
				BL			GPIOE_Init
				BL			ADC0_Init
				
				; start sampling routine
				LDR 		R3, =ADC0_RIS 		; interrupt address
				LDR 		R4, =ADC0_SSFIFO3 	; result address
				LDR 		R2, =ADC0_PSSI 		; sample sequence initiate address
				LDR 		R6,= ADC0_ISC
				; initiate sampling by enabling sequencer 3 in ADC0_PSSI
Smpl 			LDR 		R0, [R2]
				ORR 		R0, R0, #0x08 		; set bit 3 for SS3
				STR 		R0, [R2]
				; check for sample complete (bit 3 of ADC0_RIS set)
Cont 			LDR 		R0, [R3]
				ANDS 		R0, R0, #8
				BEQ 		Cont
				;branch fails if the flag is set so data can be read and flag is cleared
				LDR 		R0,[R4]
				;STR 		R0,[R5],#4 			;store the data
				
				MOV 		R0, #8
				STR 		R0, [R6] 			; clear flag
				B 			Smpl
				


				ENDP
				END
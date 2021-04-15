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
				
				IMPORT		InitSysTick
				IMPORT		GPIOE_Init
				IMPORT		ADC0_Init
				IMPORT		PWM_INIT
				EXPORT		__main
					
;R7 STORES THE VOLTAGE VALUES BETWEEN 0-330
; PLEASE CONNECT PE3 TO MIDDLE OF POT, VCC AND GND ACCORDINGLY
					
__main			PROC
				BL			InitSysTick
				BL			PWM_INIT
				BL			GPIOE_Init
				BL			ADC0_Init
				; start sampling routine
				MOV			R7,#0				;R7 STORES THE VOLTAGE VALUES
LOOP			WFI				
				B			LOOP
				ENDP
				END
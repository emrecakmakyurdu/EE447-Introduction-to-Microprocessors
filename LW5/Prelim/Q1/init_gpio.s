;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;		   GPIO PORTE INITIALIZATION OF Q1		  ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PE_INP				EQU		0X40024020 ;0000_0010_0000
GPIO_PORTE_DIR_R	EQU		0X40024400
GPIO_PORTE_AFSEL_R	EQU		0X40024420
GPIO_PORTE_DEN_R	EQU		0X4002451C
GPIO_PORTE_AMSEL_R	EQU		0X40024528
GPIO_PORTE_PDR		EQU		0X40024514 ;514
SYSCTL_RCGC2_R		EQU		0X400FE608
GPIO_PORTE_IS		EQU		0X40024404
GPIO_PORTE_IBE		EQU		0X40024408
GPIO_PORTE_IEV		EQU		0X4002440C
GPIO_PORTE_IM		EQU		0X40024410
GPIO_PORTE_ICR		EQU		0X4002441C
GPIO_PORTE_RIS		EQU		0X40024414
RCGCADC 			EQU 0x400FE638 ; ADC clock register



;LABEL			DIRECTIVE	VALUE				COMMENT	
				AREA init_gpio,	CODE,	READONLY,	ALIGN=2
				THUMB
					
				EXPORT		GPIOE_Init

;ADC CLOCK IS THE FIRST THING INITIALIZED. OTHERWISE IT GIVES ERROR.		
			
GPIOE_Init	PROC
	;ACTIVATE ADC CLOCK
			LDR 		R1, =RCGCADC 	; Turn on ADC clock
			LDR 		R0, [R1]
			ORR 		R0, R0, #0x01 	; set bit 0 to enable ADC0 clock
			STR 		R0, [R1]
			NOP
			NOP
			NOP
	;ACTIVATE PORTE CLOCK
			LDR		R1,=SYSCTL_RCGC2_R
			LDR		R0,[R1]
			ORR		R0,R0,#0X10	;only port E	
			STR		R0,[R1]
			NOP
			NOP
			NOP
	;SET DIRECTION REGISTER
			LDR		R1,=GPIO_PORTE_DIR_R
			LDR		R0,[R1]
			BIC		R0,R0,#0X08			;PE3 IS INPUT
			STR		R0,[R1]
	;REGULAR PORT FUNCTION
			LDR		R1,=GPIO_PORTE_AFSEL_R
			LDR		R0,[R1]
			ORR		R0,R0,#0X08			;PE3 IS ALTERNATE
			STR		R0,[R1]
	;PULLDOWN RESISTORS ON SWITCH PINS
			;LDR		R1,=GPIO_PORTE_PDR
			;MOV		R0,#0X0F
			;STR		R0,[R1]
	;DISABLE DIGITAL PORT
			LDR		R1,=GPIO_PORTE_DEN_R
			LDR		R0,[R1]
			BIC		R0,R0,#0X08
			STR		R0,[R1]
	;ENABLE ANALOG PORT
			LDR		R1,=GPIO_PORTE_AMSEL_R
			LDR		R0,[R1]
			ORR		R0,R0,#0X08
			STR		R0,[R1]
	;CONFIGURE INTERRUPT FOR PORTE PINS 0-3=INPUT
			;LDR		R1,=GPIO_PORTE_IS
			;LDR		R2,=GPIO_PORTE_IBE
			;LDR		R3,=GPIO_PORTE_IEV
			;LDR		R4,=GPIO_PORTE_IM
			;LDR		R5,=GPIO_PORTE_ICR
			
			;MOV		R0,#0X00
			;STR		R0,[R1]
			;STR		R0,[R2]
			;MOV		R0,#0X0F
			;STR		R0,[R3]
			;STR		R0,[R4]
			;STR		R0,[R5]
			
	;CONFIGURE NVIC
			;LDR		R1,=NVIC_ISER0
			;LDR		R0,[R1]
			;ORR		R0,R0,#02
			;STR		R0,[R1]
			;CPSIE	I
							
			
			BX 		LR
			ENDP
			ALIGN
			END
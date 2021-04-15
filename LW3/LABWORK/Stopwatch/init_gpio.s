
PF_INP				EQU		0X40025040
PF_OUT				EQU		0X40025020
GPIO_PORTF_DIR_R	EQU		0X40025400
GPIO_PORTF_LOCK_R	EQU		0X40025520
PORTF_CR			EQU		0X40025524
GPIO_PORTF_AFSEL_R	EQU		0X40025420
GPIO_PORTF_DEN_R	EQU		0X4002551C
GPIO_PORTF_AMSEL_R	EQU		0X40025528
GPIO_PORTF_PUR		EQU		0X40025510 ;514
SYSCTL_RCGC2_R		EQU		0X400FE608
GPIO_PORTF_IS		EQU		0X40025404
GPIO_PORTF_IBE		EQU		0X40025408
GPIO_PORTF_IEV		EQU		0X4002540C
GPIO_PORTF_IM		EQU		0X40025410
GPIO_PORTF_ICR		EQU		0X4002541C
GPIO_PORTF_RIS		EQU		0X40025414


;LABEL			DIRECTIVE	VALUE				COMMENT	
				AREA init_gpio,	CODE,	READONLY,	ALIGN=2
				THUMB
					
				EXPORT		PORTF_Init

			
PORTF_Init	PROC
	;ACTIVATE CLOCK
			LDR		R1,=SYSCTL_RCGC2_R
			LDR		R0,[R1]
			ORR		R0,R0,#0X20	;only port F	
			STR		R0,[R1]
			NOP
			NOP
			NOP
	;UNLOCK PORT F
			LDR		R1,=GPIO_PORTF_LOCK_R
			LDR		R0,=0X4C4F434B
			STR		R0,[R1]
			LDR		R1,=PORTF_CR
			MOV		R0,#0X18		;ONLY PIN 4 AND 3
			STR		R0,[R1]
	;SET DIRECTION REGISTER
			LDR		R1,=GPIO_PORTF_DIR_R
			LDR		R0,[R1]
			ORR		R0,R0,#0X0F
			BIC		R0,R0,#0XF0			;0000_1111 INPUT_OUTPUT
			STR		R0,[R1]
	;REGULAR PORT FUNCTION
			LDR		R1,=GPIO_PORTF_AFSEL_R
			LDR		R0,[R1]
			BIC		R0,R0,#0XFF
			STR		R0,[R1]
	;PULLUP RESISTORS ON SWITCH PINS
			LDR		R1,=GPIO_PORTF_PUR
			MOV		R0,#0X10
			STR		R0,[R1]
	;ENABLE DIGITAL PORT
			LDR		R1,=GPIO_PORTF_DEN_R
			LDR		R0,[R1]
			ORR		R0,R0,#0XFF
			STR		R0,[R1]
	;DISABLE ANALOG PORT
			LDR		R1,=GPIO_PORTF_AMSEL_R
			LDR		R0,[R1]
			BIC		R0,R0,#0XFF
			STR		R0,[R1]
	;CONFIGURE INTERRUPT FOR PORTF PINS 0-3=INPUT
			;LDR		R1,=GPIO_PORTB_IS
			;LDR		R2,=GPIO_PORTB_IBE
			;LDR		R3,=GPIO_PORTB_IEV
			;LDR		R4,=GPIO_PORTB_IM
			;LDR		R5,=GPIO_PORTB_ICR
			
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
							
			LDR		R1,=PF_OUT
			MOV		R0,#0X20
			STR		R0,[R1]	

			BX 		LR
			ENDP
			END
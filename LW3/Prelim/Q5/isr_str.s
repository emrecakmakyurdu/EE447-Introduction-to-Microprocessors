;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;				  ISR OF THE Q5 				  ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PB_OUT				EQU		0X400053C0
GPIO_PORTB_ICR		EQU		0X4000541C
GPIO_PORTB_RIS		EQU		0X40005414	
NVIC_ST_RELOAD		EQU		0XE000E014				;24 BIT, WHEN THE COUNTER REACHES 0, IT IS RELOADED WITH THIS VALUE
NVIC_ST_CURRENT		EQU		0XE000E018				;THE CURRENT VALUE OF THE COUNTER


RELOAD_VALUE	EQU		0X20000400				;ADDRESS FOR RELOAD VALUE

			
;LABEL			DIRECTIVE	VALUE				COMMENT	
				AREA isr,	CODE,	READONLY,	ALIGN=2
				THUMB
					
				EXPORT		My_ST_ISR

My_ST_ISR		PROC
				CMP			R5,#0X01		;CW
				BEQ			CW
				CMP			R5,#0X02		;CCW
				BEQ			CCW
				CMP			R5,#0X04		;FAST
				BEQ			FAST
				CMP			R5,#0X08		;SLOW
				BEQ			SLOW
	
FAST			LDR			R1,=RELOAD_VALUE
				LDR			R0,[R1]
				CMP			R0,#0X3000
				CPYEQ		R5,R6
				BEQ			EXIT
				SUB			R0,#0X3000
				STR			R0,[R1]
				LDR			R1,=NVIC_ST_RELOAD
				STR			R0,[R1]
				;LDR			R1,=NVIC_ST_CURRENT
				;STR			R0,[R1]
				CPY			R5,R6
				B			EXIT




SLOW			LDR			R1,=RELOAD_VALUE
				LDR			R0,[R1]
				ADD			R0,#0X3000
				STR			R0,[R1]
				LDR			R1,=NVIC_ST_RELOAD
				STR			R0,[R1]
				;LDR			R1,=NVIC_ST_CURRENT
				;STR			R0,[R1]
				CPY			R5,R6
				B			EXIT


	

CW				LDR			R1,=PB_OUT
				LDR			R0,[R1]
				LSL			R0,#1
				CMP			R0,#0X100
				MOVEQ		R0,#0X10
				STR			R0,[R1]
				CPY			R6,R5
				B			EXIT
				
				
CCW				LDR			R1,=PB_OUT
				LDR			R0,[R1]
				LSR			R0,#1
				CMP			R0,#0X08
				MOVEQ		R0,#0X80
				STR			R0,[R1]
				CPY			R6,R5
				B			EXIT


EXIT			BX			LR
				ALIGN
				ENDP
				END

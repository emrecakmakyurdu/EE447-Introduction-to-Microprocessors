;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;				  ISR OF THE Q1					  ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PB_OUT				EQU		0X400053C0
GPIO_PORTB_ICR		EQU		0X4000541C
GPIO_PORTB_RIS		EQU		0X40005414	

;LABEL			DIRECTIVE	VALUE				COMMENT	
				AREA isr,	CODE,	READONLY,	ALIGN=2
				THUMB
					
				EXPORT	My_ST_ISR

My_ST_ISR		PROC
				CMP		R5,#0
				BNE		CCW
CW				LDR		R1,=PB_OUT
				LDR		R0,[R1]
				LSL		R0,#1
				CMP		R0,#0X100
				MOVEQ	R0,#0X10
				STR		R0,[R1]
				B		EXIT
CCW				LDR		R1,=PB_OUT
				LDR		R0,[R1]
				LSR		R0,#1
				CMP		R0,#0X08
				MOVEQ	R0,#0X80
				STR		R0,[R1]


EXIT			BX		LR
				ALIGN
				ENDP
				END

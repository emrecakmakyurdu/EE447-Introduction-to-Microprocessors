;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;				  ISR OF THE Q3					  ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


PB_OUT				EQU		0X400053C0
;LABEL			DIRECTIVE	VALUE				COMMENT	
				AREA isr,	CODE,	READONLY,	ALIGN=2
				THUMB
					
				EXPORT	My_ST_ISR

My_ST_ISR		PROC
	
				CMP		R5,#1
				BNE		CCW
				
CW				LDR		R1,=PB_OUT				;IF THE CW IS SELECTED
				LDR		R0,[R1]					;CURRENT STEP IS LOADED TO R0
				LSL		R0,#1					;R0 IS SHIFTED LEFT TO MOVE ON TO THE NEXT STEP
				CMP		R0,#0X100				;IF WE EXCEEDED THE STEP 4
				MOVEQ	R0,#0X10				;MOVE TO STEP 1
				STR		R0,[R1]					;STORE IT
				B		EXIT
				
CCW				LDR		R1,=PB_OUT				;IF THE CCW IS SELECTED
				LDR		R0,[R1]					;CURRENT STEP IS LOADED TO R0
				LSR		R0,#1					;R0 IS SHIFTED RIGHT TO MOVE ON TO THE PREVIOUS STEP
				CMP		R0,#0X08				;IF WE GO BELOW THE STEP 1
				MOVEQ	R0,#0X80				;MOVE TO STEP 4
				STR		R0,[R1]					;STORE IT


EXIT			BX		LR
				ALIGN
				ENDP
				END
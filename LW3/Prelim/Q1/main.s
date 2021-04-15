;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;				  MAIN OF THE Q1				  ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;LABEL			DIRECTIVE	VALUE				COMMENT	
				AREA main,	CODE,	READONLY,	ALIGN=2
				THUMB
					
				IMPORT		InitSysTick
				IMPORT		PORTB_Init
				EXPORT		__main

			
__main			PROC
				BL			InitSysTick
				BL			PORTB_Init
				MOV			R5,#1			;IF R5 = 0 CW, IF NOT CCW
LOOP			WFI
				WFI
				WFI
				B			LOOP
				
	
	
				ENDP
					
					
					
					
				END
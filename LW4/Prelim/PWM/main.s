;LABEL			DIRECTIVE	VALUE				COMMENT	
				AREA main,	CODE,	READONLY,	ALIGN=2
				THUMB				
				
				IMPORT		PWM_INIT
				EXPORT		__main
					
__main			PROC


				BL		PWM_INIT
LOOP			NOP
				B		LOOP
				ENDP
				END
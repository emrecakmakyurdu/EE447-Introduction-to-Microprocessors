;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;				  MAIN OF THE Q1				  ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;LABEL			DIRECTIVE	VALUE				COMMENT	
				AREA main,	CODE,	READONLY,	ALIGN=2
				THUMB				
				
				IMPORT		PULSE_INIT
				EXPORT		__main
					
					
__main			PROC
				BL		PULSE_INIT
LOOP			WFI
				B		LOOP
	
				ENDP				
				END

;LABEL			DIRECTIVE	VALUE				COMMENT	
				AREA main,	CODE,	READONLY,	ALIGN=2
				THUMB				
				
				;IMPORT		OutStr
				;IMPORT		CONVRT
				IMPORT		PULSE_INIT
				;IMPORT		EDGE_TIMER
				;IMPORT		OutChar
				EXPORT		__main

__main			PROC
				BL		PULSE_INIT
LOOP			WFI
				B		LOOP
	
	
	
	
	
	
	
				ENDP
				END
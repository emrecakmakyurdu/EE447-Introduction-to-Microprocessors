;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;				  		Q1						  ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			AREA subroutine,	READONLY,	CODE
			THUMB
			EXPORT	DELAY100
				
DELAY100
		PUSH	{R0}
		MOV32	R0,#600000		; 16MHZ TO 100MSEC ASSUMING 3 CYCLE THE LOOP TAKES -1.600.000-
LOOP	SUBS	R0,#1
		BNE		LOOP
		POP		{R0}
		BX		LR
		ALIGN
		END
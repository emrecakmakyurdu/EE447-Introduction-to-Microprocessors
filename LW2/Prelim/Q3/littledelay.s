;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;				  LITTLEDELAY IN Q3				  ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

			AREA subroutine,	READONLY,	CODE
			THUMB
			EXPORT	littledelay
				
littledelay
		PUSH	{R0}
		MOV32	R0,#40000
LOOP	SUBS	R0,#1
		BNE		LOOP
		POP		{R0}
		BX		LR
		ALIGN
		END
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;				  5 SEC DELAY IN Q2				  ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			AREA subroutine,	READONLY,	CODE
			THUMB
			EXPORT	DELAY5SEC
				
DELAY5SEC
		PUSH	{R0}
		MOV32	R0,#30000000	;
LOOP	SUBS	R0,#1
		BNE		LOOP
		POP		{R0}
		BX		LR
		ALIGN
		END
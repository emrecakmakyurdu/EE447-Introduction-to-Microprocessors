			AREA subroutine,	READONLY,	CODE
			THUMB
			EXTERN	RECURSION
			EXPORT	FirstRule
				
FirstRule
			PUSH	{R0,LR}
			CMP		R0,#99			; 100'DEN BUYUK MU
			BLS		JUMP
			MOV		R2,#2
			UDIV	R1,R0,R2		; R1 = R0 / 2
			MUL		R2,R1			; R2 = R1 * 2
			SUBS	R2,R0,R2		; IF 0, IT IS EVEN
			BNE		JUMP
			SUB		R0,#47
			BL		RECURSION
JUMP		POP		{R0,LR}
			BX		LR
			ALIGN
			END
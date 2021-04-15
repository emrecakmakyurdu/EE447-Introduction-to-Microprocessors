			AREA subroutine,	READONLY,	CODE
			THUMB
			EXTERN	MYPARCEL
			EXPORT	FirstArea
				
FirstArea
			PUSH	{R0,LR}
			CMP		R0,#99			; 100'DEN BUYUK MU
			BLS		JUMP
			SUB		R0,#100
			BL		MYPARCEL
JUMP		POP		{R0,LR}
			BX		LR
			END
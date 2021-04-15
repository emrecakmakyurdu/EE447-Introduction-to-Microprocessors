			AREA subroutine,	READONLY,	CODE
			THUMB
			EXTERN	MYPARCEL
			EXPORT	FourthArea
				
FourthArea

			PUSH	{R0,LR}
			CMP		R0,#99		;100'DEN BUYUK MU
			BHI		JUMP
			
			CMP		R0,#9		;10'DAN KUCUK MU
			BLS		JUMP
			
			MOV		R1,#3			;3'E BOLUNUR MU
			UDIV	R2,R0,R1
			MUL		R2,R2,R1
			CMP		R0,R2
			BNE		JUMP
			
			MOV		R1,#10
			MOV		R4,#0
			PUSH	{R0}
			UDIV	R2,R0,R1		; BASAMAKLARI CARPIMI R1'DE SAKLANIYOR
			MUL		R2,R2,R1
			SUB		R2,R0,R2
			UDIV	R0,R0,R1
			MUL		R1,R0,R2
			POP		{R0}
			SUB		R0,R1
			BL		MYPARCEL
JUMP		POP		{R0,LR}
			BX		LR
			END
			AREA subroutine,	READONLY,	CODE
			THUMB
			EXTERN	MYPARCEL
			EXPORT	SecondArea
				
SecondArea
		
			PUSH	{R0,LR}
			MOV		R1,#7			;7'YE BOLUNEBILIYOR MU
			UDIV	R2,R0,R1
			MUL		R2,R2,R1
			CMP		R0,R2
			BNE		JUMP			; BOLUNEMIYORSA CIK
			
			UDIV	R2,R2,R1		; BOLUNEBILIYORSA R0'DAN  5M CIKAR RECURSION YAP
			MOV		R1,#5
			MUL		R2,R2,R1
			SUB		R0,R2
			BL		MYPARCEL
JUMP		POP		{R0,LR}
			BX		LR
			END
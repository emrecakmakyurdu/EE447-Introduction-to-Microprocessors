		AREA	main,	READONLY,	CODE
		THUMB
		EXTERN	CONVRT
		EXTERN	OutStr
		EXPORT	__main
		
NUM		EQU	0X20000500

MSG     	DCB     	"INPUT IS HIGHER THAN 0X7FFFFFFF"
			DCB			0x0D		; Carriage return is like new line
			DCB			0x04		; it is like EOF or \0		
	
__main

		MOV32	R4,#0X80000000	; DENENECEK SAYI
		MOV32	R0,#0X7FFFFFFF
		CMP		R4,R0
		BHI		ERR
		LDR		R5,=NUM
		BL		CONVRT
		LDR		R5,=NUM
		BL		OutStr
		NOP
		NOP
		NOP
ERR		LDR		R5,=MSG
		BL		OutStr
loop	B		loop

		END
	
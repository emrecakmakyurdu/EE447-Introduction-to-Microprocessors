PF_OUT				EQU		0X40025020
GPIO_PORTF_ICR		EQU		0X4002541C
GPIO_PORTF_RIS		EQU		0X40025414	
NVIC_ST_RELOAD		EQU		0XE000E014				;24 BIT, WHEN THE COUNTER REACHES 0, IT IS RELOADED WITH THIS VALUE
NVIC_ST_CURRENT		EQU		0XE000E018				;THE CURRENT VALUE OF THE COUNTER


RELOAD_VALUE	EQU		0X20000400				;ADDRESS FOR RELOAD VALUE


			
;LABEL			DIRECTIVE	VALUE				COMMENT	
				AREA isr,	CODE,	READONLY,	ALIGN=2
				THUMB
					
				EXTERN		OutChar
				EXTERN		OutStr
				EXPORT		My_ST_ISR
	
WLCM1     		DCB     	"WELCOME"
				DCB			0x0D		; Carriage return is like new line
				DCB			0x04		; it is like EOF or \0						

My_ST_ISR		PROC
				CMP			R5,#1
				ADDEQ		R8,#1
				CMP			R7,#100			;100 SANIYE OLDUYSA LEDI KAPA COUNTINGI DURDUR
				BEQ			STOPCOUNT
				CMP			R5,#0
				BEQ			SHUT
				CMP			R5,#2			;TUSA 2. DEFA BASILDIYSA
				BEQ			STOPPRINT
				ADD			R6,#1
				CMP			R6,#100			;100 MEANS 10*100MS = 1 SECONDS
				BEQ			BLON
				CMP			R6,#200			;200 MEANS 2 SECONDS
				BEQ			BLOF
				B			EXIT
				
				
BLOF			LDR			R0,=PF_OUT		;2. SANIYE DOLDUYSA LEDI KAPA
				MOV			R1,#0
				STR			R1,[R0]
				MOV			R6,#0			;RESET TO 0
				ADD			R7,#1
				B			EXIT

BLON			LDR			R0,=PF_OUT		;1 SANIYE DOLDUYSA LEDI YAK
				MOV			R1,#8
				STR			R1,[R0]
				ADD			R7,#1
				B			EXIT
				
SHUT			LDR			R0,=PF_OUT		;TUSA DAHA BASILMAMISSA LED KAPALI KALSIN
				MOV			R1,#0
				STR			R1,[R0]
				B			EXIT
				
STOPCOUNT		LDR			R0,=PF_OUT		;100 SANIYE OLDUGU ICIN SAYMAYI DURDUR
				MOV			R1,#0
				STR			R1,[R0]
				MOV			R5,#0
				B			EXIT
				
STOPPRINT		LDR			R0,=PF_OUT
				MOV			R1,#0
				STR			R1,[R0]
				MOV			R5,#0			;ILK DURUMA GETIR
				MOV			R0,#999
				CMP			R8,R0
				BHI			DOUBLE			;10 SANIYEDEN FAZLA
				B			SINGLE			;10 SANIYEDEN AZ
				
DOUBLE			PUSH		{LR}
				MOV			R0,#1000		;ONLAR BASAMAGI
				UDIV		R9,R8,R0
				MUL			R10,R9,R0
				SUB			R8,R10
				ADD			R9,#48			;ASCII CEVIR
				BL			OutChar
				MOV			R0,#100			;BIRLER BASAMAGI
				UDIV		R9,R8,R0
				MUL			R10,R9,R0
				SUB			R8,R10
				ADD			R9,#48			;ASCII CEVIR
				BL			OutChar
				MOV			R9,#46			;NOKTA
				BL			OutChar
				MOV			R0,#10			;VIRGULDEN SONRAKI ILK BASAMAK
				UDIV		R9,R8,R0
				MUL			R10,R9,R0
				SUB			R8,R10
				ADD			R9,#48			;ASCII CEVIR
				BL			OutChar
				CPY			R9,R8
				ADD			R9,#48			;SON BASAMAK
				BL			OutChar
				MOV			R9,#10			;NEWLINE
				BL			OutChar
				LDR			R5,=WLCM1
				BL			OutStr				
				MOV			R8,#0
				MOV			R7,#0
				MOV			R6,#0
				MOV			R5,#0
				POP			{LR}
				B			EXIT


SINGLE			PUSH		{LR}
				MOV			R0,#100			;BIRLER BASAMAGI
				UDIV		R9,R8,R0
				MUL			R10,R9,R0
				SUB			R8,R10
				ADD			R9,#48			;ASCII CEVIR
				BL			OutChar
				MOV			R9,#46			;NOKTA
				BL			OutChar
				MOV			R0,#10			;VIRGULDEN SONRAKI ILK BASAMAK
				UDIV		R9,R8,R0
				MUL			R10,R9,R0
				SUB			R8,R10
				ADD			R9,#48			;ASCII CEVIR
				BL			OutChar
				CPY			R9,R8
				ADD			R9,#48			;SON BASAMAK
				BL			OutChar
				MOV			R9,#10			;NEWLINE
				BL			OutChar				
				LDR			R5,=WLCM1
				BL			OutStr				
				MOV			R8,#0
				MOV			R7,#0
				MOV			R6,#0
				MOV			R5,#0
				POP			{LR}
				
				B			EXIT

EXIT			BX			LR
				ALIGN
				ENDP
				END

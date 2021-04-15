NUM			EQU		0X20000400

			AREA	subroutine,	READONLY,	CODE
			THUMB
			EXTERN	InChar
			EXPORT	NUMIN
			

NUMIN
			;R0 N OLACAK
			LDR		R6,=NUM		; NUM ILE GOSTERILEN ADRESTE TUTULACAK KARAKTERLER
			MOV		R1,#0		; NUMBER OF DIGITS ENTERED
			MOV		R0,#0		; N
			PUSH	{LR}
			
get			BL		InChar		; GET INPUT UNTIL SPACEBAR IS LOGGED
			CMP		R5,#0x20	; SPACE GELDIYSE BITIR
			BEQ		done
			SUB		R5,#48		; ASCII'DEN KURTARIYORUM
			STRB	R5,[R6],#1	; NUM ILE GOSTERILEN YERE BYTE BYTE YAZIYORUM
			ADD		R1,#1		; KAC BASAMAK OLDUGUNUN BILGISI BURADA SAKLANIYOR
			B		get
				
done		MOV		R10,#10
			MOV		R2,#1		; 10 UZERI 0 
LOOP2		SUB		R6,#1		; TUM DIGITLERI 10'UN KATLARI ILE CARPIP TOPLUYORUM KI N SAYISINI BULAYIM
			LDRB	R7,[R6]		; SIRAYLA BASAMAKLARI CAGIRIYORUM
			MUL		R5,R7,R2	; BASAMAGI 10'UN KATLARI ILE CARPIYORUM
			ADD		R0,R5		; ADD
			MUL		R2,R10		; BIR SONRAKI BASAMAK ICIN 10'UN KATINI ARTTIRIYORUM
			SUBS	R1,#1		; KAC BASAMAK KALDIGINI OGRENMEK ICIN CIKARTIYORUM
			BNE		LOOP2		; N IS OBTAINED IN R0
			POP		{LR}
			BX		LR
			ALIGN
			END
			

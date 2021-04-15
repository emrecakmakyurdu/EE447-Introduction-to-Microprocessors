;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;				  MAIN OF THE Q3				  ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

		AREA	main,	READONLY,	CODE
		THUMB
		EXTERN	Start
		EXTERN	DELAY100
		EXTERN	OutChar
		EXTERN 	littledelay
		EXTERN	OutStr
		EXPORT	__main

;7-4 INPUT, 3-0 OUTPUT
;INPUT IS PULLED UP
;CONNECTION IS: L1=B0,L2=B1,L3=B2,L4=B3,R1=B4,R2=B5,R3=B6,R4=B7
;R12 BIR ONCEKI BASTIGIM TUSUN DEGERI
;R7 BIR TUSA KACINCI BASISTA OLDUGUM
;R8

MSG0 DCB "Old-School Key Pad", 13, "-----------------------", 13, "[a/b] [c/d] [e/f] [g/h]", 13, "[i/j] [k/l] [m/n] [o/p]", 13, "[q/r] [s/t] [u/v] [w/x]", 13, "[y/z] [,/.] [?/!] [>/_]", 13, "-----------------------", 13, 13,  4


GPIO_PORTB_DATA		EQU		0X40005000	;DATA ADDRESS TO ALL PINS
GPIO_PORTF_DATA		EQU		0x40025000	;PIN1 AND 2 #18
	
__main
			BL		Start
			LDR		R5,=MSG0
			BL		OutStr
			MOV		R7,#0
			MOV		R8,#0
					
			

INPUT		LDR		R0,=GPIO_PORTB_DATA				;PORTB_DATA REGISTERININ ADRESINI R0'YA KAYDEDIYORUM
			LDRB	R1,[R0,#0X3FC]					;PORTB_DATA REGISTERINDEKI DEGERI R1'E KAYDEDIYORUM
			BL		DELAY100						;100MSEC BEKLIYORUM
			LDRB	R2,[R0,#0X3FC]					;PORTB_DATA REGISTERINDEKI DEGERI R2'YE KAYDEDIYORUM
			CMP		R1,R2							;DEBOUNCING ICIN KARSILASTIRMA YAPIYORUM
			BNE		INPUT							;DEGILSE YANLISLIK OLMUS, TEKRAR INPUT ALIYORUM
			CMP		R1,#0XF0						;R1 VE R2 AYNI OLMASINA RAGMEN 0XF0 ISELER, HICBIR TUSA BASILMAMIS DEMEKTIR, TEKRAR INPUT ALIYORUM
			BEQ		INPUT
			CPY		R5,R1							;BURAYA SAKLANAN DEGER E,D,B,7'DEN BIRI. SIRAYLA 1,2,3,4. COLUMNA DENK GELIYOR

			
			
			MOV		R6,#00							;R6'DA SAKLANACAK OLAN DEGER ILE HANGI ROW OLDUGUNU OGRENECEZ
			MOV		R2,#01							;R2'YI OUTPUTLARI SIRAYLA 0001, 0010, 0100, 1000 YAPMAK ICIN KULLANIYORUM
LOOP		STR		R2,[R0,#0X03C]					;OUTPUTA R2 DEGERI YAZILINCA INPUT DEGISIYOR
			BL		littledelay						;OUTPUTA YAZILAN DEGERIN ULASMASINI BEKLIYORUM
			LDRB	R3,[R0,#0X3C0]					;INPUTUN NE OLDUGUNU KAYDEDIYORUM
			ADD		R6,#1							;1=1.ROW, 2=2.ROW, 3=3.ROW, 4=4.ROW
			LSL		R2,#1							;R2'YI KAYDIRIYORUM
			CMP		R3,#0XF0						;EGER INPUTUM F ISE, O ROWDAKI TUSA BASMISIM DEMEKTIR
			BNE		LOOP
			
			
			ADD		R10,R5,R6							;TUS BILGISI ORTAYA CIKTI
			
			
			LDR		R0,=GPIO_PORTB_DATA
			MOV		R1,#0
			STRB	R1,[R0,#0X03C]					;OUTPUTU 0'LIYORUM KI BASA DONDUGUMDE SORUN CIKMASIN
			BL		littledelay						;OUTPUTU DEGISTIRDIGIM ICIN BIRAZ BEKLIYORUM
			
			
			
RELEASE		LDRB	R1,[R0,#0X3FC]					;PORTB_DATA'DA SAKLANAN DEGERI R1'E YUKLUYORUM
			BL		DELAY100
			LDRB	R2,[R0,#0X3FC]					;PORTB_DATA'DA SAKLANAN DEGERI R2'YE YUKLUYORUM
			CMP		R1,R2							;DEBOUNCING
			BNE		RELEASE
			CMP		R1,#0XF0						;EGER HALA TUSA BASILI ISE BIRAKANA KADAR BEKLIYORUM, RELEASE'YE DONUYORUM
			BNE		RELEASE							;EGER TUS BIRAKILDIYSA, R1'E 0XF0 YUKLENIYOR VE BU LOOP'TAN CIKILIYOR			
			
			
			
						
						
			;R5 BENIM COLUMN BELIRLEYENIM, R6 BENIM ROW BELIRLEYENIM
			LDR		R9,=GPIO_PORTF_DATA
			LDR		R9,[R9,#018]
			CMP 	R9,#04
			BNE		FIRST
			BEQ		SECOND
			
FIRST		CMP		R5,#0XE0						;1. COLUMN
			BEQ		COL11
			CMP		R5,#0XD0						;2. COLUMN
			BEQ		COL21
			CMP		R5,#0XB0						;3. COLUMN
			BEQ		COL31
			CMP		R5,#0X70						;4. COLUMN
			BEQ		COL41
			
SECOND		CMP		R5,#0XE0						;1. COLUMN
			BEQ		COL12
			CMP		R5,#0XD0						;2. COLUMN
			BEQ		COL22
			CMP		R5,#0XB0						;3. COLUMN
			BEQ		COL32
			CMP		R5,#0X70						;4. COLUMN
			BEQ		COL42
			
COL11		CMP		R6,#1							;R6=1 ISE 1. COLUMN 1. ROW, 0. TUS
			MOVEQ	R0,#97
			CMP		R6,#2							;R6=2 ISE 1. COLUMN 2. ROW, 4. TUS
			MOVEQ	R0,#105
			CMP		R6,#3							;R6=3 ISE 1. COLUMN 3. ROW, 8. TUS
			MOVEQ	R0,#113	
			CMP		R6,#4							;R6=4 ISE 1. COLUMN 4. ROW, 12. TUS
			MOVEQ	R0,#121
			B		FINISH
			
			
COL21		CMP		R6,#1							;R6=1 ISE 2. COLUMN 1. ROW, 1. TUS
			MOVEQ	R0,#99
			CMP		R6,#2							;R6=2 ISE 2. COLUMN 2. ROW, 5. TUS
			MOVEQ	R0,#107
			CMP		R6,#3							;R6=3 ISE 2. COLUMN 3. ROW, 9. TUS
			MOVEQ	R0,#115
			CMP		R6,#4							;R6=4 ISE 2. COLUMN 4. ROW, 13. TUS
			MOVEQ	R0,#44
			B		FINISH


COL31		CMP		R6,#1							;R6=1 ISE 3. COLUMN 1. ROW, 2. TUS
			MOVEQ	R0,#101
			CMP		R6,#2							;R6=2 ISE 3. COLUMN 2. ROW, 6. TUS
			MOVEQ	R0,#109
			CMP		R6,#3							;R6=3 ISE 3. COLUMN 3. ROW, 10. TUS
			MOVEQ	R0,#117
			CMP		R6,#4							;R6=4 ISE 3. COLUMN 4. ROW, 14. TUS
			MOVEQ	R0,#63
			B		FINISH


COL41		CMP		R6,#1							;R6=1 ISE 4. COLUMN 1. ROW, 3. TUS
			MOVEQ	R0,#103
			CMP		R6,#2							;R6=2 ISE 4. COLUMN 2. ROW, 7. TUS
			MOVEQ	R0,#111
			CMP		R6,#3							;R6=3 ISE 4. COLUMN 3. ROW, 11. TUS
			MOVEQ	R0,#119
			CMP		R6,#4							;R6=4 ISE 4. COLUMN 4. ROW, 15. TUS
			;MOVEQ	R0,#15
			B		FINISH
			
COL12		CMP		R6,#1							;R6=1 ISE 1. COLUMN 1. ROW, 0. TUS
			MOVEQ	R0,#98
			CMP		R6,#2							;R6=2 ISE 1. COLUMN 2. ROW, 4. TUS
			MOVEQ	R0,#106
			CMP		R6,#3							;R6=3 ISE 1. COLUMN 3. ROW, 8. TUS
			MOVEQ	R0,#114	
			CMP		R6,#4							;R6=4 ISE 1. COLUMN 4. ROW, 12. TUS
			MOVEQ	R0,#122
			B		FINISH
			
			
COL22		CMP		R6,#1							;R6=1 ISE 2. COLUMN 1. ROW, 1. TUS
			MOVEQ	R0,#100
			CMP		R6,#2							;R6=2 ISE 2. COLUMN 2. ROW, 5. TUS
			MOVEQ	R0,#108
			CMP		R6,#3							;R6=3 ISE 2. COLUMN 3. ROW, 9. TUS
			MOVEQ	R0,#116
			CMP		R6,#4							;R6=4 ISE 2. COLUMN 4. ROW, 13. TUS
			MOVEQ	R0,#46
			B		FINISH


COL32		CMP		R6,#1							;R6=1 ISE 3. COLUMN 1. ROW, 2. TUS
			MOVEQ	R0,#102
			CMP		R6,#2							;R6=2 ISE 3. COLUMN 2. ROW, 6. TUS
			MOVEQ	R0,#110
			CMP		R6,#3							;R6=3 ISE 3. COLUMN 3. ROW, 10. TUS
			MOVEQ	R0,#118
			CMP		R6,#4							;R6=4 ISE 3. COLUMN 4. ROW, 14. TUS
			MOVEQ	R0,#33
			B		FINISH


COL42		CMP		R6,#1							;R6=1 ISE 4. COLUMN 1. ROW, 3. TUS
			MOVEQ	R0,#104
			CMP		R6,#2							;R6=2 ISE 4. COLUMN 2. ROW, 7. TUS
			MOVEQ	R0,#112
			CMP		R6,#3							;R6=3 ISE 4. COLUMN 3. ROW, 11. TUS
			MOVEQ	R0,#120
			CMP		R6,#4							;R6=4 ISE 4. COLUMN 4. ROW, 15. TUS
			MOVEQ	R0,#95
			B		FINISH			
			
			
			
FIRSTRUN	CMP		R8,#0
			CPYEQ	R12,R0
			CPYEQ	R8,R10
			ADDEQ	R7,#1
			BL		LIGHT
			B 		INPUT
			
FINISH		CMP		R8,R10			;ONCEKI BASILAN TUS ILE GUNCEL TUS AYNI ISE
			BNE		PRINT
			CPYEQ	R12,R0
			CPYEQ	R8,R10			;SIRF ILK DURUM ICIN LAZIM
			ADDEQ	R7,#1
			BL		LIGHT
			B		INPUT
			
			
PRINT		PUSH	{R5}
			CPY		R8,R10
			CPY		R5,R12			;R12DE BIR ONCEKI BILGI VAR
			BL		OutChar
			POP 	{R5}
			MOV		R7,#1			;BASIM SAYISINI 0LA
			CPY		R12,R0			;SU AN BASTIGIM BILGIYI ONCEKI OLARAK GUNCELLE
			BL		LIGHT
			B		INPUT

LIGHT		LDR		R2,=GPIO_PORTF_DATA	
			CMP		R7,#1
			MOVEQ	R1,#0X02				;RED
			MOVNE	R1,#0X04				;BLUE
			STRB	R1,[R2,#0X18]
			CMP		R7,#2
			MOVEQ	R7,#0
			BX		LR


			ALIGN
			END
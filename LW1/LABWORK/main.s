		AREA	main,	READONLY,	CODE
		THUMB
;		EXTERN	OutStr
		EXTERN	NUMIN
		EXTERN	RECURSION
		EXTERN	CONVRT
		EXTERN	OutStr
		EXPORT	__main
			
MIN		EQU		0X20000800
MSG		EQU		0X20000400

MSG1     	DCB     	"ENTER N: "
			DCB			0x0D		; Carriage return is like new line
			DCB			0x04		; it is like EOF or \0			
			
MSG2     	DCB     	"GLOBAL MINIMUM: "
			DCB			0x0D		; Carriage return is like new line
			DCB			0x04		; it is like EOF or \0			

	;		R0 N OLACAK
	;		R7 MINIMUMLARIN SAKLANDIGI ADRES OLACAK
	; 		INPUT XXXXXXSPACE SEKLINDE GIRILMELI, YANI EN SON SPACE KONULMALI
	




__main
				LDR	    R5,=MSG1
				BL		OutStr	        ; Copy message

				BL		NUMIN			; BU SUBROUTINE INPUT ALMAK ICIN KULLANILIYOR
				
				CMP		R0,#0			;INPUTUN 0 OLDUGU CASE
				CPYEQ	R4,R0
				LDREQ 	R5,=MSG
				BLEQ	CONVRT
				LDREQ 	R5,=MSG
				BLEQ	OutStr			; GLOBAL 0 OLUYOR HIC ISLEM YAPMADAN
				BEQ		__main
				
				LDR		R7,=MIN			;R7'NIN GOSTERDIGI ADRES VE SONRASINDA TUM MINIMUM DEGERLER SAKLANACAK
				BL		RECURSION		;BURADA RECURSION BASLIYOR
				NOP
				NOP
			
				SUB		R7,#4			;SON DEGERIN 4 FAZLASINI GOSTERIYORDU, O YUZDEN CIKARDIM
				CPY		R6,R7			;R6 SON ADRES
				LDR		R7,=MIN			;R7 ILK ADRES
				LDR		R1,[R7]			;ILK MINIMUM
				CMP		R6,R7			;IF THERE IS ONLY 1 MINIMUM, GO TO EXIT
				BEQ		FINISH
				
	;R7'NIN SON DEGERINE YANI SON MINIMUMA GELENE KADAR COMPARE EDIP EN KUCUGUNU YANI GLOBAL MINIMUMU BULUYORUM			
LOOP			LDR		R0,[R7,#4]!		;R0 BIR SONRAKI MINIMUM
				CMP		R0,R1			;R0 R1'DEN KUCUKSE R0'YU R1'E YAZIYORUM
				CPYLS	R1,R0			
				CMP		R7,R6			;SON ADRESE GELDIYSEK CIKIYORUZ
				BEQ		FINISH
				B 		LOOP
				
FINISH			LDR	    R5,=MSG2
				BL		OutStr	        ; Copy message



				LDR		R5,=MSG			;GLOBAL MINIMUM'UN ASCII'YE CEVIRILIP SAKLANACAGI ADRES MSG
				CPY		R4,R1			;GLOBAL MINIMUM OLAN R1'I R4'E AKTARIYORUM, CONVRT R4 ISTIYOR
				BL		CONVRT
				LDR		R5,=MSG			;ASCII ILK KARAKTER
				BL		OutStr			;GLOBAL MINIMUM BASILIYOR
				NOP
				NOP
				B		__main
LOOP2			B		LOOP2

				NOP						
				NOP
			
			
			
			
			
			
			
				ALIGN
				END
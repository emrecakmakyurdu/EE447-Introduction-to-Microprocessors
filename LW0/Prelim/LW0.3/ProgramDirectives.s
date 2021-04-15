;*************************************************************** 
; Program_Directives.s  
; Copies the table from one location
; to another memory location.           
; Directives and Addressing modes are   
; explained with this program.   
;***************************************************************	
;*************************************************************** 
; EQU Directives
; These directives do not allocate memory
;***************************************************************
;LABEL		DIRECTIVE	VALUE		COMMENT
OFFSET  	EQU     	0x10
FIRST	   	EQU	    	0x20000480	
;***************************************************************
; Directives - This Data Section is part of the code
; It is in the read only section  so values cannot be changed.
;***************************************************************
;LABEL		DIRECTIVE	VALUE		COMMENT
            AREA        sdata, DATA, READONLY
            THUMB
CTR1    	DCB     	OFFSET		; ORIGINALLY IT WAS #0X10
MSG     	DCB     	"Copying table..."
;			DCB			0X0A		; it is newline \n but not used idk why
			DCB			0x0D		; Carriage return is like new line
			DCB			0x04		; it is like EOF or \0
			
			;***************************************************************
; Program section					      
;***************************************************************
;LABEL		DIRECTIVE	VALUE		COMMENT
			AREA    	main, READONLY, CODE
			THUMB
			EXTERN		OutStr	; Reference external subroutine	
			EXPORT  	__main	; Make available

__main		PROC
start		MOV    		R0,#1		; or LDR	R0,=0 USED TO ASSIGN THE VALUE OF THIS REGISTER TO TABLE
			LDR			R1,=FIRST	; ADDRESS REGISTER
			MOV			R2,#1		; CONTROL FLOW REGISTER
			MOV			R3,#1		; USED TO DETERMINE HOW MANY TIMES TO DISPLAY
			MOV			R4,#0		; USED TO DETERMINE THE LENGTH OF THE TABLE
			
loop1   	STRB   		R0,[R1]
			ADD			R1,R1,#1	; Store table
			ADD			R4,R4,#1	
			SUBS		R2,R2,#1
			BNE     	loop1
			
			ADD			R3,R3,#1
			MOV			R2,R3
			ADD			R0,R0,#1
			CMP			R2,#0x0A
			BNE			loop1
			
			LDR	    	R5,=MSG
			BL			OutStr	        ; Copy message
			
			LDR	    	R1,=FIRST
			MOV			R2,#0x01
			MOV			R3,R2
			
loop2   	LDRB    	R0,[R1]
			STRB	   	R0,[R1,R4]
			ADD			R1,R1,#1        ; Copy table
			SUBS		R2,R2,#1
			BNE			loop2
			
			ADD			R3,R3,#1
			MOV			R2,R3
			CMP			R2,#0x0A
			BNE			loop2
			
			B			start
;***************************************************************
; End of the program  section
;***************************************************************
;LABEL      DIRECTIVE       VALUE                           COMMENT
			ALIGN
			ENDP
			END

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;				  START OF Q3					  ;
;;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


GPIO_PORTB_DATA		EQU		0X400053FC	;DATA ADDRESS TO ALL PINS
GPIO_PORTB_DIR		EQU		0X40005400
GPIO_PORTB_AFSEL	EQU		0X40005420
GPIO_PORTB_DEN		EQU		0X4000551C
GPIO_PORTB_PUR		EQU		0X40005510
PUB					EQU		0XF0		;INPUT IS PULLED UP
IOB					EQU		0X0F		;7-4 INPUT
GPIO_PORTE_DATA		EQU		0X400243FC	;DATA ADDRESS TO ALL PINS
GPIO_PORTE_DIR		EQU		0X40024400
GPIO_PORTE_AFSEL	EQU		0X40024420
GPIO_PORTE_DEN		EQU		0X4002451C
IOE					EQU		0X00		;EVERY BIT IS INPUT
SYSCTL_RCGCGPIO		EQU		0X400FE608
GPIO_PORTF_DATA		EQU		0x40025000	;BASE ADDRESS
GPIO_PORTF_DIR		EQU		0X40025400
GPIO_PORTF_AFSEL	EQU		0X40025420
GPIO_PORTF_DEN		EQU		0X4002551C
	
					AREA	subroutine, READONLY, CODE, ALIGN=2
					THUMB
					EXPORT	Start
						
Start				LDR		R1,=SYSCTL_RCGCGPIO
					LDR		R0,[R1]
					ORR		R0,R0,#0X12
					STR		R0,[R1]
					NOP
					NOP
					NOP								;LET GPIO CLOCK STABILIZE
						
					LDR		R0,=GPIO_PORTB_PUR		;INPUT IS PULLED UP
					MOV		R1,#PUB
					STR		R1,[R0]
					
					LDR		R1,=GPIO_PORTB_DIR		; CONFIG. OF PORT B STARTS
					LDR		R0,[R1]
					BIC		R0,#0XFF
					ORR		R0,#IOB
					STR		R0,[R1]
					LDR		R1,=GPIO_PORTB_AFSEL
					LDR		R0,[R1]
					BIC		R0,#0XFF
					STR		R0,[R1]
					LDR		R1,=GPIO_PORTB_DEN
					LDR		R0,[R1]
					ORR		R0,#0XFF
					STR		R0,[R1]					;CONFIG. OF PORT B ENDS
					
					LDR		R1,=GPIO_PORTE_DIR	; CONFIG. OF PORT E STARTS
					LDR		R0,[R1]
					ORR		R0,#IOE
					STR		R0,[R1]
					LDR		R1,=GPIO_PORTE_AFSEL
					LDR		R0,[R1]
					BIC		R0,#0XFF
					STR		R0,[R1]
					LDR		R1,=GPIO_PORTB_DEN
					LDR		R0,[R1]
					ORR		R0,#0XFF
					STR		R0,[R1]					;CONFIG. OF PORT E ENDS

					BX		LR
					ALIGN
					END
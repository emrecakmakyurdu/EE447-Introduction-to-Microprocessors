GPIO_PORTB_DIR 		EQU 0x40005400
GPIO_PORTB_AFSEL 	EQU 0x40005420
GPIO_PORTB_DEN 		EQU 0x4000551C
IOB 				EQU 0xF0
RCGCGPIO		 	EQU 0x400FE608
	
			AREA subroutine, READONLY, CODE, ALIGN=2
			THUMB
			EXPORT start

start 		LDR R1 , =RCGCGPIO
			LDR R0 , [R1]
			ORR R0 , R0, #0x02
			STR R0 , [R1]
			NOP
			NOP
			NOP ;let GPIO clockstabilize
			LDR R1 , =GPIO_PORTB_DIR ;config. of port B starts
			LDR R0 , [R1]
			BIC R0 , #0xFF
			ORR R0 , #IOB
			STR R0 , [R1]
			LDR R1 , =GPIO_PORTB_AFSEL
			LDR R0 , [R1]
			BIC R0 , #0xFF
			STR R0 , [R1]
			LDR R1 , =GPIO_PORTB_DEN
			LDR R0 , [R1]
			ORR R0 , #0xFF
			STR R0 , [R1] ;config. of port B ends
			BX	LR
			ALIGN
			END
NVIC_EN0_INT19		EQU 0x00080000 ; Interrupt 19 enable
NVIC_EN0			EQU 0xE000E100 ; IRQ 0 to 31 Set Enable Register
NVIC_PRI4			EQU 0xE000E410 ; IRQ 16 to 19 Priority Register
	
; 16/32 Timer Registers
TIMER0_CFG			EQU 0x40030000
TIMER0_TAMR			EQU 0x40030004
TIMER0_CTL			EQU 0x4003000C
TIMER0_IMR			EQU 0x40030018
TIMER0_RIS			EQU 0x4003001C ; Timer Interrupt Status
TIMER0_ICR			EQU 0x40030024 ; Timer Interrupt Clear
TIMER0_TAILR		EQU 0x40030028 ; Timer interval
TIMER0_MATCHR		EQU	0X40030030	;TIMER MATCH
TIMER0_TAPR			EQU 0x40030038
TIMER0_TAR			EQU	0x40030048 ; Timer register
	
GPIO_PORTB_DATA		EQU 0x40005100 ; Access BIT6
GPIO_PORTB_DIR 		EQU 0x40005400 ; Port Direction
GPIO_PORTB_AFSEL	EQU 0x40005420 ; Alt Function enable
GPIO_PORTB_DEN 		EQU 0x4000551C ; Digital Enable
GPIO_PORTB_AMSEL 	EQU 0x40005528 ; Analog enable
GPIO_PORTB_PCTL 	EQU 0x4000552C ; Alternate Functions
GPIO_PORTB_PDR		EQU	0X40005514 ;PULL DOWN REGISTER
	
SYSCTL_RCGCGPIO 	EQU 0x400FE608 ; GPIO Gate Control
SYSCTL_RCGCTIMER 	EQU 0x400FE604 ; GPTM Gate Control
	
LOAD				EQU 0XFFFF
MATCH				EQU	0X7fff
						
			AREA 	routines, CODE, READONLY
			THUMB
			;EXPORT 	My_Timer1A_Handler
			IMPORT	DELAY100
			EXPORT	PWM_INIT
			
PWM_INIT		PROC
				
				;
				;
				;GPIO CONFIG
				
				LDR		R0,=SYSCTL_RCGCGPIO
				LDR		R1,[R0]
				ORR		R1,#0X02
				STR		R1,[R0]
				NOP
				NOP
				NOP
				
				LDR		R0,=GPIO_PORTB_DIR
				LDR		R1,[R0]
				ORR		R1,#0X40			;PIN6 OUTPUT
				STR		R1,[R0]
				
				LDR		R0,=GPIO_PORTB_AFSEL
				LDR		R1,[R0]
				ORR		R1,#0X40
				STR		R1,[R0]
				
				LDR		R0,=GPIO_PORTB_PCTL
				LDR		R1,[R0]
				ORR		R1,#0X07000000
				STR		R1,[R0]
				
				LDR		R0,=GPIO_PORTB_DEN
				LDR		R1,[R0]
				ORR		R1,#0XFF
				STR		R1,[R0]
								
				
				
				
				PUSH	{LR}
				BL		DELAY100
				POP		{LR}
				
				;
				;
				;
				;
				;TIMER CONFIG
				LDR		R0,=SYSCTL_RCGCTIMER
				LDR		R1,[R0]
				ORR		R1,#0X01
				STR		R1,[R0]
				NOP
				NOP
				NOP
				
				
				LDR		R0,=TIMER0_CTL	;DISABLE TIMER0
				LDR		R1,[R0]
				BIC		R1,#1
				STR		R1,[R0]
				
				LDR		R0,=TIMER0_CFG
				LDR		R1,[R0]
				MOV		R1,#0X04
				STR		R1,[R0]
				
				LDR		R0,=TIMER0_TAMR
				LDR		R1,[R0]
				ORR		R1,#0X0A
				BIC		R1,#0X04
				STR		R1,[R0]
				
				;STEP 4
				
				;STEP 5
				
				LDR		R0,=TIMER0_CTL
				LDR		R1,[R0]
				ORR		R1,#0X0C		;BOTH EDGES
				STR		R1,[R0]
				
				LDR		R0,=TIMER0_TAMR
				LDR		R1,[R0]
				ORR		R1,#0X200
				STR		R1,[R0]
				
				LDR		R0,=TIMER0_TAILR
				LDR		R1,=LOAD
				STR		R1,[R0]
				
				LDR		R0,=TIMER0_MATCHR
				LDR		R1,=MATCH
				STR		R1,[R0]			;%50 DUTY CYCLE
				
				LDR		R0,=TIMER0_CTL	;ENABLE TIMER0
				LDR		R1,[R0]
				ORR		R1,#0X01
				STR		R1,[R0]
	
	
				BX		LR
				ENDP
				END
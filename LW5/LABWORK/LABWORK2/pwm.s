NVIC_EN0_INT19		EQU 0x00080000 ; Interrupt 19 enable
NVIC_EN0			EQU 0xE000E100 ; IRQ 0 to 31 Set Enable Register
NVIC_PRI4			EQU 0xE000E410 ; IRQ 16 to 19 Priority Register
	
; 16/32 Timer Registers
TIMER0_CFG			EQU 0x40030000
TIMER0_TBMR			EQU 0x40030008
TIMER0_CTL			EQU 0x4003000C
TIMER0_IMR			EQU 0x40030018
TIMER0_RIS			EQU 0x4003001C ; Timer Interrupt Status
TIMER0_ICR			EQU 0x40030024 ; Timer Interrupt Clear
TIMER0_TBILR		EQU 0x4003002C ; Timer interval
TIMER0_MBTCHR		EQU	0X40030034	;TIMER MATCH
TIMER0_TBPR			EQU 0x4003003C
TIMER0_TBR			EQU	0x4003004C ; Timer register
	
	; 16/32 Timer Registers
TIMER1_CFG			EQU 0x40031000
TIMER1_TAMR			EQU 0x40031004
TIMER1_CTL			EQU 0x4003100C
TIMER1_IMR			EQU 0x40031018
TIMER1_RIS			EQU 0x4003101C ; Timer Interrupt Status
TIMER1_ICR			EQU 0x40031024 ; Timer Interrupt Clear
TIMER1_TAILR		EQU 0x40031028 ; Timer interval
TIMER1_MATCHR		EQU	0X40031030	;TIMER MATCH
TIMER1_TAPR			EQU 0x40031038
TIMER1_TAR			EQU	0x40031048 ; Timer register
		
GPIO_PORTF_DATA		EQU 0x40025100 ; Access BIT6
GPIO_PORTF_DIR 		EQU 0x40025400 ; Port Direction
GPIO_PORTF_AFSEL	EQU 0x40025420 ; Alt Function enable
GPIO_PORTF_DEN 		EQU 0x4002551C ; Digital Enable
GPIO_PORTF_AMSEL 	EQU 0x40025528 ; Analog enable
GPIO_PORTF_PCTL 	EQU 0x4002552C ; Alternate Functions
GPIO_PORTF_PDR		EQU	0X40025514 ;PULL DOWN REGISTER
	
SYSCTL_RCGCGPIO 	EQU 0x400FE608 ; GPIO Gate Control
SYSCTL_RCGCTIMER 	EQU 0x400FE604 ; GPTM Gate Control
	
LOAD				EQU 0XFFFF
MATCH				EQU	0X0FFF
						
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
				ORR		R1,#0X20
				STR		R1,[R0]
				NOP
				NOP
				NOP
				
				LDR		R0,=GPIO_PORTF_DIR
				LDR		R1,[R0]
				ORR		R1,#0X06			;PIN2 OUTPUT
				STR		R1,[R0]
				
				LDR		R0,=GPIO_PORTF_AFSEL
				LDR		R1,[R0]
				ORR		R1,#0X06
				STR		R1,[R0]
				
				LDR		R0,=GPIO_PORTF_PCTL
				LDR		R1,[R0]
				ORR		R1,#0X00000770
				STR		R1,[R0]
				
				LDR		R0,=GPIO_PORTF_DEN
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
				ORR		R1,#0X03
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
				
				LDR		R0,=TIMER0_TBMR
				LDR		R1,[R0]
				ORR		R1,#0X0A
				BIC		R1,#0X04
				STR		R1,[R0]
				
				;STEP 4
				
				;STEP 5
				
				LDR		R0,=TIMER0_CTL
				LDR		R1,[R0]
				ORR		R1,#0XC00		;BOTH EDGES
				STR		R1,[R0]
				
				LDR		R0,=TIMER0_TBMR
				LDR		R1,[R0]
				ORR		R1,#0X200
				STR		R1,[R0]
				
				LDR		R0,=TIMER0_TBILR
				LDR		R1,=LOAD
				STR		R1,[R0]
				
				LDR		R0,=TIMER0_MBTCHR
				LDR		R1,=MATCH
				STR		R1,[R0]			;%50 DUTY CYCLE
				
				LDR		R0,=TIMER0_CTL	;ENABLE TIMER0
				LDR		R1,[R0]
				ORR		R1,#0X100
				STR		R1,[R0]	
				
				;;;;;;;;
				LDR		R0,=TIMER1_CTL	;DISABLE TIMER0
				LDR		R1,[R0]
				BIC		R1,#1
				STR		R1,[R0]
				
				LDR		R0,=TIMER1_CFG
				LDR		R1,[R0]
				MOV		R1,#0X04
				STR		R1,[R0]
				
				LDR		R0,=TIMER1_TAMR
				LDR		R1,[R0]
				ORR		R1,#0X0A
				BIC		R1,#0X04
				STR		R1,[R0]
				
				;STEP 4
				
				;STEP 5
				
				LDR		R0,=TIMER1_CTL
				LDR		R1,[R0]
				ORR		R1,#0X4C		;BOTH EDGES
				STR		R1,[R0]
				
				LDR		R0,=TIMER1_TAMR
				LDR		R1,[R0]
				ORR		R1,#0X200
				STR		R1,[R0]
				
				LDR		R0,=TIMER1_TAILR
				LDR		R1,=LOAD
				STR		R1,[R0]
				
				LDR		R0,=TIMER1_MATCHR
				LDR		R1,=MATCH
				STR		R1,[R0]			;%50 DUTY CYCLE
				
				LDR		R0,=TIMER1_CTL	;ENABLE TIMER0
				LDR		R1,[R0]
				ORR		R1,#0X01
				STR		R1,[R0]	
	
				BX		LR
				ENDP
				END
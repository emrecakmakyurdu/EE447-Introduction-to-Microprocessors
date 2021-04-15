; Pulse.s
; Routine for creating a pulse train using interrupts
; This uses Channel 0, and a 1MHz Timer Clock (_TAPR = 15 )
; Uses Timer1A to READ EDGES on PB4

;Nested Vector Interrupt Controller registers
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
TIMER0_TAPR			EQU 0x40030038
TIMER0_TAR			EQU	0x40030048 ; Timer register
	
;GPIO Registers
GPIO_PORTF_DATA		EQU 0x40025010 ; Access BIT2
GPIO_PORTF_DIR 		EQU 0x40025400 ; Port Direction
GPIO_PORTF_AFSEL	EQU 0x40025420 ; Alt Function enable
GPIO_PORTF_DEN 		EQU 0x4002551C ; Digital Enable
GPIO_PORTF_AMSEL 	EQU 0x40025528 ; Analog enable
GPIO_PORTF_PCTL 	EQU 0x4002552C ; Alternate Functions
	
;System Registers
SYSCTL_RCGCGPIO 	EQU 0x400FE608 ; GPIO Gate Control
SYSCTL_RCGCTIMER 	EQU 0x400FE604 ; GPTM Gate Control
	


;---------------------------------------------------
LOW					EQU	0x6FFFFF
HIGH				EQU	0xFF
;---------------------------------------------------
					
			AREA 	distance, CODE, READONLY
			THUMB
			IMPORT	DELAY100
			EXPORT 	GPTM0A_HANDLER
			EXPORT	DIST_PULSE_INIT
					
;---------------------------------------------------					
GPTM0A_HANDLER		PROC					
					ADD		R10,#1					;GENERATES PULSE
					CMP		R10,#1
					BEQ		HIGHX

				
LOWX				LDR	R0,=GPIO_PORTF_DATA			;SET PULSE TO LOW
					LDR	R1,[R0]
					MOV	R1,#0
					STR	R1,[R0]
					LDR R1, =TIMER0_TAILR
					LDR R2, =LOW
					STR R2, [R1]
					MOV	R10,#0
					B	EXIT
					
HIGHX				LDR	R0,=GPIO_PORTF_DATA			;SET PULSE TO HIGH
					LDR	R1,[R0]
					MOV	R1,#4
					STR	R1,[R0]
					LDR R1, =TIMER0_TAILR
					LDR R2, =HIGH
					STR R2, [R1]					
					B	EXIT
					
EXIT				LDR	R0,=TIMER0_ICR
					ORR	R1,#0X01
					STR	R1,[R0]
					BX 	LR 
					ENDP
;---------------------------------------------------

DIST_PULSE_INIT	PROC
				LDR R1, =SYSCTL_RCGCGPIO ; start GPIO clock
				LDR R0, [R1]
				ORR R0, R0, #0x20 ; set bit 5 for port F
				STR R0, [R1]
				NOP ; allow clock to settle
				NOP
				NOP
				LDR R1, =GPIO_PORTF_DIR ; set direction of PF2
				LDR R0, [R1]
				ORR R0, R0, #0x04 ; set bit2 for output
				STR R0, [R1]
				LDR R1, =GPIO_PORTF_AFSEL ; regular port function
				LDR R0, [R1]
				BIC R0, R0, #0x04
				STR R0, [R1]
				LDR R1, =GPIO_PORTF_PCTL ; no alternate function
				LDR R0, [R1]
				BIC R0, R0, #0x00000F00
				STR R0, [R1]
				LDR R1, =GPIO_PORTF_AMSEL ; disable analog
				LDR	R0,[R1]
				BIC R0, #0X04
				STR R0, [R1]
				LDR R1, =GPIO_PORTF_DEN ; enable port digital
				LDR R0, [R1]
				ORR R0, R0, #0x04
				STR R0, [R1]
			
				PUSH {LR}
				BL 	DELAY100			;WAIT 100MSEC
				POP	{LR}
				LDR R1, =SYSCTL_RCGCTIMER ; Start Timer0
				LDR R2, [R1]
				ORR R2, R2, #0x01
				STR R2, [R1]
				NOP ; allow clock to settle
				NOP
				NOP
				LDR R1, =TIMER0_CTL ; disable timer during setup LDR R2, [R1]
				BIC R2, R2, #0x01
				STR R2, [R1]
				LDR R1, =TIMER0_CFG ; set 32 bit mode
				MOV R2, #0x00
				STR R2, [R1]
				LDR R1, =TIMER0_TAMR
				MOV R2, #0x02 ; set to periodic, count down
				STR R2, [R1]
				LDR R1, =TIMER0_TAILR ; initialize match clocks
				LDR R2, =HIGH
				STR R2, [R1]
				LDR R1, =TIMER0_TAPR
				MOV R2, #0X13 ; divide clock by 16 to
				STR R2, [R1] ; get 1us clocks
				LDR R1, =TIMER0_IMR ; enable timeout interrupt
				MOV R2, #0x01
				STR R2, [R1]
	; Configure interrupt priorities
	; Timer0A is interrupt #19.
	; Interrupts 16-19 are handled by NVIC register PRI4.
	; Interrupt 19 is controlled by bits 31:29 of PRI4.
	; set NVIC interrupt 19 to priority 2
				LDR R1, =NVIC_PRI4
				LDR R2, [R1]
				AND R2, R2, #0x00FFFFFF ; clear interrupt 19 priority
				ORR R2, R2, #0x40000000 ; set interrupt 19 priority to 2
				STR R2, [R1]
	; NVIC has to be enabled
	; Interrupts 0-31 are handled by NVIC register EN0
	; Interrupt 19 is controlled by bit 19
	; enable interrupt 19 in NVIC
				LDR R1, =NVIC_EN0
				MOVT R2, #0x08 ; set bit 19 to enable interrupt 19
				STR R2, [R1]
	; Enable timer
				LDR R1, =TIMER0_CTL
				LDR R2, [R1]
				ORR R2, R2, #0x03 ; set bit0 to enable
				STR R2, [R1] ; and bit 1 to stall on debug
				BX LR ; return
				ENDP
				END
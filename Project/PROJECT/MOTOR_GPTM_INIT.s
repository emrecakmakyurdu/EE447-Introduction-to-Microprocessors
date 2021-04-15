;System Registers
SYSCTL_RCGCGPIO 	EQU 0x400FE608 ; GPIO Gate Control
SYSCTL_RCGCTIMER 	EQU 0x400FE604 ; GPTM Gate Control
	
; 16/32 Timer Registers
TIMER5_CFG			EQU 0x40035000
TIMER5_TAMR			EQU 0x40035004
TIMER5_CTL			EQU 0x4003500C
TIMER5_IMR			EQU 0x40035018
TIMER5_RIS			EQU 0x4003501C ; Timer Interrupt Status
TIMER5_ICR			EQU 0x40035024 ; Timer Interrupt Clear
TIMER5_TAILR		EQU 0x40035028 ; Timer interval
TIMER5_TAPR			EQU 0x40035038
TIMER5_TAR			EQU	0x40035048 ; Timer register
	
;NVIC
NVIC_ISER2			EQU	0XE000E108
NVIC_IPR27			EQU	0XE000E46C
	
MAXSPEED	EQU			0X1388				;ACCORDING TO THE PROJECT LIMITATION

	
	
;LABEL			DIRECTIVE	VALUE				COMMENT	
				AREA init_isr,	CODE,	READONLY,	ALIGN=2
				THUMB
					
				EXPORT		MOTOR_GPTM_INIT

			
MOTOR_GPTM_INIT	PROC
				LDR R1, =SYSCTL_RCGCTIMER ; Start Timer5
				LDR R2, [R1]
				ORR R2, R2, #0x20
				STR R2, [R1]
				NOP ; allow clock to settle
				NOP
				NOP
				LDR R1, =TIMER5_CTL ; disable timer during setup 
				LDR R2, [R1]
				BIC R2, R2, #0x01
				STR R2, [R1]
				LDR R1, =TIMER5_CFG ; set 16 bit mode
				MOV R2, #0x04
				STR R2, [R1]
				LDR R1, =TIMER5_TAMR
				MOV R2, #0x02 ; PERIODIC count down
				STR R2, [R1]
				LDR R1, =TIMER5_TAILR ; initialize match clocks
				LDR R2, =MAXSPEED
				STR R2, [R1]
				LDR R1, =TIMER5_ICR
				LDR R2, =0X01
				STR R2, [R1]						
				LDR R1, =TIMER5_IMR	;setup interrupt
				LDR R2, =0X01
				STR	R2,[R1]
				LDR R1, =TIMER5_TAPR
				MOV R2, #15 ; divide clock by 16 to
				STR R2, [R1] ; get 1us clocks

				LDR R1, =NVIC_IPR27
				LDR R2, [R1]
				AND R2, R2, #0xFFFFFF00
				ORR R2, R2, #0x00000040
				STR R2, [R1]

				LDR R1, =NVIC_ISER2
				MOVT R2, #0x1000
				STR R2, [R1]				
	
; Enable timer
				LDR R1, =TIMER5_CTL
				LDR R2, [R1]
				ORR R2, R2, #0x03 ; enable, STALL
				STR R2, [R1]				
				
				
				BX		LR
				ENDP
				END
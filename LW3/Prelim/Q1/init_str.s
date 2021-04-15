;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;		   SYSTICK INITIALIZATION OF Q1			  ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


NVIC_ST_CTRL	EQU		0XE000E010				;ILK BIT TIMER ENABLE, 2.BIT INTERRUPT ENABLE, 3. BIT TIMER SOURCE (0:PIOSC/4 1:SYSTEM CLOCK), 16.BIT 
NVIC_ST_RELOAD	EQU		0XE000E014				;24 BIT, WHEN THE COUNTER REACHES 0, IT IS RELOADED WITH THIS VALUE
NVIC_ST_CURRENT	EQU		0XE000E018				;THE CURRENT VALUE OF THE COUNTER
SHP_SYSPRI3		EQU		0XE000ED20				;BITS 31:29, PRIORITY LEVEL MUST BE 1 OR GREATER TO ENABLE SYSTICK INTERRUPTS
PB_OUT			EQU		0X400053C0

	
RELOAD_VALUE	EQU		0X2000				;7D0 = 2000, 2000*250NS = 500 MS


;LABEL			DIRECTIVE	VALUE				COMMENT	
				AREA init_isr,	CODE,	READONLY,	ALIGN=2
				THUMB
					
				EXPORT		InitSysTick

			
InitSysTick		PROC
; FIRST DISABLE SYSTEM TIMER AND THE RELATED INTERRUPT THEN CONFIGURE IT TO USE INTERNAL OSCILLATOR PIOSC/4
				LDR			R1,=NVIC_ST_CTRL
				MOV			R0,#0
				STR			R0,[R1]
; NOW SET THE TIMEOUT PERIOD
				LDR 		R1,=NVIC_ST_RELOAD
				LDR			R0,=RELOAD_VALUE
				STR			R0,[R1]
;NOW SET THE CURRENT TIMER VALUE TO TIME OUT VALUE
				LDR			R1,=NVIC_ST_CURRENT
				LDR			R0,=RELOAD_VALUE
				STR			R0,[R1]
;NOW SET THE PRIORITY LEVEL
				LDR			R1,=SHP_SYSPRI3
				MOV			R0,#0X40000000			;PRIORITY SET TO 2
				STR			R0,[R1]
;NOW ENABLE	SYSTEM TIMER AND THE RELATED INTERRUPT
				LDR			R1,=NVIC_ST_CTRL
				MOV			R0,#0X03
				STR			R0,[R1]
				CPSIE		I
			
				BX		LR
				ENDP
				END
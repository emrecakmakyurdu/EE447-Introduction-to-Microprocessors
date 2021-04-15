; constants

;===================
; Timer 1 registers
;===================
TIMER1_CFG			EQU 0x40031000 ; Timer Configuration
TIMER1_TAMR			EQU 0x40031004 ; Timer A Mode
TIMER1_CTL			EQU 0x4003100C ; Timer Control
TIMER1_TAILR		EQU 0x40031028 ; Timer Interval
TIMER1_TAMATCHR		EQU	0x40031030 ; Timer Match
TIMER1_TAPR			EQU 0x40031038 ; Timer Prescaler

;=======================
; GPIO Port F registers
;=======================
GPIO_PORTF_AFSEL	EQU 0x40025420 ; Alt Function enable
GPIO_PORTF_DEN 		EQU 0x4002551C ; Digital Enable
GPIO_PORTF_PCTL 	EQU 0x4002552C ; Alternate Functions

;=================
;System Registers
;=================
SYSCTL_RCGCGPIO 	EQU 0x400FE608 ; GPIO Gate Control
SYSCTL_RCGCTIMER 	EQU 0x400FE604 ; GPTM Gate Control

    area a_text, readonly, code
        thumb
		IMPORT		PWM_INIT
		extern InChar
        export __main

;==============
; PF2 PWM Init
;==============
pwm_init proc
	;===================
	; Configure PORTF.2
	;===================
	
	; YOUR CODE HERE
	
	;====================
	; Configure TIMER1-A
	;====================
	
	; YOUR CODE HERE
	
	bx lr
	endp

__main proc
    BL
	
input_loop
	;============
	; Main Logic
	;============
	
	; YOUR CODE HERE
	
	b input_loop
	
__main_done
    wfi
    b __main_done
    endp
    end
;
; recursive_gcd.asm
;
; Created: 9/10/2019 3:05:30 AM
; Author : Jacob Burns z3332718
;
.include "m2560def.inc"

.def lo_a=r16
.def hi_a=r17
.def lo_b=r18
.def hi_b=r19
;r21
;r22
;r23
;r24
.def zero=r25

; modulo
; a(@5, @6) % b(@7, @8)
; result is stored in a(@0, @1)
; operation - continually sub a from b until a <= b
; for the purposes of this code: [r16...r19] = [@5...@7] and [r20...r23] = [@0...@4]
.macro mod
	movw @4:@5, @0:@1
	movw @6:@7, @2:@3			
	loopMod:
	cp @0, @2
	cpc @1, @3 ;a == b
	sub @0, @2
	sbc @1, @3
	brsh sbtr
	jmp endMod
	subtr:
	sub @0, @2
	sbc @1, @3
	jmp loopMod
	endMod:
.endmacro

main:
	clr zero
	ldi lo_a, 0x2C
	ldi hi_a, 0x01
	ldi lo_b, 0xE8
	ldi hi_b, 0x01
	rcall gcd

gcd: ;gcd(int_16 a, int_16 b)

	;prologue
	
	;push arguments to stack
	push lo_a 
	push hi_a
	push lo_b
	push hi_b

	;push stack frame pointers to stack
	push YL
	push YH		

	;set Y to SP - new stack top
	in YL, SPL	
	in YH, SPH

	;reserve enough space for 2 int_16
	sbiw Y, 4	

	;update SP to reflect new stack top Y
	out SPL, YL 
	out SPH, YH
	
	;load our args onto stack
	std Y+1, lo_a
	std Y+2, hi_a
	std Y+3, lo_b
	std Y+4, hi_b

	;check b != 0
	cp lo_b, zero
	cpc hi_b, zero
	breq case_2


	case_1: ;b != 0
		;return gcd(b, a%b)
		;mod r20, r21, r22, r23, lo_a, hi_a, lo_b, hi_b ; a % b = r20:r21
		movw lo_a:hi_a, r20:r21
		movw lo_b:hi_b, r22:r23			
		loopMod:
		cp r20, r22
		cpc r21, r23
		sub r20, r22
		sbc r21, r23
		brsh subtr
		brlo endMod
		subtr:
		sub r20, r22
		sbc r21, r23
		jmp loopMod
	endMod:
		movw lo_a:hi_a, lo_b:hi_b	;b -> a
		movw lo_b:hi_b, r20:r21		;a%b -> b		
		rcall gcd
	case_2: ;b == 0
		;return a
		adiw Y, 4
		out SPH, YH
		out SPL, YL
		pop hi_b
		pop lo_b
		pop hi_a
		pop lo_a
		ret


	
	



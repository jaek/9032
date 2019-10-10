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
.def zero=r_20

; modulo
; a(@0, @1) % b(@2, @3)
; result is stored in a(@0, @1)
; operation - continually sub a from b until a <= b
.macro mod		
	loop:		
	sub @0, @2
	sbc @1, @3
	cp @0, @2
	cpc @1, @3
	brge loop
.endmacro

main:
	clr zero
	rcall gcd

gcd: ;gcd(int_16 a, int_16 b)

	;prologue
	push YL
	push YH		;stack frame pointers saved to stack

	in YL, SPL	;set Y to SP - new stack top
	in TH, SPH

	sbiw Y, 6	;reserve enough space for 3 int_16

	out SPL, YL ;update SP to reflect new stack top Y
	out SPH, YH
	
	;load our args into stack
	std Y+1, lo_a
	std Y+2, hi_a
	std Y+3, lo_b
	std Y+4, hi_b
	;end prologue

	;check b != 0
	cp lo_b, zero
	cpc hi_b, zero
	breq finished

	finsished:
		rjump finished
	
	



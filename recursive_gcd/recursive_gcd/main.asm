;
; recursive_gcd.asm
;
; Created: 9/10/2019 3:05:30 AM
; Author : user
;
.include "m2560def.inc"

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

.def hi_a=r16
.def lo_a=r17
.def hi_b=r18
.def lo_b=r19

ldi hi_a, 0x00
ldi lo_a, 0x11
ldi hi_b, 0x00
ldi lo_b, 0x03 

mod hi_a, lo_a, hi_b, lo_b

ldi hi_a, 0x00
ldi lo_a, 0x06
ldi hi_b, 0x00
ldi lo_b, 0x03

mod hi_a, lo_a, hi_b, lo_b 
nop


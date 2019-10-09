;
; BinaryConversion.asm
;
; Created: 24/09/2019 1:39:46 PM
; Author : Jacob Burns

;; DESCRIPTION =======
;; Converts an ASCII representation of a number to a binary value.
;; takes advantage of the underlying representation of the ASCII charset to convert
;; Simply subtract the difference between the ascii value and target val, i.e:
;; ASCII F = 0x46 - 55 = 0x0F = 0b00001111
;; if either digit is >= 0x41 then we set the hex flag to 1 constants and defines
.include "m2560def.inc"
.def firstDigit=r16
.def secondDigit=r17
.def output=r18
.def baseFlag=r19 ;bit 0 is used to store whether or not the char is represented as hex or not

.EQU HEX_SUB=7
.EQU DEC_OFFSET=48 ; offset for dec digits 1, 2, 3...
.EQU HEX_OFFSET=65 ; offset for hex digits A, B, C...

;debugging - do not use
;ldi firstDigit, 0x46
;ldi secondDigit, 0x46

main:
	;; FIRST DIGIT
	; check whether  digit is hex value, adjust accordingly
	;is the first digit >= A? 
	cpi firstDigit, HEX_OFFSET
	brsh firstDigitHex
	jmp firstDigitDec
	firstDigitHex: ;the first character is >= A
		subi firstDigit, HEX_SUB ; convert to underlying rep + 48
		ori baseFlag, 0b10000000
	firstDigitDec: ;first char 0 <= x <= 9
	    subi firstDigit, DEC_OFFSET ;convert to underlying rep 

	cpi baseFlag, 0 ;is hex?
	brne hexadecimal
	jmp decimal
	
	;;multiply the first digit by 10 or 16  - depending on base
	hexadecimal:
		ldi r20, 16
		mul firstDigit, r20
		mov firstDigit, r0
		jmp hex_end
	decimal:
		ldi r20, 10
		mul firstDigit, r20
		mov firstDigit, r0
		ldi r20, 0 ;clear register 20
	hex_end:


	;;SECOND DIGIT
	;is the second digit >= A? 
	cpi secondDigit, HEX_OFFSET
	brsh secondDigitHex
	jmp secondDigitDec
    secondDigitHex: 
		subi secondDigit, HEX_SUB
		ori baseFlag, 0b10000000
	secondDigitDec: 
		subi secondDigit, DEC_OFFSET ;convert to number

	;both digits are now ready to be converted to a binary number
	mov output, secondDigit ;move result to output
	add output, firstDigit
	or output, baseFlag
	returnResult:
	
	



 
	






	


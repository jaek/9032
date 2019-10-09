; greatestCommon.asm
;
; Created: 25/09/2019 11:33:38 PM
; Author : Jacob Burns z3332718
;

;;assign registers for each byte of each digit
.def hi_a=r16
.def lo_a=r17
.def hi_b=r18
.def lo_b=r19

;;4000
;:5000 
;;1000
;;while a != b:
;;	if(a>b):
;;		a = a -b
;;	else:
;;		b = b - a

while:
	cp lo_a, lo_b
	cpc hi_a, hi_b ;; compare hi and lo bits of each digit
	breq finish ;;check whether a and be are equal. if they are equal, we're done
	brge case1 ;; a>b
		case2: ;; a < b, so b = b - a
			sub lo_b, lo_a
			sbc hi_b, hi_a
		case1: ;; a > b, so a = a -b
			sub lo_a, lo_b
			sbc hi_a, hi_b
			jmp while;; do not evaluate case2
finish:


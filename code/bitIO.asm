.include "2313def.inc"
.def	temp=r17
.cseg
rjmp	start
start:
	ldi		temp,low(RAMEND)		;���|
	out		SPL,temp
	ldi		temp,$ff
	out		ddrb,temp
;***************************************
;�Q��I/O���Osbi,cbi����]���O
;��@�줸�ʧ@���Nin,out
;
;
;***************************************
	clr		r16
	out		portb,r16			;LED���G
repeat:	sbi		portB,0
	rcall		DELAY
	sbi		portB,1
	rcall		DELAY
	sbi		portB,2
	rcall		DELAY
	sbi		portB,3
	rcall		DELAY
	sbi		portB,4
	rcall		DELAY
	sbi		portB,5
	rcall		DELAY
	sbi		portB,6
	rcall		DELAY
	sbi		portB,7
	rcall		DELAY

	cbi		portB,0
	rcall		DELAY
	cbi		portB,1
	rcall		DELAY
	cbi		portB,2
	rcall		DELAY
	cbi		portB,3
	rcall		DELAY
	cbi		portB,4
	rcall		DELAY
	cbi		portB,5
	rcall		DELAY
	cbi		portB,6
	rcall		DELAY
	cbi		portB,7
	rcall		DELAY
	rjmp		repeat

DELAY:
	ldi		r20,5
	ldi		r21,255
	ldi		r22,255
del:	
	dec		r22
	brne	del
	dec		r21
	brne	del
	dec		r20
	brne	del
	ret

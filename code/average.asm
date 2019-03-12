.include "2313def.inc"
.def	time=R16
.def	temp=r17
.cseg
rjmp	start
start:
	ldi		temp,low(RAMEND)		;∞Ô≈|
	out		SPL,temp
;***************************************
	ldi		r18,127
	clr		r20
	clr		temp
	clr		time
loop:
	add		temp,r18
	brcc	noCarry
	inc		time
noCarry:
	dec		r20
	brne	loop

wait:	rjmp		wait
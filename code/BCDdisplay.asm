;******************七段顯示**********
;個位數:PD0~PD3
;十位數:PD4,PD5,PD6,PB7
;display將R16內的值轉成BCD code
;************************************
.include "2313def.inc"
.def	temp=r17
.def	EndCode=r18
.cseg
rjmp	start
start:
	ldi		temp,low(RAMEND)		;堆疊
	out		SPL,temp
	ldi		temp,$ff
	ldi		EndCode,$ff
	out		ddrb,temp
	out		ddrd,temp
display:
	ldi	ZH,high(2*message)
	ldi	ZL,low(2*message)
loadBCD:
	lpm			;
	cp		r0,EndCode
	breq		display
	out		portd,r0
	rcall		DELAY
	adiw		ZL,1
	rjmp		loadBCD

;*************延遲一秒*****************
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
;*************************************
message:
	.db	$00,$01,$02,$03,$04,$05,$06,$07,$08,$09
	.db	$10,$11,$12,$13,$14,$15,$16,$17,$18,$19
	.db	$20,$21,$22,$23,$24,$25,$26,$27,$28,$29
	.db	$30,$31,$32,$33,$34,$35,$36,$37,$38,$39
	.db	$40,$41,$42,$43,$44,$45,$46,$47,$48,$49
	.db	$50,$51,$52,$53,$54,$55,$56,$57,$58,$59
	.db	$60,$61,$62,$63,$64,$65,$66,$67,$68,$69
	.db	$70,$71,$72,$73,$74,$75,$76,$77,$78,$79,$ff
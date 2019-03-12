.include "2313def.inc"
;***** Constants*************************************
.equ	preset=206			;T/C0 Preset constant (256-50)R=20k,c=0.01uf	
;***** A/D converter Global Registers****************
.def	result=r16			;�ഫ���G
.def	temp1=r17			;�ܼ� register
.def	temp2=r18
.def	avgVoltage=R19
.def	Accumulator=r20
.def	loopReg=r21
.cseg
	.org $0000
	rjmp RESET      	;Reset ���_�V�q
	.org OVF0addr
	rjmp ANA_COMP   	;Timer0 overflow ���_�V�q
	.org ACIaddr
	rjmp ANA_COMP   	;Analog comparator ���_�V�q
;**********************************************************************
ANA_COMP:       
		in      result,TCNT0    ;Load timer value
		cbi     PORTB,PB2       ;�q�e�}�l��q
		sbi     PORTB,PB3       
		clr     temp1    		;Stop timer0
		out     TCCR0,temp1
		subi    result,preset+1 ;��h�w�]�`��
		set						;Set T flag	(=1,�ഫ����)
								;			(=0,���b�ഫ)
		cbi     PORTB,PB3		;fast discharge �T��(�j��1us�ɶ�)
		reti                    ;Return
;***********************************************************************
convert_init:
		clr		loopReg
		clr		Accumulator
		clr		avgVoltage
		ldi		temp1,$ff		;set port D as output
		out		DDRD,temp1		
		sbi		ddrb,2			;�R��q�]�w�줸�]����X
		sbi		ddrb,3			;�ֳt��q����줸�]����X
		cbi     PORTB,PB2       ;�q�e�}�l��q
		sbi		PORTB,PB3
		ldi     temp1,$02      	;Enable Timer0 interrupt
		out     TIMSK,temp1		
		cbi		PORTB,PB3
		ret						;Return
;************************************************************************
AD_convert:
		ldi     temp2,preset   ;Clear counter
		out     TCNT0,temp2    ;and load offset value
		clt						;Clear T flag
		ldi		temp2,$02		;�w�� f/8 and �}�l�p��
		out     TCCR0,temp2    
		sbi     PORTB,PB2       ;Start charging
		ret						;Return
;******************RC discharge time*********************
Delay:	
		clr		temp2		
		ldi		temp1,$fd	
loop1:	
		inc		temp2		
		brne	loop1		
		inc 	temp1		
		brne 	loop1		
		ret

;**************main program*******************************************
RESET:	
		ldi		temp1,low(RAMEND)		;���|�]�w
		out		SPL,temp1
		rcall	convert_init	;A/D �ഫ�]�w
		sei						;Enable interrupt
again:	rcall	Delay			;��q����
		rcall	AD_convert		;�}�l�ഫ
Wait:	brtc	Wait			;����
		rjmp	again			;again
;**********************************************************************
message:
	.db	$00,$01,$02,$03,$04,$05,$06,$07,$08,$09
	.db	$10,$11,$12,$13,$14,$15,$16,$17,$18,$19
	.db	$20,$21,$22,$23,$24,$25,$26,$27,$28,$29
	.db	$30,$31,$32,$33,$34,$35,$36,$37,$38,$39
	.db	$40,$41,$42,$43,$44,$45,$46,$47,$48,$49
	.db	$50
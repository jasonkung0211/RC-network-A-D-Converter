.include "2313def.inc"
;***** Constants*************************************
.equ	preset=189			;T/C0 Preset constant (256-50)R=20k,c=0.01uf	
;***** A/D converter Global Registers****************
.def	result=r16			;轉換結果
.def	temp1=r17			;變數 register
.def	temp2=r18
.def	avgVoltage=R19
.def	Accumulator=r20
.def	loopReg=r21
.cseg
	.org $0000
	rjmp RESET      	;Reset 中斷向量
	.org OVF0addr
	rjmp ANA_COMP   	;Timer0 overflow 中斷向量
	.org ACIaddr
	rjmp ANA_COMP   	;Analog comparator 中斷向量
;**********************************************************************
ANA_COMP:       
		in      result,TCNT0    ;Load timer value
		cbi     PORTB,PB2       ;電容開始放電
		sbi     PORTB,PB3       
		clr     temp1    		;Stop timer0
		out     TCCR0,temp1
		subi    result,preset+1 ;減去預設常數
		set						;Set T flag	(=1,轉換完成)
								;			(=0,正在轉換)
		cbi     PORTB,PB3		;fast discharge 禁能
		reti                    ;Return
;***********************************************************************
convert_init:
		clr		loopReg
		clr		Accumulator
		clr		avgVoltage
		ldi		temp1,$ff		;set port D as output
		out		DDRD,temp1		
		sbi		ddrb,2			;充放電設定位元設為輸出
		sbi		ddrb,3			;快速放電控制位元設為輸出
		cbi     PORTB,PB2       ;電容開始放電
		sbi		PORTB,PB3
        ldi     temp1,$0B   	;上緣觸發致能
		out     ACSR,temp1 		;
		ldi     temp1,$02      	;Enable Timer0 interrupt
		out     TIMSK,temp1		
		cbi		PORTB,PB3
		ret						;Return
;************************************************************************
AD_convert:
		ldi     temp2,preset   ;Clear counter
		out     TCNT0,temp2    ;and load offset value
		clt						;Clear T flag
		ldi		temp2,$02		;預除 f/8 and 開始計時
		out     TCCR0,temp2    
		sbi     PORTB,PB2       ;Start charging
		ret						;Return

;*********************************************************************
;
Delay:		
		ldi	temp1,$f0	
loop1:		inc 	temp1		
		brne 	loop1		
		ret
;將result轉成BCD碼;PORTD輸出BCD碼
;**********************************************************************
display:
	add		Accumulator,result
	brcc	noCarry
	inc		avgVoltage
noCarry:
	dec		loopReg
	brne	exit
	ldi		ZH,high(2*message)
	ldi		ZL,low(2*message)
	add		ZL,avgVoltage
	lpm		
	out		portd,r0
	clr		loopReg
	clr		Accumulator
	clr		avgVoltage
exit:
	ret
;**************main program*******************************************
RESET:	
		ldi		temp1,low(RAMEND)		;堆疊設定
		out		SPL,temp1
		rcall	convert_init	;A/D 轉換設定
		sei						;Enable interrupt
again:		rcall	Delay
		rcall	AD_convert		;開始轉換
Wait:	brtc	Wait			;等待
		rcall	display
		rjmp	again			;again
;**********************************************************************
message:
	.db	$00,$01,$02,$03,$04,$05,$06,$07,$08,$09
	.db	$10,$11,$12,$13,$14,$15,$16,$17,$18,$19
	.db	$20,$21,$22,$23,$24,$25,$26,$27,$28,$29
	.db	$30,$31,$32,$33,$34,$35,$36,$36,$37,$37
	.db	$38,$38,$38,$39,$39,$40,$40,$40,$42,$42
	.db	$44,$44,$46,$46,$48,$48,$50,$50
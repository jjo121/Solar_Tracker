#include <xc.inc>

global compare1, compare2
extrn  Photodiode_EastL, Photodiode_EastH,Photodiode_WestL,Photodiode_WestH

extrn	ADC_Setup, ADC_Read

psect	udata_acs
	
tempCompare1:	    ds	1
tempCompare2:	    ds	1
status1:	    ds	1
status2:	    ds	1
    
psect	adc_code, class=CODE

compare1:
	movf	Photodiode_EastH
	subwf	Photodiode_WestH
	movwf	tempCompare1
	btfss	STATUS, 0
	bra	compare2
	comf	tempCompare1
	incf	tempCompare1
	movlw	0x01
	movwf	status1
	bcf	STATUS,0
compare2:	
	movf	Photodiode_EastL
	subwf	Photodiode_WestL
	movwf	tempCompare2
	btfss	STATUS, 0
	return
	comf	tempCompare2
	incf	tempCompare2
	movlw	0x01
	movwf	status2
	return

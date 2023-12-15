#include <xc.inc>

global status_p0p2_p1p3_l, status_p0p2_p1p3_h, status_p0p1_p2p3_l, status_p0p1_p2p3_h
global difference_p0p2_p1p3_l, difference_p0p2_p1p3_h, difference_p0p1_p2p3_l, difference_p0p1_p2p3_h
global compare_p0p2_p1p3_h, compare_p0p2_p1p3_l, compare_p0p1_p2p3_h, compare_p0p1_p2p3_l
global	average
global  totalp0p1H, totalp0p1L, totalp0p2H, totalp0p2L, totalp1p3H, totalp1p3L, totalp2p3H, totalp2p3L
    
extrn  Photodiode_0L, Photodiode_0H,Photodiode_1L,Photodiode_1H
extrn  Photodiode_2L, Photodiode_2H,Photodiode_3L,Photodiode_3H

psect	udata_acs
	
difference_p0p2_p1p3_l:  	ds  1
difference_p0p2_p1p3_h:  	ds  1
difference_p0p1_p2p3_l:  	ds  1
difference_p0p1_p2p3_h:  	ds  1

status_p0p2_p1p3_l:		ds  1
status_p0p2_p1p3_h:		ds  1
status_p0p1_p2p3_l:	    	ds  1
status_p0p1_p2p3_h:		ds  1

totalp0p1H:	  	ds  1
totalp0p2H:	    	ds  1
totalp1p3H:	    	ds  1  
totalp2p3H:	    	ds  1
totalp0p1L:	    	ds  1
totalp0p2L:	    	ds  1
totalp1p3L:	    	ds  1  
totalp2p3L:	    	ds  1

psect	adc_code, class=CODE

average:
	movf	Photodiode_0H,W, A
	addwf	Photodiode_1H,W, A
	movwf	totalp0p1H, A
	rrcf	totalp0p1H, F, A
	
	
	movf	Photodiode_0L,W, A
	addwf	Photodiode_1L,W, A
	movwf	totalp0p1L, A
	rrcf	totalp0p1L, F, A
	
	movf	Photodiode_0H,W, A
	addwf	Photodiode_2H,W, A
	movwf	totalp0p2H, A
	rrcf	totalp0p2H, F, A
	
	movf	Photodiode_0L,W, A
	addwf	Photodiode_2L,W, A
	movwf	totalp0p2L, A
	rrcf	totalp0p2L, F, A
	
	movf	Photodiode_1H,W, A
	addwf	Photodiode_3H,W, A
	movwf	totalp1p3H, A
	rrcf	totalp1p3H, F, A
	
	movf	Photodiode_1L,W, A
	addwf	Photodiode_3L,W, A
	movwf	totalp1p3L, A
	rrcf	totalp1p3L, F, A
	
	movf	Photodiode_2H,W, A
	addwf	Photodiode_3H,W, A
	movwf	totalp2p3H, A
	rrcf	totalp2p3H, F, A
	
	movf	Photodiode_2L,W, A
	addwf	Photodiode_3L,W, A
	movwf	totalp2p3L, A
	rrcf	totalp2p3L, F, A
	return

compare_p0p2_p1p3_h:
	movlw	0x00
	movwf	status_p0p2_p1p3_h
	movf	totalp1p3H, W
	subwf	totalp0p2H, W
	movwf	difference_p0p2_p1p3_h
	btfsc	STATUS, 0
	bra	compare_p0p2_p1p3_l
	comf	difference_p0p2_p1p3_h
	incf	difference_p0p2_p1p3_h
	movlw	0x01
	movwf	status_p0p2_p1p3_h
	bcf	STATUS, 0

compare_p0p2_p1p3_l:
	movlw	0x00
	movwf	status_p0p2_p1p3_l
	movf	totalp1p3L, W
	subwf	totalp0p2L, W
	movwf	difference_p0p2_p1p3_l
	btfsc	STATUS, 0
	return
	comf	difference_p0p2_p1p3_l
	incf	difference_p0p2_p1p3_l
	movlw	0x01
	movwf	status_p0p2_p1p3_l
	return

compare_p0p1_p2p3_h:
	movlw	0x00
	movwf	status_p0p1_p2p3_h
	movf	totalp2p3H, W
	subwf	totalp0p1H, W
	movwf	difference_p0p1_p2p3_h
	btfsc	STATUS, 0
	bra	compare_p0p1_p2p3_l
	comf	difference_p0p1_p2p3_h
	incf	difference_p0p1_p2p3_h
	movlw	0x01
	movwf	status_p0p1_p2p3_h
	bcf	STATUS, 0

compare_p0p1_p2p3_l:
	movlw	0x00
	movwf	status_p0p1_p2p3_l
	movf	totalp2p3L, W
	subwf	totalp0p1L, W
	movwf	difference_p0p1_p2p3_l
	btfsc	STATUS, 0
	return
	comf	difference_p0p1_p2p3_l
	incf	difference_p0p1_p2p3_l
	movlw	0x01
	movwf	status_p0p1_p2p3_l
	return
	end

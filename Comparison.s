#include <xc.inc>

;Calculate averages of pairs of photodiode readings
;Calculate the magnitude of the difference of averages and get their sign
global status_p0p2_p1p3_l, status_p0p2_p1p3_h, status_p0p1_p2p3_l, status_p0p1_p2p3_h 
global difference_p0p2_p1p3_l, difference_p0p2_p1p3_h, difference_p0p1_p2p3_l, difference_p0p1_p2p3_h; 
global compare_p0p2_p1p3_h, compare_p0p2_p1p3_l, compare_p0p1_p2p3_h, compare_p0p1_p2p3_l
global	average
global  totalp0p1H, totalp0p1L, totalp0p2H, totalp0p2L, totalp1p3H, totalp1p3L, totalp2p3H, totalp2p3L
    
extrn  Photodiode_0L, Photodiode_0H,Photodiode_1L,Photodiode_1H
extrn  Photodiode_2L, Photodiode_2H,Photodiode_3L,Photodiode_3H

psect	udata_acs
	
difference_p0p2_p1p3_l:  	ds  1 ;Define vraiables which hold the upper and lower bytes of the difference calculations
difference_p0p2_p1p3_h:  	ds  1
difference_p0p1_p2p3_l:  	ds  1
difference_p0p1_p2p3_h:  	ds  1

status_p0p2_p1p3_l:		ds  1 ;Define variables which checks signs of differences of photodiode pair readings
status_p0p2_p1p3_h:		ds  1
status_p0p1_p2p3_l:	    	ds  1
status_p0p1_p2p3_h:		ds  1

totalp0p1H:	  	ds  1 ;Defines variables used to sum pairs of photodiode readings and then get their average and store in same variable
totalp0p2H:	    	ds  1
totalp1p3H:	    	ds  1  
totalp2p3H:	    	ds  1
totalp0p1L:	    	ds  1
totalp0p2L:	    	ds  1
totalp1p3L:	    	ds  1  
totalp2p3L:	    	ds  1

psect	adc_code, class=CODE

average: ;Calculate averages  of reading of photodiode pairs. Done seperately for higher and lower bytes of readings,
	;Higher byte-Average of photodiodes 1 an 0
 	movf	Photodiode_0H,W, A 
	addwf	Photodiode_1H,W, A
	movwf	totalp0p1H, A
	rrcf	totalp0p1H, F, A 
 
	;Lower byte-Average of photodiodes 1 an 0
	movf	Photodiode_0L,W, A
	addwf	Photodiode_1L,W, A
	movwf	totalp0p1L, A
	rrcf	totalp0p1L, F, A

 	;Upper byte-Average of photodiodes 0 and 2
	movf	Photodiode_0H,W, A
	addwf	Photodiode_2H,W, A
	movwf	totalp0p2H, A
	rrcf	totalp0p2H, F, A

 	;Lower byte-Average of photodiodes 0 and 2
	movf	Photodiode_0L,W, A
	addwf	Photodiode_2L,W, A
	movwf	totalp0p2L, A
	rrcf	totalp0p2L, F, A

 	;Upper byte-Average of photodiodes 1 and 3
	movf	Photodiode_1H,W, A
	addwf	Photodiode_3H,W, A
	movwf	totalp1p3H, A
	rrcf	totalp1p3H, F, A

 	;Lower byte-Average of photodiodes 1 and 3
	movf	Photodiode_1L,W, A
	addwf	Photodiode_3L,W, A
	movwf	totalp1p3L, A
	rrcf	totalp1p3L, F, A

 	;Upper byte-Average of photodiodes 2 and 3
	movf	Photodiode_2H,W, A
	addwf	Photodiode_3H,W, A
	movwf	totalp2p3H, A
	rrcf	totalp2p3H, F, A

 	;Lower byte-Average of photodiodes 2 and 3
	movf	Photodiode_2L,W, A
	addwf	Photodiode_3L,W, A
	movwf	totalp2p3L, A
	rrcf	totalp2p3L, F, A
	return

compare_p0p2_p1p3_h: ;Upper byte-Difference of top and bottom photodiode reading averages
	movlw	0x00
	movwf	status_p0p2_p1p3_h 		;Initialise sign bit
	movf	totalp1p3H, W
	subwf	totalp0p2H, W
	movwf	difference_p0p2_p1p3_h 		;Store difference
	btfsc	STATUS, 0 			;Check if difference is negative
	bra	compare_p0p2_p1p3_l 		;Go to next compare
	comf	difference_p0p2_p1p3_h 		;Two's compliment if difference negative
	incf	difference_p0p2_p1p3_h
	movlw	0x01
	movwf	status_p0p2_p1p3_h ;Set sign bit
	bcf	STATUS, 0			

compare_p0p2_p1p3_l: ;Lower byte-Difference of top and bottom photodiode reading averages
	movlw	0x00
	movwf	status_p0p2_p1p3_l 		;Initialise sign bit
	movf	totalp1p3L, W
	subwf	totalp0p2L, W
	movwf	difference_p0p2_p1p3_l		;Store difference
	btfsc	STATUS, 0			;Check if difference is negative
	return
	comf	difference_p0p2_p1p3_l		;Two's compliment if difference negative
	incf	difference_p0p2_p1p3_l
	movlw	0x01
	movwf	status_p0p2_p1p3_l
	return

compare_p0p1_p2p3_h: ;Upper byte-Difference of left and right photodiode reading averages
	movlw	0x00
	movwf	status_p0p1_p2p3_h ;Initialise sign bit
	movf	totalp2p3H, W
	subwf	totalp0p1H, W
	movwf	difference_p0p1_p2p3_h		;Store difference
	btfsc	STATUS, 0			;Check if difference is negative
	bra	compare_p0p1_p2p3_l		;Go to next compare
	comf	difference_p0p1_p2p3_h		;Two's compliment if difference negative
	incf	difference_p0p1_p2p3_h
	movlw	0x01
	movwf	status_p0p1_p2p3_h
	bcf	STATUS, 0

compare_p0p1_p2p3_l: ;Lower byte-Difference of left and right photodiode reading averages
	movlw	0x00
	movwf	status_p0p1_p2p3_l ;Initialise sign bit
	movf	totalp2p3L, W
	subwf	totalp0p1L, W
	movwf	difference_p0p1_p2p3_l		;Store difference
	btfsc	STATUS, 0			;Check if difference is negative
	return
	comf	difference_p0p1_p2p3_l		;Two's compliment if difference negative
	incf	difference_p0p1_p2p3_l
	movlw	0x01
	movwf	status_p0p1_p2p3_l
	return
	end

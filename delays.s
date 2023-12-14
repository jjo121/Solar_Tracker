#include <xc.inc>

global delayseveral5us, delay_ms
psect	udata_acs; named variables in access ram

delayseveral5count:     ds	1	
delay5count:	        ds	1
random:		            ds	1

ms_cnt_l:	            ds 1	
ms_cnt_h:	            ds 1	
ms_cnt:	                ds 1	
ms_tmp:	                ds 1	
ms_counter:	            ds 1

psect	lcd_code,class=CODE
delayseveral5us:                 ;delay for 5.5 microseconds a certain number of times (given in WR)
    movwf   delayseveral5count
    bra	    delay5us
leaveloop:
    dcfsnz  delayseveral5count
    return
    movlw   0x00
    movwf   random
    bra	    delay5us  
delay5us:
    movlw   0x1A;41 in decimal
    movwf   delay5count
delay5loop:
    decfsz  delay5count
    bra	    delay5loop
    bra	    leaveloop           ; Return from the subroutine

delay_ms:		                ; delay given in ms in W
	movwf	ms_cnt, A
lcdlp2:	
    movlw	250	                ; 1 ms delay
	call	delay_x4us	
	decfsz	ms_cnt, A
	bra	    lp2
	return
    
delay_x4us:		                ; delay given in chunks of 4 microsecond in W
	movwf	ms_cnt_l, A	        ; now need to multiply by 16
	swapf   ms_cnt_l, F, A	    ; swap nibbles
	movlw	0x0f	    
	andwf	ms_cnt_l, W, A     ; move low nibble to W
	movwf	ms_cnt_h, A	       
	movlw	0xf0	    
	andwf	ms_cnt_l, F, A    
	call	ms_delay
	return

ms_delay:			            ; delay routine	4 instruction loop == 250ns	    
	movlw 	0x00		        ; W=0
lp1:	
    decf 	ms_cnt_l, F, A	    ; no carry when 0x00 -> 0xff
	subwfb 	ms_cnt_h, F, A	    ; no carry when 0x00 -> 0xff
	bc 	    lp1		            ; carry, then loop again
	return			            ; carry reset so return

    end

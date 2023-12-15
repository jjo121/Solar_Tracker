#include <xc.inc>

extrn	delayseveral5us, delay_ms
extrn   pos_xz, pos_xy
    
global  motorsetup, move_xz, move_xy, move_xy_anticlockwise, move_xy_clockwise 
global move_xz_anticlockwise, move_xz_clockwise,move_xy
    
psect udata_acs ;reserves space in RAM

countxz:         ds 1
countxy:	       ds 1
tempStore:     ds 1
tempStore2:	ds 1
    
psect	adc_code, class=CODE

motorsetup:
    movlw	0x00
    movwf	TRISC			; portc is output
    movlw	0x01
    movwf	countxz
    movlw	0x01
    movwf	countxy
    return

    
move_xz:
    movlw	0xFF
    movwf	tempStore
    movf	pos_xz, W
    subwf	tempStore
    ;bsf		TRISC, 0
    bsf		LATC1
    movlw	0x01
    call	delay_ms
    movf	pos_xz, W
    call	delayseveral5us
    bcf		LATC1
    movlw	0x11     
    call	delay_ms
    movlw	0xA5
    call	delayseveral5us
    movf	tempStore, W
    call	delayseveral5us
    decfsz	countxz
    ;bra		move_xz
    movlw	0x01
    movwf	countxz
    ;bcf		TRISC, 0
    return

move_xy:
    movlw	0xFF
    movwf	tempStore2
    movf	pos_xy, W
    subwf	tempStore2
    bsf		TRISC, 0
    bsf		LATC2
    movlw	0x01
    call	delay_ms
    movf	pos_xy, W
    call	delayseveral5us
    bcf		LATC2
    movlw	0x11     
    call	delay_ms
    movlw	0xA5
    call	delayseveral5us
    movf	tempStore2, W
    call	delayseveral5us
    decfsz	countxy
    ;bra		move_xz
    movlw	0x01
    movwf	countxy
    ;bcf		TRISC, 0
    return    
    
move_xz_anticlockwise:
	movlw	0x01	;1
	cpfseq	pos_xz
	decf	pos_xz
	call	move_xz
	return

move_xz_clockwise:
	movlw	0xFF	;179
	cpfseq	pos_xz
	incf	pos_xz
	call	move_xz
	return   
	
move_xy_anticlockwise:
	movlw	0x01	;1
	cpfseq	pos_xy
	decf	pos_xy
	call	move_xy
	return

move_xy_clockwise:
	movlw	0xFF	;179
	cpfseq	pos_xy
	incf	pos_xy
	call	move_xy
	return     

    end
    

    

    
    

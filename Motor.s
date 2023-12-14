#include <xc.inc>

extrn	delayseveral5us, delay_ms
extrn   pos_xz
    
global  motorsetup, move_xz, move_xy_anticlockwise, move_xy_clockwise 
global count, tempStore, stop ;to remove when operation verified
global move_xz_anticlockwise, move_xz_clockwise
    
psect udata_acs ;reserves space in RAM

count:         ds 1
count2:	       ds 1
tempStore:     ds 1
    
psect	adc_code, class=CODE

motorsetup:
    movlw	0x00
    movwf	TRISC			; portc is output
    movlw	0x01
    movwf	count
    movlw	0x0A
    movwf	count2
    return

    
move_xz:
    movlw	0xFF
    movwf	tempStore
    movf	pos_xz, W
    subwf	tempStore
    bsf		TRISC, 0
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
    decfsz	count
    ;bra		move_xz
    movlw	0x01
    movwf	count
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
    bsf		TRISC, 0
    bsf		LATC2
    movlw	0x01
    call	delay_ms
    movlw	0x50
    call	delayseveral5us
    bcf		LATC2
    movlw	0xFF     
    call	delay_ms
    return


move_xy_clockwise:
    bsf		TRISC, 0
    bsf		LATC2
    movlw	0x01
    call	delay_ms
    movlw	0x6A
    call	delayseveral5us
    bcf		LATC2
    movlw	0xFF     
    call	delay_ms
    return

stop:
    bsf		TRISC, 0
    bsf		LATC2
    movlw	0x01
    call	delay_ms
    movlw	0x5A
    call	delayseveral5us
    bcf		LATC2
    movlw	0x0C     
    call	delay_ms    
    return
    end
    
    

    
    

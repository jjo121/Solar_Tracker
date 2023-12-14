#include <xc.inc>

extrn	delayseveral5us, delay_ms
extrn   posEW
    
global  motorsetup, move_xz, move_xy_anticlockwise, move_xy_clockwise, 
global count, tempStore, stop ;to remove when operation verified

psect udata_acs ;reserves space in RAM

count:         ds 1
tempStore:     ds 1
    
psect	adc_code, class=CODE

motorsetup:
    movlw	0x00
    movwf	TRISC			; portc is output
    movlw	0x01
    movwf	count
    return

    
move_xz:
    movlw	0xB4
    movwf	tempStore
    movf	posEW, W
    subwf	tempStore
    bsf		TRISC, 0
    bsf		LATC1
    movlw	0x01
    call	delay_ms
    movf	posEW, W
    call	delayseveral5us
    bcf		LATC1
    movlw	0x11     
    call	delay_ms
    movlw	0xA5
    call	delayseveral5us
    movf	tempStore, W
    call	delayseveral5us
    decfsz	count
    bra		move_xz
    movlw	0x0A
    movwf	count
    bcf		TRISC, 0
    return
    
move_xy_anticlockwise:
    bsf		TRISC, 0
    bsf		LATC2
    movlw	0x01
    call	delay_ms
    movlw	0x55
    call	delayseveral5us
    bcf		LATC2
    movlw	0x0C     
    call	delay_ms
    return

move_xy_clockwise:
    bsf		TRISC, 0
    bsf		LATC2
    movlw	0x01
    call	delay_ms
    movlw	0x5C
    call	delayseveral5us
    bcf		LATC2
    movlw	0xFF     
    call	delay_ms
    movlw	0xFF     
    call	delay_ms
    bcf		TRISC, 0
    

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
    
    

    
    

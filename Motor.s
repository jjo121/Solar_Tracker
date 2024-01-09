#include <xc.inc>

;Define procedures for movement and set up of the motor
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

motorsetup:				;Initialisation of variables and configuration of PORTC
    movlw	0x00
    movwf	TRISC			; portc is output
    movlw	0x01
    movwf	countxz
    movlw	0x01
    movwf	countxy
    return

    
move_xz:				;Move x-z motor
    movlw	0xFF			
    movwf	tempStore		;Store amount second 4us delay needs to run to ensure period of pulse is 20ms
    movf	pos_xz, W
    subwf	tempStore
    ;bsf		TRISC, 0
    bsf		LATC1			;Set bit in pin 
    movlw	0x01			
    call	delay_ms		;1ms delay
    movf	pos_xz, W		
    call	delayseveral5us		;Delay for several us as set by position variable
    bcf		LATC1			;Clear bit
    movlw	0x11     		
    call	delay_ms		;Run ms delay
    movlw	0xA5			
    call	delayseveral5us		;Run us delay
    movf	tempStore, W		
    call	delayseveral5us		;Run us delay for an amount of times as stored previously. Now total period of pulse is 20ms
    decfsz	countxz
    ;bra		move_xz
    movlw	0x01
    movwf	countxz
    ;bcf		TRISC, 0
    return

move_xy:				;Move x-y motor
    movlw	0xFF
    movwf	tempStore2		;Store amount second 4us delay needs to run to ensure period of pulse is 20ms
    movf	pos_xy, W
    subwf	tempStore2
    bsf		TRISC, 0
    bsf		LATC2			;Set bit in pin 
    movlw	0x01		
    call	delay_ms		;1ms delay
    movf	pos_xy, W
    call	delayseveral5us		;Delay for several us as set by position variable
    bcf		LATC2			;Clear bit
    movlw	0x11     
    call	delay_ms		;Run ms delay
    movlw	0xA5
    call	delayseveral5us		;Run us delay
    movf	tempStore2, W
    call	delayseveral5us		;Run us delay for an amount of times as stored previously. Now total period of pulse is 20ms
    decfsz	countxy
    ;bra		move_xz
    movlw	0x01
    movwf	countxy
    ;bcf		TRISC, 0
    return    
    
move_xz_anticlockwise: 			;Decrement position variable on x-z axis
	movlw	0x01	;1
	cpfseq	pos_xz
	decf	pos_xz
	call	move_xz
	return

move_xz_clockwise:			;Increment position variable on x-z axis
	movlw	0xFF	;179
	cpfseq	pos_xz
	incf	pos_xz
	call	move_xz
	return   
	
move_xy_anticlockwise:			;Decrement position variable on x-y axis
	movlw	0x01	;1
	cpfseq	pos_xy
	decf	pos_xy
	call	move_xy
	return

move_xy_clockwise:			;Increment position variable on x-y axis
	movlw	0xFF	;179
	cpfseq	pos_xy
	incf	pos_xy
	call	move_xy
	return     

    end
    

    

    
    

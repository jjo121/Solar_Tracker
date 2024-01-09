#include <xc.inc>

;Main program loop

global	pos_xz, pos_xy

extrn	 LCD_Write_Hex, LCD_Write_Message , LCD_Send_Char_D
    
; Photdiode variables 
extrn	Photodiode_0L, Photodiode_0H,Photodiode_1L,Photodiode_1H
extrn	Photodiode_2L, Photodiode_2H,Photodiode_3L,Photodiode_3H
extrn	measurephotodiode, measuresolar, SolarL, SolarH 

;delay subroutine
extrn	delay_ms 

;motor variables
extrn	motorsetup, move_xz, move_xy_anticlockwise, move_xy_clockwise,move_xy
extrn	average, move_xz_anticlockwise, move_xz_clockwise
    
;comparison variables
extrn	status_p0p2_p1p3_l, status_p0p2_p1p3_h, status_p0p1_p2p3_l, status_p0p1_p2p3_h
extrn	difference_p0p2_p1p3_l, difference_p0p2_p1p3_h, difference_p0p1_p2p3_l, difference_p0p1_p2p3_h
extrn	compare_p0p2_p1p3_h, compare_p0p2_p1p3_l, compare_p0p1_p2p3_h, compare_p0p1_p2p3_l


extrn	Convert_ADC_to_Decimal

psect	udata_acs   			; reserve data space in access ram

;Declare position variables for each axis
pos_xz:		    ds	1		
pos_xy:		    ds  1

    
psect	code, abs	
rst: 	org 0x0
 	goto	setup

setup:  call	motorsetup		; Initialise position variables
	movlw	0x30
	movwf	pos_xz
	movlw	0x30
	movwf	pos_xy
	goto	start

move_xz_h:	;Uses status of high bytes to check whether to move up or down
	movlw	0x00
	cpfseq	status_p0p1_p2p3_h	;Check if sign bit is 0
	call	move_xz_anticlockwise	;It is 0. Top photodiode readings greater. Move up.
	movlw	0x01
	cpfseq	status_p0p1_p2p3_h	;Check if sign bit is 1
	call	move_xz_clockwise	;It is 1. Bottom photodiode readings greater. Move down.
	bra	xz_rotation		;Check if we need to move more in x-z direction.
	;movlw	0x01;
	;cpfseq	pos_xz;
	;bra	
	;movlw	0xFF;
	;cpfseq	pos_xz;
	
move_xz_l:	;Uses status of low bytes to check whether to move up or down- Did not have time to implement
	movlw	0x00
	cpfseq	status_p0p1_p2p3_l	;Check if sign bit is 0
	call	move_xz_anticlockwise	;It is 0. Top photodiode readings greater. Move up.
	movlw	0x01
	cpfseq	status_p0p1_p2p3_l	;Check if sign bit is 1
	call	move_xz_clockwise	;It is 1. Bottom photodiode readings greater. Move down.
	bra	xz_rotation		;Check if we need to move more in x-z direction.
	

move_xy_h:	;Uses status of high bytes to check whether to move left or right
	movlw	0x00
	cpfseq	status_p0p2_p1p3_h	;Check if sign bit is 0
	call	move_xy_anticlockwise	;It is 0. Left photodiode readings greater. Move left.
	movlw	0x01
	cpfseq	status_p0p2_p1p3_h	;Check if sign bit is 1
	call	move_xy_clockwise	;It is 1. Right photodiode readings greater. Move Right.
	bra	xy_rotation		;Check if we need to move more in x-y direction.
	
move_xy_l:	;Uses status of low bytes to check whether to move left or right- Did not have time to implement
	movlw	0x00
	cpfseq	status_p0p2_p1p3_l	;Check if sign bit is 0
	call	move_xy_anticlockwise	;It is 0. Left photodiode readings greater. Move left.
	movlw	0x01
	cpfseq	status_p0p2_p1p3_l	;Check if sign bit is 1
	call	move_xy_clockwise	;It is 1. Right photodiode readings greater. Move Right.
	bra	xy_rotation		;Check if we need to move more in x-y direction.
	
start:  ;movlw	2x80 			;Lines used to set panel to stationary position when conducting investigations
	;movwf	pos_xz
	;movlw	0xB4
	;movwf	pos_xy
	;call	move_xz
	;call	move_xy
	;bra	start
	
xy_rotation:				;Check if movement is required along x-y axis
	call	measurephotodiode	;Get photodiode readings
	call	average			;Get avergaes of readings
	call	compare_p0p2_p1p3_h	;Get difference of left and right means
	movlw	0x01		
	cpfslt	difference_p0p2_p1p3_h	;Compare difference against tolerance
	bra	move_xy_h		;Branch to deduction of direction of movement to move
	
xz_rotation:				;Check if movement is required along x-z axis
	call	measurephotodiode	;Get photodiode readings
	call	average			;Get avergaes of readings
	call	compare_p0p1_p2p3_h	;Get difference of left and right means
	movlw	0x01
	cpfslt	difference_p0p1_p2p3_h	;Compare difference against tolerance
	bra	move_xz_h		;Branch to deduction of direction of movement to move
	
	
	bra	start

		
end	rst
	
	
end	rst

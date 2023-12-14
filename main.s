#include <xc.inc>

global	pos_xz, pos_xy

extrn	 LCD_Write_Hex, LCD_Write_Message , LCD_Send_Char_D
    
; Photdiode variables 
extrn	Photodiode_0L, Photodiode_0H,Photodiode_1L,Photodiode_1H
extrn	Photodiode_2L, Photodiode_2H,Photodiode_3L,Photodiode_3H
extrn	measurephotodiode, measuresolar, SolarL, SolarH 

;delay subroutine
extrn	delay_ms 

;motor variables
extrn	motorsetup, move_xz, move_xy_anticlockwise, move_xy_clockwise, stop

;comparison variables
extrn	status_p0p2_p1p3_l, status_p0p2_p1p3_h, status_p0p1_p2p3_l, status_p0p1_p2p3_h
extrn	difference_p0p2_p1p3_l, difference_p0p2_p1p3_h, difference_p0p1_p2p3_l, difference_p0p1_p2p3_h
extrn	compare_p0p2_p1p3_h, compare_p0p2_p1p3_l, compare_p0p1_p2p3_h, compare_p0p1_p2p3_l
extrn	average, move_xz_anticlockwise, move_xz_clockwise

extrn	Convert_ADC_to_Decimal

psect	udata_acs   			; reserve data space in access ram

pos_xz:		    ds	1
pos_xy:		    ds  1

    
psect	code, abs	
rst: 	org 0x0
 	goto	setup

setup:  call	motorsetup		; Add lines which move motor to 0 positions
	movlw	0x30
	movwf	pos_xz
	goto	start

move_xz_h:	;Uses status of high bytes to check whether to move East or West
	movlw	0x01
	cpfseq	status_p0p1_p2p3_h
	call	move_xz_anticlockwise
	movlw	0x00
	cpfseq	status_p0p1_p2p3_h
	call	move_xz_clockwise
	bra	start

move_xz_l:	;Uses status of high bytes to check whether to move East or West
	movlw	0x01
	cpfseq	status_p0p1_p2p3_l
	call	move_xz_anticlockwise
	movlw	0x00
	cpfseq	status_p0p1_p2p3_l
	call	move_xz_clockwise
	bra	start	
	

move_xy_h:	;Uses status of high bytes to check whether to move East or West
	movlw	0x01
	cpfseq	status_p0p2_p1p3_h
	call	move_xy_anticlockwise
	movlw	0x00
	cpfseq	status_p0p2_p1p3_h
	call	move_xy_clockwise
	bra	start	
	
move_xy_l:	;Uses status of high bytes to check whether to move East or West
	movlw	0x01
	cpfseq	status_p0p2_p1p3_l
	call	move_xy_anticlockwise
	movlw	0x00
	cpfseq	status_p0p2_p1p3_l
	call	move_xy_clockwise
	bra	start	
	
start:	
	;bra	start
	
	
	;call	stop
	;call	move_xy_anticlockwise
	;call	stop
;	bra	start
;	call	measurephotodiode
;	call	average
;	call	compare_p0p2_p1p3_h
;	movlw	0x01
;	cpfslt	difference_p0p2_p1p3_h
;	bra	move_xy_h
	call	measurephotodiode
	call	average
	call	compare_p0p1_p2p3_h
	movlw	0x01
	cpfslt	difference_p0p1_p2p3_h
	bra	move_xz_h
	;movlw	0x0A
	;cpfslt	difference_p0p1_p2p3_l
	;bra	move_xz_l
	movlw	0xFF
	call	delay_ms
	movlw	0xFF
	call	delay_ms
	;bra	start
	call	measuresolar
;measureloop:
	movlw	0x05
	call	LCD_Send_Char_D
	;goto	measureloop
	;call	LCD_Write_Message
	;call	Convert_ADC_to_Decimal
	
	
end	rst

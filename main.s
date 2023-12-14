#include <xc.inc>

extrn	UART_Setup, UART_Transmit_Message  ; external uart subroutines
extrn	LCD_Setup, LCD_Write_Message, LCD_Write_Hex ; external LCD subroutines
extrn	ADC_Setup, ADC_Read		   ; external ADC subroutines
extrn MotorSetup, MoveEast, MoveWest	
psect	udata_acs   ; reserve data space in access ram
;counter:    ds 1    ; reserve one byte for a counter variable
;delay_count:ds 1    ; reserve one byte for counter in the delay routine
posEW:		    ds	1
Photodiode_EastL:   ds	1	    ; Reserve space for any variables
Photodiode_EastH:   ds	1
Photodiode_WestL:   ds	1
Photodiode_WestH:   ds	1
tempCompare1:	    ds	1
tempCompare2:	    ds	1
status1:	    ds	1
status2:	    ds	1
    
psect	udata_bank4 ; reserve data anywhere in RAM (here at 0x400)
myArray:    ds 0x80 ; reserve 128 bytes for message data

psect	data    
	; ******* myTable, data in programme memory, and its length *****
myTable:
	db	'H','e','l','l','o',' ','W','o','r','l','d','!',0x0a
					; message, plus carriage return
	myTable_l   EQU	13	; length of data
	align	2
    
psect	code, abs	
rst: 	org 0x0
 	goto	setup

setup:  call	MotorSetup
	call    ADC_Setup
	call    ADC_Setup1
	goto	start

;measurephotodiode:	
;	call    ADC_Read
;	movf    ADRESH,W, A
;	movwf   Photodiode_EastH    ;high byte stored
;	movf    ADRESL,W, A
;	movwf   Photodiode_EastL    ;low byte stored
;	call    ADC_Read1
;	movf    ADRESH,W, A
;	movwf   Photodiode_WestH    ;high byte stored
;	movf    ADRESL,W, A
;	movwf   Photodiode_WestL    ;low byte stored
	
compare1:
	movlw	0x01		    ;temp
	movwf	Photodiode_EastH    ;temp
	movlw	0x02		    ;temp
	movwf	Photodiode_WestH    ;temp
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

moveMotorEW1:	;Uses status of high bits to check whether to move East or West
	movlw	0x01
	cpfseq	status1
	bra	moveMotorWest
	bra	moveMotorEast
moveMotorEW2:	;Uses status of high bits to check whether to move East or West
	movlw	0x01
	cpfseq	status2
	bra	moveMotorWest
	bra	moveMotorEast
moveMotorEast:
	movf	posEW
	call	MoveEast
	return

moveMotorWest:
	movf	posEW
	call	MoveEast
	return
    
		
start:	;bra	measurephotodiode
	bra	compare
	movlw	0x00
	cpfslt	tempCompare1
	bra	moveMotorEW
	movlw	0x01
	cpfslt	tempCompare2
	bra	moveMotorEW
	
	
	


    
    

;	; ******* Programme FLASH read Setup Code ***********************
;setup:	bcf	CFGS	; point to Flash program memory  
;	bsf	EEPGD 	; access Flash program memory
;	call	UART_Setup	; setup UART
;	call	LCD_Setup	; setup UART
;	call	ADC_Setup	; setup ADC
;	goto	start
;	
;	; ******* Main programme ****************************************
;start: 	lfsr	0, myArray	; Load FSR0 with address in RAM	
;	movlw	low highword(myTable)	; address of data in PM
;	movwf	TBLPTRU, A		; load upper bits to TBLPTRU
;	movlw	high(myTable)	; address of data in PM
;	movwf	TBLPTRH, A		; load high byte to TBLPTRH
;	movlw	low(myTable)	; address of data in PM
;	movwf	TBLPTRL, A		; load low byte to TBLPTRL
;	movlw	myTable_l	; bytes to read
;	movwf 	counter, A		; our counter register
;loop: 	tblrd*+			; one byte from PM to TABLAT, increment TBLPRT
;	movff	TABLAT, POSTINC0; move data from TABLAT to (FSR0), inc FSR0	
;	decfsz	counter, A		; count down to zero
;	bra	loop		; keep going until finished
;		
;	movlw	myTable_l	; output message to UART
;	lfsr	2, myArray
;	call	UART_Transmit_Message
;
;	movlw	myTable_l-1	; output message to LCD
;				; don't send the final carriage return to LCD
;	lfsr	2, myArray
;	call	LCD_Write_Message
;	
;measure_loop:
;	call	ADC_Read
;	movf	ADRESH, W, A
;	call	LCD_Write_Hex
;	movf	ADRESL, W, A
;	call	LCD_Write_Hex
;	goto	measure_loop		; goto current line in code
;	
;	; a delay subroutine if you need one, times around loop in delay_count
;delay:	decfsz	delay_count, A	; decrement until zero
;	bra	delay
;	return

	end	rst
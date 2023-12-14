#include <xc.inc>


global	Convert_ADC_to_Decimal
    
extrn	SolarL, SolarH    
extrn	LCD_Write_Hex
    
psect	udata_acs

voltage_hex:	ds 2
voltage_dec:	ds 5
voltage_temp:	ds 1
	
psect	adc_code, class=CODE

Convert_ADC_to_Decimal:
	movf	SolarL, W
	movwf	voltage_hex	; Store low byte of ADC result in result variable
	movf	SolarH, W
	movwf	voltage_hex+1	; Store high byte of ADC result in result variable

	; Convert the 16-bit value to decimal
	movlw	0		; Clear the decimal variable
	movwf	voltage_dec
	movlw	10000	; Set a divisor for the thousands place
	movwf	voltage_temp

Convert_Loop:
	movf	voltage_dec, W
	subwf	voltage_hex+1, F	; Subtract the MSB of the ADC result
	btfsc	STATUS, 0
	goto	Convert_Carry	; If there's a borrow, go to the Carry routine
	subwf	voltage_hex, F		; Subtract the LSB of the ADC result
	btfsc	STATUS, 0
	goto	Convert_Carry	; If there's a borrow, go to the Carry routine

	; If no borrow occurred, increment the decimal variable and continue
	incf	voltage_dec, F
	bra	Convert_Loop

Convert_Carry:
	movf	voltage_dec, W
	call	LCD_Write_Hex	; Display the decimal value on the LCD

	return	

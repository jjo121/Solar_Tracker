#include <xc.inc>

global  ADC_Setup0,ADC_Setup1,ADC_Setup2,ADC_Setup3,ADC_Setup4, ADC_Read    
    
psect	adc_code, class=CODE
;Set VDD to 4.096V (0x30) for testing purposes if VDD doesn't work 
;Add to ADC file
ADC_Setup0:
	bsf	TRISA, PORTA_RA0_POSN, A  ; pin RA0==AN0 input
	movlb	0x0f
	bsf	ANSEL0	    ; set AN0 to analog
	movlb	0x00
	movlw   00000001B   ; select AN0 for measurement
	movwf   ADCON0, A   ; and turn ADC on
	movlw   0x30	    ; Select VDD as reference
	movwf   ADCON1,	A   ; 0V for -ve reference and -ve input
	movlw   0xF6	    ; Right justified output
	movwf   ADCON2, A   ; Fosc/64 clock and acquisition times
	return

ADC_Setup1:
	bsf	TRISA, PORTA_RA1_POSN, A  ; pin RA0==AN0 input
	movlb	0x0f
	bsf	ANSEL1	    ; set AN0 to analog
	movlb	0x00
	movlw   00000101B   ; select AN1 for measurement
	movwf   ADCON0, A   ; and turn ADC on
	movlw   0x30	    ; Select VDD as reference
	movwf   ADCON1,	A   ; 0V for -ve reference and -ve input
	movlw   0xF6	    ; Right justified output
	movwf   ADCON2, A   ; Fosc/64 clock and acquisition times
	return	

ADC_Setup2:
	bsf	TRISA, PORTA_RA2_POSN, A  ; pin RA0==AN0 input
	movlb	0x0f
	bsf	ANSEL2	    ; set AN0 to analog
	movlb	0x00
	movlw   00001001B   ; select AN2 for measurement
	movwf   ADCON0, A   ; and turn ADC on
	movlw   0x30	    ; Select VDD as reference
	movwf   ADCON1,	A   ; 0V for -ve reference and -ve input
	movlw   0xF6	    ; Right justified output
	movwf   ADCON2, A   ; Fosc/64 clock and acquisition times
	return	

ADC_Setup3:
	bsf	TRISA, PORTA_RA3_POSN, A  ; pin RA0==AN0 input
	movlb	0x0f
	bsf	ANSEL3	    ; set AN0 to analog
	movlb	0x00
	movlw   00001101B   ; select AN3 for measurement
	movwf   ADCON0, A   ; and turn ADC on
	movlw   0x30	    ; Select VDD as reference
	movwf   ADCON1,	A   ; 0V for -ve reference and -ve input
	movlw   0xF6	    ; Right justified output
	movwf   ADCON2, A   ; Fosc/64 clock and acquisition times
	return
ADC_Setup4:
	bsf	TRISA, PORTA_RA4_POSN, A  ; pin RA0==AN0 input
	movlb	0x0f
	bsf	ANSEL4	    ; set AN0 to analog
	movlb	0x00
	movlw   00010101B   ; select AN3 for measurement
	movwf   ADCON0, A   ; and turn ADC on
	movlw   0x30	    ; Select VDD as reference
	movwf   ADCON1,	A   ; 0V for -ve reference and -ve input
	movlw   0xF6	    ; Right justified output
	movwf   ADCON2, A   ; Fosc/64 clock and acquisition times
	return
ADC_Read:
	bsf	GO	    ; Start conversion by setting GO bit in ADCON0
adc_loop:
	btfsc   GO	    ; check to see if finished
	bra	adc_loop
	return

	end

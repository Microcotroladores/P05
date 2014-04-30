#INCLUDE<P16F84A.INC>
        __CONFIG _XT_OSC & _CP_OFF & _PWRTE_ON & _WDT_OFF
        
        CBLOCK  0CH
        D1				;para conteo(CENTENA)
        D2				;para conteo(DECENA)
        D3				;para conteo(UNIDAD)
        CX				;para tiempo
        CY				;para tiempo
        CZ				;para tiempo
        ENDC
        
        ORG     00H
        GOTO    START
  
        ORG     04H
        GOTO    ISR
        
START:	BSF     STATUS,RP0
        MOVLW   00H
        MOVWF   TRISA
        MOVLW   01H
        MOVWF   TRISB
	BSF	INTCON,INTE
	BSF	INTCON,GIE
	BSF	OPTION_REG,INTEDG
        BCF     STATUS,RP0
	CLRF	PORTB
	CLRF	PORTA
	CLRF	D1
	CLRF	D2
	CLRF	D3
	CALL	MUX
	GOTO	$-1
						;TIEMPOS
TIME1:  MOVLW   D'49'
        MOVWF   CX
        MOVLW   D'33'
        MOVWF   CY
        NOP
        DECFSZ  CY,1
        GOTO    $-2
        DECFSZ  CX,1
        GOTO    $-6
        RETURN
        
TIME2:  MOVLW   06H
        MOVWF   CZ
        NOP
        DECFSZ  CZ,1
        GOTO    $-2
        RETURN

MUX:    CLRF    PORTB	;MUX
        CLRF    PORTA
        MOVF    D1,W
        CALL    TABLA
        MOVWF   PORTB
        BSF     PORTA,0
        CALL    TIME1
        CALL    TIME2
        
        BCF     PORTA,0
        MOVF    D2,W
        CALL    TABLA
        MOVWF   PORTB
        BSF     PORTA,1
        CALL    TIME1
        CALL    TIME2
        
        BCF     PORTA,1
        MOVF    D3,W
        CALL    TABLA
        MOVWF   PORTB
        BSF     PORTA,2
        CALL    TIME1
        CALL    TIME2
	BCF	PORTA,2
        RETURN

ISR:	BTFSS   INTCON,INTF	;INTERRUPCION
        RETFIE
		BCF		INTCON,INTF
        INCF    D3,1
        MOVF    D3,W
        SUBLW   09H
        BTFSC   STATUS,C
        RETFIE
        
        CLRF    D3
        INCF    D2,1
        MOVF    D2,W
        SUBLW   09H
        BTFSC   STATUS,C
        RETFIE
        
        CLRF    D2
        INCF    D1,1
        MOVF    D1,W
        SUBLW   09H
        BTFSC   STATUS,C
        RETFIE

        CLRF    D1
        RETFIE

TABLA:	ADDWF	PCL,1
	RETLW	7EH		;0
	RETLW	0CH		;1
	RETLW	0B6H	;2
	RETLW	9EH		;3
	RETLW	0CCH	;4
	RETLW	0DAH	;5
	RETLW	0FAH	;6
	RETLW	8EH		;7
	RETLW	0FEH	;8
	RETLW	0CEH	;9

	END

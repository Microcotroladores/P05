#INCLUDE<P16F84A.INC>
        __CONFIG _XT_OSC
        CBLOCK  0CH
        D1
        D2
        D3
        CX
        CY
        DZ
        ENDC
        ORG     00H
        GOTO    CONF
        GOTO    START
        ORG     04H
        GOTO    INTE
CONF:   BSF     STATUS,RP0
        MOVLW   0FH
        MOVWF   TRISA
        MOVLW   0FEH
        MOVWF   TRISB
        BCF     STATUS,RP0
        RETURN
START:
        END

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

;MULTIPLEXADO
MUX:    CLRF    PORTB
        CLRF    PORTA
        MOVF    D1,W
        CALL    DATO
        MOVWF   PORTB
        BSF     PORTA,0
        CALL    TIME1
        CALL    TIME2
        BCF     PORTA,1
        MOVF    D2,W
        CALL    DATO
        MOVWF   PORTB
        BSF     PORTA,1
        CALL    TIME1
        CALL    TIME2
        BCF     PORTA,1
        MOVF    D3,W
        CALL    DATO
        MOVWF   PORTB
        BSF     PORTA,2
        CALL    TIME1
        CALL    TIME2
        RETURN

;INTERRUPCIÓN
INTE:   BTFSS   INTCON,INTF
        RETFIE
        INCF    D3,1
        MOVF    D3,W
        SUBLW   09H
        BTFSC   STATUS,C
        GOTO    FIN
        CLRF    D3
        INCF    D2,1
        MOVF    D2,W
        SUBLW   09H
        BTFSC   STATUS,C
        GOTO    FIN
        CLRF    D2
        INCF    D1,1
        MOVF    D1,W
        SUBLW   09H
        BTFSC   STATUS,C
        GOTO    FIN
        CLRF    D1
FIN:    BCF INTCON,INTF
        RETFIE

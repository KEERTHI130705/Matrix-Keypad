;----------------------------------------------------------
; 4×4 MATRIX KEYPAD CALCULATOR USING 8051
; ROWS → P1.4–P1.7, COLUMNS → P1.0–P1.3
; OUTPUT DISPLAY → PORT 0
; num1 = latest digit, num2 = previous digit, result = sum
;----------------------------------------------------------

ORG 0000H

num1   EQU 30h        ; RAM location for latest digit
num2   EQU 31h        ; RAM location for previous digit
result EQU 32h        ; RAM location for result
key    EQU 33h        ; RAM to store ASCII key

MOV num1,#00h         ; clear memory locations
MOV num2,#00h
MOV result,#00h
MOV key,#00h

MOV P1,#0Fh           ; initialize keypad (rows high, columns high)

MAIN:
    ACALL wait_no_key ; ensure no key pressed
    ACALL wait_key    ; wait until key is pressed
    ACALL scan_key    ; find row and column
    ACALL process_key ; process the key
    SJMP MAIN         ; repeat forever

;---------------- WAIT FOR NO KEY -------------------------
wait_no_key:
    MOV A,P1
    ANL A,#0Fh
    CJNE A,#0Fh,wait_no_key ; wait until columns = 1111
    RET

;---------------- WAIT FOR KEY PRESS ----------------------
wait_key:
    MOV A,P1
    ANL A,#0Fh
    CJNE A,#0Fh,pressed
    SJMP wait_key
pressed:
    RET

;------------------ ROW SCANNING --------------------------
scan_key:
    MOV P1,#0EFh       ; row0 low
    MOV A,P1
    ANL A,#0Fh
    CJNE A,#0Fh,row0

    MOV P1,#0DFh       ; row1 low
    MOV A,P1
    ANL A,#0Fh
    CJNE A,#0Fh,row1

    MOV P1,#0BFh       ; row2 low
    MOV A,P1
    ANL A,#0Fh
    CJNE A,#0Fh,row2

    MOV P1,#07Fh       ; row3 low
    MOV A,P1
    ANL A,#0Fh
    CJNE A,#0Fh,row3

    SJMP scan_key      ; no row detected → rescan

row0: MOV DPTR,#key_r0
      SJMP find_col
row1: MOV DPTR,#key_r1
      SJMP find_col
row2: MOV DPTR,#key_r2
      SJMP find_col
row3: MOV DPTR,#key_r3

;------------------ COLUMN CHECK ---------------------------
find_col:
    MOV A,P1          ; read port again
    ANL A,#0Fh        ; mask columns

    JB ACC.0,chk1     ; check col0
    SJMP col0
chk1:
    JB ACC.1,chk2
    SJMP col1
chk2:
    JB ACC.2,chk3
    SJMP col2
chk3:
    JB ACC.3,no_key
    SJMP col3

no_key:
    SJMP MAIN

col0: SJMP got_key
col1: INC DPTR
      SJMP got_key
col2: INC DPTR
      INC DPTR
      SJMP got_key
col3: INC DPTR
      INC DPTR
      INC DPTR
      SJMP got_key

;---------------- FETCH ASCII KEY --------------------------
got_key:
    CLR A
    MOVC A,@A+DPTR    ; get ASCII from table
    MOV key,A         ; save in RAM
    MOV P0,A          ; display
    RET

;---------------- PROCESS KEY ------------------------------
process_key:
    MOV A,key         ; load ASCII

    ; check digits 0–9
    CJNE A,#'0',c1
    SJMP store_digit
c1: CJNE A,#'1',c2
    SJMP store_digit
c2: CJNE A,#'2',c3
    SJMP store_digit
c3: CJNE A,#'3',c4
    SJMP store_digit
c4: CJNE A,#'4',c5
    SJMP store_digit
c5: CJNE A,#'5',c6
    SJMP store_digit
c6: CJNE A,#'6',c7
    SJMP store_digit
c7: CJNE A,#'7',c8
    SJMP store_digit
c8: CJNE A,#'8',c9
    SJMP store_digit
c9: CJNE A,#'9',check_plus
    SJMP store_digit

;---------------- CHECK '+' OPERATION ----------------------
check_plus:
    CJNE A,#'+',done
    MOV A,num1
    ADD A,num2
    MOV result,A      ; store result
    MOV P0,A          ; display result
    RET

;---------------- STORE DIGIT ------------------------------
store_digit:
    CLR C
    MOV A,key
    SUBB A,#30h       ; ASCII to number
    MOV num2,num1
    MOV num1,A
    RET

done:
    RET

;---------------- LOOKUP TABLE -----------------------------
ORG 300h
key_r0: DB '0','1','2','3'
key_r1: DB '4','5','6','7'
key_r2: DB '8','9','A','B'
key_r3: DB 'C','D','E','+'

END

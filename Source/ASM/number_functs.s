; This file contains templates and actual functions to work on numbers in ARM assembly.
    AREA number_functs, CODE, READONLY

; ===== Count the number of bits set to 1 with Brian Kernighan =====
brianKernighan	FUNCTION
    ;r0: number 
    stmfd sp!, {r4-r5, lr}
    
    mov r4, #0	;counter
				
ciclo			;check if the number is not zero
    cmp r0, #0
    beq endAlgo

    ;do n = n AND (n-1)
    sub r5, r0, #1
    and r0, r0, r5
    ;increment counter
    add r4, r4, #1
    b ciclo	
	
endAlgo			
    mov r0, r4	
    ldmfd sp!, {r4-r5, pc}
    ENDFUNC
		
		
		
; ===== Is number Prime? =====
isPrime			FUNCTION
    stmfd sp!, {r4-r8, r10-r11, lr}
    
    ;r0: number to test wether it's prime or not
    
    cmp r0,#0
    beq not_primep
    cmp r0, #3
    ble primep
    
    mov r1, r0		;original number
    sub r2, r1, #1	;test number
    ;while test number > 1: perform original_number % test_number, it it's 0 -> prime
    ;if test_number reaches 1 -> not prime
    ;linear complexity
				
whilep			;check test_number > 1
    cmp r2, #1
    ble primep
    
    ;perform r1 % r2
    bl calc_mod
    ;result in r0
    ;if remainder == 0 -> not prime
    cmp r0, #0
    beq not_primep
    
    ;test_number --
    sub r2, r2, #1
    ;loop back
    b whilep

not_primep		
    mov r0, #0
    ldmfd sp!, {r4-r8, r10-r11, pc}
				
primep			
    mov r0, #1
    ldmfd sp!, {r4-r8, r10-r11, pc}
    ENDFUNC					
					
; ===== Modulo =====
calc_mod		FUNCTION
    STMFD sp!,{r4-r8,r10-r11,lr}
    ;calculate r1 % r2
    udiv r3, r1, r2 ;r3 = r1/r2
    mls r0, r3, r2, r1
    ;result in r0
    
    LDMFD sp!,{r4-r8,r10-r11,pc}

    ENDFUNC

; ===== 2's complement of a 32-bit number =====
do_2_complement	FUNCTION
    STMFD sp!,{r4-r8,r10-r11,lr}	
    ;number in r0
    mvn r0, r0
    add r0, r0, #1
    LDMFD sp!,{r4-r8,r10-r11,pc}	
    ENDFUNC
					
; ===== 2's complement of a 64-bit number in two registers =====
do_2_complement_64	FUNCTION
    STMFD sp!,{r4-r8,r10-r11,lr}
    ;r0 UPPER 32 BITS
    ;r1 LOWER 32 BITS

    ;two's complement of both upper and lower bits
    mvn r0, r0
    mvn r1, r1
    ;add 1 to the lower 32 bits
    ;if the lower 32 bits are all 1 -> overflow -> this means we're gonna add 1 to the ;upper 32 bits instead
    adds r1, r1, #1
    ;check if overflow of lower 32 bits
    bvc no_overflow	;no overflow
    ;overflow: propagate the sum of 1 to the upper 32 bits
    add r0, r0, #1
    
    ;RESULT IN R0 (UPPER BITS) AND R1 (LOWER BITS)
no_overflow		
    LDMFD sp!,{r4-r8,r10-r11,pc}
    ENDFUNC		

; ===== Count leading zeroes =====
count_leading_zero FUNCTION
	MOV   r12, sp
	; ro is value to count leading zero 	
	STMFD sp!,{r4-r8,r10-r11,lr}	
	
	CLZ R0,R0
		
	LDMFD sp!,{r4-r8,r10-r11,pc}	
	ENDFUNC
	
	EXPORT count_bit1

; ===== Count bits set to 1 =====
count_bit1 FUNCTION
	; in R0 dovr� esserci il numero in cui bisogna contare gli 1
	MOV   r12, sp
	STMFD sp!,{r4-r8,r10-r11,lr}		
			
	MOV R1, #32  ; numero di cifre del numero (BINARIO)
	MOV R2, #0   ; variabile che conterra il numero di 1
				
loopCountBit1	
	LSLS R0, R0, #1   
	ADDCS R2, R2, #1
				
	SUBS R1, R1, #1
	BNE loopCountBit1
				
	MOV R0, R2
	
	LDMFD sp!,{r4-r8,r10-r11,pc}	
	ENDFUNC

; ===== Module =====
module FUNCTION
	
	;RO = e1
	;R1 = e2
	
	; save current SP for a faster access 
	; to parameters in the stack
	MOV   r12, sp
	; save volatile registers
	STMFD sp!,{r4-r8,r10-r11,lr}				
	
	;STMFD sp!,{R0-R3}
	;MOV R1,R0 ; ho bisogno di VETT address in R1
	;MOV R0,R2 ; bsort ha bisogno di N in R0
	;BL bsort
	;LDMFD sp!,{R0-R3}
	;; extract argument 4 and 5 into R4 and R5
	;LDR   r4, [r12]
	;LDR   r5, [r12,#4]
	;LDR   r6, [r12,#8]
	; Calcolo del quoziente (divisione intera)
    UDIV r3, r0, r1   ; r3 = a / b (divisione intera)

    ; Calcolo di q * b
    MUL r3, r3, r1    ; r3 = (a / b) * b

    ; Calcolo del resto
    SUB r0, r0, r3    ;r0 = a - (q * b)

    ; Ora r0 contiene il risultato di a % b
	
	; setup a value for R0 to return
	; MOV   r1, r8
	; restore volatile registers
	LDMFD sp!,{r4-r8,r10-r11,pc}				
	ENDFUNC	
	
; ===== ABS =====
abs_value FUNCTION
	
	;RO = op1
	;R1 = op22
	
	; save current SP for a faster access 
	; to parameters in the stack
	MOV   r12, sp
	; save volatile registers
	STMFD sp!,{r4-r8,r10-r11,lr}				
	
	;STMFD sp!,{R0-R3}
	;MOV R1,R0 ; ho bisogno di VETT address in R1
	;MOV R0,R2 ; bsort ha bisogno di N in R0
	;BL bsort
	;LDMFD sp!,{R0-R3}
	;; extract argument 4 and 5 into R4 and R5
	;LDR   r4, [r12]
	;LDR   r5, [r12,#4]
	;LDR   r6, [r12,#8]
    
	CMP R0,R1
	;r0<=r1
	RSBLT R0,R0,R1 ;r1-r0
	;r0>r1
	SUBGE R0,R0,R1 ;r0-r1
	
	; setup a value for R0 to return
	; MOV   r1, r8
	; restore volatile registers
	LDMFD sp!,{r4-r8,r10-r11,pc}
	
	ENDFUNC
	
; ===== Is the number prime? =====
Prime_or_Not FUNCTION
	; save current SP for a faster access 
	; to parameters in the stack
	MOV   r12, sp
	; save volatile registers
	STMFD sp!,{r4-r8,r10-r11,lr}	
	MOV R0,#15               ;Number which you want to test
	CMP R0,#01               ;Comparing with 01
	BEQ PRIME                ;If equal declare directly as prime
	CMP R0,#02               ;Compare with 02
	BEQ PRIME                ;If equal declare directly as prime
	MOV R1,R0                ;Copy test number in R1
	MOV R2,#02               ;Initial divider
UP                     
	BL DIVISION              ;Call for division sub-function
	CMP R8,#00               ;Compare remainder with 0
	BEQ NOTPRIME             ;If equal then its not prime
	ADD R2,R2,#01            ;If not increment divider and check
	CMP R2,R1                ;Compare divider with test number
	BEQ PRIME                ;All possible numbers are done means It's prime
	B UP                     ;If not repeat until end
NOTPRIME 
	LDR R3,=0x11111111       ;Declaring test number is not prime
	; B STOP                   ;Jumping to infinite looping
	B exitPrime
PRIME 
	LDR R3,=0xFFFFFFFF       ;Declaring test number is prime number
	; STOP B STOP               ;Infinite looping
	B exitPrime
exitPrime	
	LDMFD sp!,{r4-r8,r10-r11,pc}
	ENDFUNC

; ===== Divide through subsequent subtracts =====
DIVISION FUNCTION 
	; save current SP for a faster access 
	; to parameters in the stack
	MOV   r12, sp
	; save volatile registers
	STMFD sp!,{r4-r8,r10-r11,lr}
	MOV R8,R0                ;Copy of data from main function
	MOV R9,R2                ;Copy of divider from main function
LOOP_DIVISION
	SUB R8,R8,R9             ;Successive subtraction for division
	ADD R10,R10,#01          ;Counter for holding the result of division
	CMP R8,R9                ;Compares for non-zero result
	BPL LOOP_DIVISION                 ;Repeats the loop if subtraction is still needed
	
	LDMFD sp!,{r4-r8,r10-r11,pc}
	ENDFUNC
	
next_state FUNCTION
	; save current SP for a faster access 
	; to parameters in the stack
	MOV   r12, sp
	; save volatile registers
	STMFD sp!,{r4-r8,r10-r11,lr}				
			
	; your code
    ; r0 = current_state 
	; r1 = taps
	; r2 = address of output_bit variable
				
	;compute the output bit
	AND R4,R0,#1 ;and between current state and 1 to compute outputbit
	STR R4,[R2] ;store the result of and into the address of output_bit
				
	; prevRes is initialted to 0
	MOV R5, #0
				
	MOV R6,R0 ; current state in r6
	MOV R7,R1 ; taps in r7
				
	MOV R8,#0 ;N 
	MOV R11,#1
	;The input bit is computed using the current value of the taps.

loopNextState
	CMP R8,#8
	BHS exitLoopNextState
	TST R7,R11 ;vedo se il bit i esimo in taps è un 0 o un 1
				;if z==0 i am in taps bit
	ANDNE R10,R6,#1 
	EORNE R5,R5,R10
	LSR R7,R7,#1 
	LSR R6,R6,#1
	ADD R8,R8,#1
	B loopNextState
		
				
exitLoopNextState
				
	;R5 IS INPUT
				
	LSR R0,R0,#1 ;The state is shifted right by one position
				
	LSL R5,R5,#7 
	EOR R0,R0,R5
				
				
				
	; restore volatile registers
	LDMFD sp!,{r4-r8,r10-r11,pc}
	ENDFUNC
	
; ===== Is value between min and max? =====
value_is_in_a_range FUNCTION
    ; R0 = VALUE
    ; R1 = MIN
    ; R2 = MAX
    ; R0 returns:
    ;   - 1 if MIN <= VALUE <= MAX
    ;   - 0 otherwise

    ; Save current SP for faster access to parameters in the stack
    MOV     r12, sp
    ; Save volatile registers
    STMFD   sp!, {r4-r8, r10-r11, lr}

    ; Compare VALUE with MIN
    CMP     R0, R1
    BLO     outOfRange      ; If VALUE < MIN, branch to outOfRange

    ; Compare VALUE with MAX
    CMP     R0, R2
    BHI     outOfRange      ; If VALUE > MAX, branch to outOfRange

    ; If VALUE is within the range
    MOV     R0, #1          ; Set R0 to 1 (true)
    B       exitFuncV         ; Branch to exit

outOfRange
    MOV     R0, #0          ; Set R0 to 0 (false)

exitFuncV
    ; Restore volatile registers
    LDMFD   sp!, {r4-r8, r10-r11, pc}

    ENDFUNC
	END	
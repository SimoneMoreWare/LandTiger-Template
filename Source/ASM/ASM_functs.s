	;PRESERVE8
    ;THUMB
					
	;AREA input_data, READONLY, ALIGN=4
    ;LTORG       ; Inserisce il literal pool qui
	;ALIGN 2
;DATA_IN  	DCB  0x0A,	0x01, 0x13, 0x02, 0x04, 0x06, 0x0F, 0x0A ; Dati definiti nel literal pool
	;ALIGN 2
;N 		 	DCD 8
	;ALIGN 2

	;AREA output_data, READWRITE, ALIGN=4
;BEST_3 		DCB 0x0, 0x0, 0x0
	;ALIGN 2
	
	;EXPORT DATA_IN
	;EXPORT N
	;EXPORT BEST_3	
	;NOTA BENE, LA AREA READONLY NON � ASSOLUTAMENTE MODIFICALE E RISCRIVIBILE
	AREA asm_functions, CODE, READONLY	
	
	EXPORT  asm_funct
asm_funct FUNCTION
	
	;RO = address of VETT
	;R1 = VAL
	;R2 = N
	
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
				
	; setup a value for R0 to return
	; MOV	  r0, r1
	; MOV   r1, r8
	; restore volatile registers
	LDMFD sp!,{r4-r8,r10-r11,pc}				
	ENDFUNC			
					
	EXPORT bsort				
bsort PROC
    ; Bubble sort an array of 32bit integers in place
	; R0 Numero di elementi nel vettore
	; R1 Vettore da ordinare
	MOV   r12, sp
	STMFD sp!,{r4-r8,r10-r11,lr}				
	
			
	; ALGORITMO 
	MOV R5, R0
	MOV	R11, #1
				
	SUBS R0, R0, #1
	BEQ exit
					
while	
	CMP		R11, #1
	BNE		exit
				
	MOV 	R5, R0
	MOV 	R6, #0
	MOV		R7, #1
	MOV		R11, #0

for				
	LDRB	R4, [R1, R6] 
	;LDR	R4, [R1, R6, LSL#2] ;se il vettore � in word
	LDRB	R8, [R1, R7]
	;LDR	R8, [R1, R7, LSL#2] ;se il vettore � in word
	CMP		R8, R4
	;CMP	R4, R8 ;ordine Cresente
	MOVGT	R11, #1
	STRBGT	R8, [R1, R6]
	;STRGT	R8, [R1, R6, LSL#2]
	STRBGT	R4, [R1, R7]
	;STRGT	R4, [R1, R7, LSL#2]
				
	ADD 	R6, R6, #1
	ADD		R7, R7, #1
				
	SUBS 	R5, R5, #1
	BNE 	for
	BEQ		while

exit
	; restore volatile registers
	LDMFD sp!,{r4-r8,r10-r11,pc}		
	ENDP
	


; Salvataggio del risultato:
;Dopo che __aeabi_fdiv ha eseguito la divisione, il risultato viene restituito in R0. Ora salviamo questo risultato (che � il valore di ritorno della nostra funzione) in R4:


;MOV R4, R0  ; Salva il risultato della divisione (in R0) in R4
; dei registri:
;Prima di restituire il controllo alla funzione chiamante, dobbiamo ripristinare i registri che avevamo salvato all'inizio della funzione. In questo caso, ripristiniamo prima R0-R3 (registri che potrebbero essere stati modificati durante la funzione) e poi R4-R7 (i registri che abbiamo utilizzato direttamente per la divisione):

;LDMFD sp!,{r4-r8,r10-r11,pc}  ; Ripristina i registri
;Restituzione del risultato:
;Ora dobbiamo restituire il valore di ritorno dalla funzione (R4, che contiene il risultato della divisione) nel registro R0, poich� questo � il registro in cui la funzione chiamante si aspetta di trovare il risultato. Successivamente, ripristiniamo il registro del link (LR), che contiene l'indirizzo di ritorno, e salviamo lo stato del programma:


;MOV R0, R4  ; Carica il valore di ritorno (risultato) in R0
;LDMFD sp!,{r4-r8,r10-r11,pc}  ; Ripristina i registri e torna alla funzione chiamante
;Come funziona il ritorno in R0
;La convenzione ARM vuole che il valore di ritorno di una funzione venga passato nel registro R0. Quando chiami la funzione my_division da C con:


;pi = my_division((float*)&area, &radiusPowerOf2);
;questa chiamata si traduce in un'istruzione che passa gli indirizzi di area e radiusPowerOf2 nei registri R0 e R1 rispettivamente.

;La funzione my_division esegue la divisione, e quando arriva alla fine, il risultato della divisione viene caricato nel registro R0, che � il registro di ritorno. Quindi, quando la funzione ritorna, il valore di R0 viene utilizzato dalla funzione chiamante (in questo caso il codice C che ha chiamato my_division).
	
	IMPORT __aeabi_fdiv   ;Importa la funzione di divisione in virgola mobile
	EXPORT my_division     ;Esporta la funzione
my_division     FUNCTION
	; Salva i registri che saranno usati
	MOV   r12, sp
	STMFD sp!,{r4-r8,r10-r11,lr}	

	; Carica i valori di area e radius^2
	LDR R4, [R0]           ; Carica il valore di 'area' (passato tramite R0) in R4
	LDR R5, [R1]           ; Carica il valore di 'radius^2' (passato tramite R1) in R5
	
	; Carica i valori nei registri R0 e R1 per la divisione
	MOV R0, R4             ; Carica 'area' in R0 (argomento per __aeabi_fdiv)
	MOV R1, R5             ; Carica 'radius^2' in R1 (argomento per __aeabi_fdiv)

	; Chiama la funzione __aeabi_fdiv per eseguire la divisione
	BL __aeabi_fdiv        ; __aeabi_fdiv(a, b) -> R0 = a / b ACCETTA SOLO FLOAT!!! AREA DEVE ESSERE DICHIARATO FLOAT!!!

	; Il risultato della divisione � ora in R0
	; (Potresti voler memorizzare questo risultato o restituirlo)
	;MOV  R4, R0 ; Salva il risultato della divisione (in R0) in R4 cosi da non avere problemi con lo stack  e le pop che non me lo farebbero salvare corretamente
	; Rimuove i registri dalla pila e ritorna
	;POP  {R0-R3}
	;MOV  R0, R4  ;Carica il valore di ritorno (risultato) in R0
	LDMFD sp!,{r4-r8,r10-r11,pc}				
	ENDFUNC
				
	EXPORT  call_svc
call_svc FUNCTION
; save current SP for a faster access 
	; to parameters in the stack
	;MOV   r12, sp
	; save volatile registers
	MOV   r12, sp
	STMFD sp!,{r4-r8,r10-r11,lr}		
	MOV R0,R13 ;PASS INTO THE SVC HANDLER ADDRESS OF PSP			
	; your code
	SVC 0x15
	B .
	LDMFD sp!,{r4-r8,r10-r11,pc}					
	; restore volatile registers
	;LDMFD sp!,{pc}
	ENDFUNC
		
	EXPORT count_leading_zero
count_leading_zero FUNCTION
	MOV   r12, sp
	; ro is value to count leading zero 	
	STMFD sp!,{r4-r8,r10-r11,lr}	
	
	CLZ R0,R0
		
	LDMFD sp!,{r4-r8,r10-r11,pc}	
	ENDFUNC
	
	EXPORT count_bit1
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
	
	EXPORT get_max
get_max FUNCTION
	;R0=Vett
	;R1=dim
	
	MOV   r12, sp
	STMFD sp!,{r4-r8,r10-r11,lr}	
	
	LDR R6, [R0], #4         ; Carica il primo elemento dell'array in R6 (massimo iniziale)
	SUBS R1, R1, #1          ; Decrementa la dimensione (R1 = dim - 1)
	BLE exitMax              ; Se R1 <= 0, salta direttamente all'uscita

loopMax
	LDR R4, [R0], #4         ; Carica l'elemento corrente in R4 e avanza il puntatore R0
	CMP R4, R6               ; Confronta l'elemento corrente (R4) con il massimo attuale (R6)
	MOVGT R6, R4             ; Se R4 > R6, aggiorna il massimo in R6
	SUBS R1, R1, #1          ; Decrementa il contatore R1
	BGT loopMax              ; Ripeti finch� R1 > 0

exitMax
	MOV R0, R6               ; Salva il massimo trovato in R0 (registro di ritorno)
	
	LDMFD sp!,{r4-r8,r10-r11,pc}	
	ENDFUNC

	EXPORT get_min
get_min FUNCTION
	;R0=Vett (puntatore all'array)
	;R1=dim  (dimensione dell'array)
	
	MOV   r12, sp
	STMFD sp!,{r4-r8,r10-r11,lr} ; Salva i registri callee-saved nello stack
	
	LDR R6, [R0], #4         ; Carica il primo elemento dell'array in R6 (minimo iniziale)
	SUBS R1, R1, #1          ; Decrementa la dimensione (R1 = dim - 1)
	BLE exitMin              ; Se R1 <= 0, salta direttamente all'uscita

loopMin
	LDR R4, [R0], #4         ; Carica l'elemento corrente in R4 e avanza il puntatore R0
	CMP R4, R6               ; Confronta l'elemento corrente (R4) con il minimo attuale (R6)
	MOVLT R6, R4             ; Se R4 < R6, aggiorna il minimo in R6
	SUBS R1, R1, #1          ; Decrementa il contatore R1
	BGT loopMin              ; Ripeti finch� R1 > 0

exitMin
	MOV R0, R6               ; Salva il minimo trovato in R0 (registro di ritorno)
	
	LDMFD sp!,{r4-r8,r10-r11,pc} ; Ripristina i registri e ritorna
	ENDFUNC

    EXPORT is_monotonic_increasing
is_monotonic_increasing FUNCTION
    ; R0 = Vett (puntatore all'array)
    ; R1 = dim (dimensione dell'array)

    MOV   r12, sp
	STMFD sp!,{r4-r8,r10-r11,lr} ; Salva i registri callee-saved nello stack

    CMP R1, #1                  ; Verifica se il vettore ha al massimo un elemento
    BLE exitTrue                ; Un vettore con 0 o 1 elemento � monotono crescente

    LDR R4, [R0], #4            ; Carica il primo elemento dell'array in R4
    SUBS R1, R1, #1             ; Decrementa la dimensione (R1 = dim - 1)

loopCheck
    LDR R5, [R0], #4            ; Carica l'elemento successivo in R5
    CMP R4, R5                  ; Confronta l'elemento precedente (R4) con l'elemento corrente (R5)
    MOVGT R0, #0                ; Se R4 > R5, il vettore non � monotono crescente
    BGT exitFalse               ; Esce con "false" (0) se non � monotono crescente
    MOV R4, R5                  ; Aggiorna R4 con l'elemento corrente
    SUBS R1, R1, #1             ; Decrementa il contatore R1
    BGT loopCheck               ; Continua finch� ci sono elementi da verificare

exitTrue
    MOV R0, #1                  ; Imposta il risultato a "true" (1)
    B endFunction_is_monotonic_increasing               ; Salta alla fine

exitFalse
    MOV R0, #0                  ; Imposta il risultato a "false" (0)

endFunction_is_monotonic_increasing
	LDMFD sp!,{r4-r8,r10-r11,pc} ; Ripristina i registri e ritorna
    ENDFUNC

	EXPORT  module
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
	
	EXPORT abs_value
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
	
	EXPORT Prime_or_Not
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

	EXPORT DIVISION                  ;Function for division operation
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
	
	EXPORT  next_state
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
	
	EXPORT value_is_in_a_range
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
	
	;TODO: array sum
	
	;TODO: array average
	
	END	
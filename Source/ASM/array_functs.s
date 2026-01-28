; When reading a value from the array it is really important to use the correct instruction
; based on the type of the values in the array.
; LDR - reads a word - 32 bit
; LDRH - reads a half word - 16 bit
; LDRB - reads a byte - 8 bit
;
; Examples: 
; LDR R4, [R1], #4 - WORD
; LDRH R4, [R1], #2 - HALF WORD
; LDRB R4, [R1], #1 - BYTE

; This file contains templates and actual functions to work on arrays in ARM assembly.
    AREA array_functs, CODE, READONLY

; ===== [TEMPLATE] Iterate on array =====
iterate_over_array PROC
	; Iterate over an array of 32bit integers
	; R0 Numero di elementi nel vettore
	; R1 Vettore da scorrere
	MOV   r12, sp
	STMFD sp!,{r4-r8,r10-r11,lr}

	; ALGORITMO 
	CMP R0, #0               ; Controlla se la dimensione è <= 0
	BLE exit_iterate_loop    ; Se R0 <= 0, salta direttamente all'uscita

iterate_loop
	LDR R4, [R1], #4         ; Carica l'elemento corrente in R4 e avanza il puntatore R1

	; YOUR CODE
	SUBS R0, R0, #1          ; Decrementa il contatore R0
	BGT iterate_loop         ; Ripeti finchè R0 > 0

exit_iterate_loop
	; RETURN SOMETHING!!!!
	
	LDMFD sp!,{r4-r8,r10-r11,pc} ; Ripristina i registri e ritorna
	ENDP

; ===== Bubble Sort =====
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

; ===== Insert into Sorted Array =====
insert PROC
    ; R0 = numero elementi (N)
    ; R1 = vettore ordinato (byte)
    ; R2 = nuovo valore da inserire (byte)

    STMFD   sp!, {r4-r7, lr}

    SUB     R4, R0, #1      ; i = N-1 (ultimo elemento valido)

loop
    LDRB    R5, [R1, R4]    ; A[i]
    CMP     R5, R2
	ADDGT 	R6, R4, #1
    STRBGT  R5, [R1, R6] ; shift A[i] -> A[i+1]
    SUBGT   R4, R4, #1      ; i--
    BGT     loop

	ADD 	R4, R4, #1
    STRB    R2, [R1, R4] ; inserisci nuovo valore

    LDMFD   sp!, {r4-r7, pc}
    ENDP

; ===== Get MAX and its index =====
get_max FUNCTION
	;R0=Vett
	;R1=dim
	
	MOV   r12, sp
	STMFD sp!,{r4-r8,r10-r11,lr}	
	
	LDR R6, [R0], #4         ; Carica il primo elemento dell'array in R6 (massimo iniziale)
	SUBS R1, R1, #1          ; Decrementa la dimensione (R1 = dim - 1)
	MOV R5, #0				 ; Carica l'indice del primo elemento dell'array
	MOV R7, #1				 ; Indice corrente
	BLE exitMax              ; Se R1 <= 0, salta direttamente all'uscita

loopMax
	LDR R4, [R0], #4         ; Carica l'elemento corrente in R4 e avanza il puntatore R0
	CMP R4, R6               ; Confronta l'elemento corrente (R4) con il massimo attuale (R6)
	MOVGT R6, R4             ; Se R4 > R6, aggiorna il massimo in R6
	MOVGT R5, R7			 ; Aggiorna il massimo indice in R5
	ADD R7, R7, #1			 ; Aggiorna l'indice corrente
	SUBS R1, R1, #1          ; Decrementa il contatore R1
	BGT loopMax              ; Ripeti finch� R1 > 0

exitMax
	MOV R0, R6               ; Salva il massimo trovato in R0 (registro di ritorno)
	MOV R1, R5				 ; Salva il massimo indice trovato
	
	LDMFD sp!,{r4-r8,r10-r11,pc}	
	ENDFUNC

; ===== Get second MAX and its index =====
; This is useful to find 2nd, 3rd etc in an array
get_second_max FUNCTION
	; R0 = array, R1 = N, R2 = upperLimit
	MOV   r12, sp
	STMFD sp!,{r4-r8,r10-r11,lr}
	
	MOV R6, #-1				 ; qualsiasi elemento sarà > -1
	MOV R7, #0 				 ; indice

loopSecondMax
	LDR R4, [R0], #4         ; Carica l'elemento corrente in R4 e avanza il puntatore R0
	CMP R4, R2				 ; Valore maggiore dell'upper limit. va scartato!
	BGE incr
	CMP R4, R6               ; Confronta l'elemento corrente (R4) con il massimo attuale (R6)
	MOVGT R6, R4             ; Se R4 > R6, aggiorna il massimo in R6
	MOVGT R5, R7			 ; aggiorna il max index
incr
	ADD R7, R7, #1			 ; Incrementa l'indice
	SUBS R1, R1, #1          ; Decrementa il contatore R1
	BGT loopSecondMax        ; Ripeti finch� R1 > 0

exitSecondMax
	MOV R0, R6               ; Salva il massimo trovato in R0 (registro di ritorno)
	MOV R1, R5				 ; Salva index del massimo
	
	LDMFD sp!,{r4-r8,r10-r11,pc}	
	ENDFUNC

; ===== Get MIN and its index =====
get_min FUNCTION
	;R0=Vett (puntatore all'array)
	;R1=dim  (dimensione dell'array)
	
	MOV   r12, sp
	STMFD sp!,{r4-r8,r10-r11,lr} ; Salva i registri callee-saved nello stack
	
	LDR R6, [R0], #4         ; Carica il primo elemento dell'array in R6 (minimo iniziale)
	MOV R5, #0				 ; Carica l'indice del primo elemento dell'array
	MOV R7, #1				 ; Indice corrente
	SUBS R1, R1, #1          ; Decrementa la dimensione (R1 = dim - 1)
	BLE exitMin              ; Se R1 <= 0, salta direttamente all'uscita

loopMin
	LDR R4, [R0], #4         ; Carica l'elemento corrente in R4 e avanza il puntatore R0
	CMP R4, R6               ; Confronta l'elemento corrente (R4) con il minimo attuale (R6)
	MOVLT R6, R4             ; Se R4 < R6, aggiorna il minimo in R6
	MOVLT R5, R7			 ; Aggiorna il minimo indice trovato
	ADD R7, R7, #1			 ; Aggiorna l'indice corrente
	SUBS R1, R1, #1          ; Decrementa il contatore R1
	BGT loopMin              ; Ripeti finch� R1 > 0

exitMin
	MOV R0, R6               ; Salva il minimo trovato in R0 (registro di ritorno)
	MOV R1, R5				 ; Salva il minimo indice trovato
	
	LDMFD sp!,{r4-r8,r10-r11,pc} ; Ripristina i registri e ritorna
	ENDFUNC

; ===== Is monothonic increasing? =====
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

; ===== Sum all values in the array =====
sum_array PROC
	; Sum all values of an array of 32bit integers
	; R0 Numero di elementi nel vettore
	; R1 Vettore da scorrere
	MOV   r12, sp
	STMFD sp!,{r4-r8,r10-r11,lr}

	; ALGORITMO
	MOV R5, #0			 ; Contiene la somma
	CMP R0, #0
	BLE exit_sum_loop    ; Se R0 <= 0, salta direttamente all'uscita

sum_loop
	LDR R4, [R1], #4         ; Carica l'elemento corrente in R4 e avanza il puntatore R1

	ADD R5, R5, R4		 ; Somma il valore corrente
	SUBS R0, R0, #1       ; Decrementa il contatore R0
	BGT sum_loop         ; Ripeti finchè R0 > 0

exit_sum_loop
	MOV R0, R5
	
	LDMFD sp!,{r4-r8,r10-r11,pc} ; Ripristina i registri e ritorna
	ENDP
	
avg_array PROC
	; AVG of values of an array of 32bit integers
	; R0 Numero di elementi nel vettore
	; R1 Vettore da scorrere
	MOV   r12, sp
	STMFD sp!,{r4-r8,r10-r11,lr}

	; ALGORITMO
	MOV R6, R0			 ; Mi salvo il numero di elementi
	MOV R5, #0			 ; Contiene la somma
	CMP R0, #0           ; Controlla se il numero di elementi è zero
	BLE exit_avg_loop    ; Se R0 <= 0, salta direttamente all'uscita

avg_loop
	LDR R4, [R1], #4         ; Carica l'elemento corrente in R4 e avanza il puntatore R1

	ADD R5, R5, R4		 ; Somma il valore corrente
	SUBS R0, R0, #1       ; Decrementa il contatore R0
	BGT avg_loop         ; Ripeti finchè R0 > 0

exit_avg_loop
	CMP R6, #0
	MOVLE R0, #0
	SDIVGT R0, R5, R6		; AVG = SUM / N
	
	LDMFD sp!,{r4-r8,r10-r11,pc} ; Ripristina i registri e ritorna
	ENDP
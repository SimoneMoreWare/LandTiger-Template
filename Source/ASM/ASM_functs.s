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

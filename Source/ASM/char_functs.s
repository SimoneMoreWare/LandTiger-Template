; This file contains templates and actual functions to work on chars in ARM assembly.
    AREA char_functs, CODE, READONLY

; ===== Is char a-z? =====
check_lowerCase		FUNCTION
				STMFD sp!,{r4-r8,r10-r11,lr}
				
				cmp r0, #'a'
				blt nope
				cmp r0, #'z'
				bgt nope
				
				mov r0, #1
				bx lr
	

nope			mov r0, #0
				LDMFD sp!,{r4-r8,r10-r11,pc}
				ENDFUNC

; ===== Is char A-Z? =====
check_upperCase		FUNCTION
				STMFD sp!,{r4-r8,r10-r11,lr}
				
				cmp r0, #'A'
				blt nope2
				cmp r0, #'Z'
				bgt nope2
				
				mov r0, #1
				bx lr
	

nope2			mov r0, #0
				LDMFD sp!,{r4-r8,r10-r11,pc}
				ENDFUNC

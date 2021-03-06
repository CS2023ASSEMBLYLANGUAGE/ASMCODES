%include "projectMacros.asm"
section .bss

        operator resb 1
        num1 resb 10
        num2 resb 10
        buffer resb 10
section .data
        notInt db 10,"Please check your inputs, only numbers are accepted",10,10
        notIntLen equ $ -notInt
        num1Msg db "Enter  number ", 10
        len1 equ $ -num1Msg
        num2Msg db   "  Enter next number ", 10
        len2  equ $ -num2Msg
        operatorMsg db 10, " Please Enter an operator from below: ",10, 10," '+' for addition    | '-' for subtraction     |",10," '%' for modolus     | '*' for multiplication  |", 10, " '/' for division    | 'x' for exponent        |",10, " 'a' for absolute    | 'q' To close the program|", 0xA,0xD
        operatorLen equ $ -operatorMsg
        resultMsg db "The result is "
        resultLen equ $ -resultMsg
        error db  " You Entered a wrong operator, Please Enter a correct operator!!!",10,10
        errorLen equ $ -error
	goodbye db "Thank You For Using Our Calculator", 10,"Have a nice day :)"
	gbLen equ $ -goodbye 
section .text
        global _start
_start:
        write operatorMsg,operatorLen ;request for operator
        read operator, 5 ; read operator

;Check for operator entered by user
;And perform the required operation
        compare "+"
        je _add
        compare "-"
        je _sub
        compare "/"
        je _div
        compare "*"
        je _mul
        compare "x"
        je _exp
        compare "a"
        je _absolute
        compare "%"
        je _div
	compare "q" ;Exit the program once the user enters q
	je _exit

        jmp _error	    ; Prompt the user to enter the right operation
			    ;When no match is found
_add:
			    ;Request for first number and store in num1
        write num1Msg, len1
        read num1, 100
        stringToInt num1
        write num2Msg, len2 ; Request for second number
        read num2, 100
        stringToInt num2    ;  Convert the string entered by user to integer
		       	    ; add the numbers
        mov eax, [num1]
        mov ebx, [num2]
        add eax, ebx

        jmp _displayResult ; diplay the result of the sum

_sub:
			   ;Request for first number and store in num1
        write num1Msg, len1
        read num1, 100
        stringToInt num1
        write num2Msg, len2 ;Request for second number
        read num2, 100
        stringToInt num2    ;  Convert the string entered by user to integer

        mov eax, [num1]
        mov ebx, [num2]
        sub eax,ebx
        jmp _displayResult
_div:
			    ;Request for first number and store in num1
        write num1Msg, len1
        read num1, 100
        stringToInt num1
        write num2Msg, len2 ; Request for second number
        read num2, 100
        stringToInt num2     ; Convert the string entered by user to integer

        mov edx, 0          ;empty content of edx so it doesn't intefere with the division
        mov eax, [num1]
        mov ecx, [num2]
        div ecx
        mov ecx, eax
        compare "%"	   ; If the operator entered is %, then our answer will
        je _mod	       	    ;be in edx
        mov eax,ecx
        jmp _displayResult
_mod:
			;Request for number to find modulus and store in num1


        mov eax, edx
        jmp _displayResult

_mul:
			;Request for first number and store in num1
        write num1Msg, len1
        read num1, 100
        stringToInt num1
        write num2Msg, len2;Request for second number
        read num2, 100
        stringToInt num2   ; Convert the string entered by user to integer

        mov eax, [num1]
        mov ebx, [num2]
        mul ebx
        jmp _displayResult

_exp:
			   ;Request for first number and store in num1
        write num1Msg, len1
        read num1, 100
        stringToInt num1
        write num2Msg, len2 ;Request for second number
        read num2, 100
        stringToInt num2    ; Convert the string entered by user to integer

        mov ebx, [num1]     ; the first number is the base
        mov ecx, [num2]     ; the second is the exponent
        dec ecx             ; decrease the exponent by 1 and multiply the number by itself
		            ; Repeat till the number reaches zero

.exponentialLoop:

        mov eax, [num1]
        mul ebx
        mov ebx, eax
        loop .exponentialLoop
        jmp _displayResult

_absolute:
;Request for first number and store in num1
        write num1Msg, len1
        read num1, 100
        stringToInt num1
        mov eax, [num1]
        jmp _displayResult
_error:
        write error,errorLen ; Print error Message
        jmp _start	     ; Restart the program

_exit:
	write goodbye,gbLen  ;Good Bye Message
	exit		     ; And Exit
_displayResult:
			     ; The results of all the operations above are stored in the eax register
	mov esi, eax		; move the result into esi for backup so we can output result message
	write resultMsg ,resultLen
	mov eax, esi 		;move the result back into eas
        intToString 		; convert the result to string so that it can be displayed
        write esi,10 		; display the result to the user

	jmp _start 		; Restart the calculator

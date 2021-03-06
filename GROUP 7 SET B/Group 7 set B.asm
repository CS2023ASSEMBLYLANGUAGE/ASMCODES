;GROUP 7 SET 2
;Assembly code to shutdown, hibernate or restart a pc
;this code was written in 32bits
;all comments have been placed at the end of each instruction to explain further

section .data
	msg db "Enter s for shutdown, r for restart and h for hibernate :" ;instruction to ask user input
	msglen equ $ -msg  ;to hold the length

	error db "Invalid Input", 0xA  ; error message
	lenerror equ $ -error		; length of error message

	filename db "/usr//sbin//shutdown", 0
	sdown db "-P",0		;option to shutdown
	hbernate db "-H",0	;option to hibernate
	rstart db "-r",0	;option to restart

	scommand dd filename, sdown, 0		;main shutdown command in an array
	rcommand dd filename, rstart, 0		;main restart command in an array
	hcommand dd filename, hbernate, 0	;main hibernate command in an array

	terminate dd 0 				;value to terminate

section .bss
	operator resb 1				;label to store input


section .text
	global _start
_start:					;start of a program
	call _prompt			;calling the prompt subroutine 
	call _userInput			;calling the userInput subroutine
	call _checks			;calling the checks subroutine


_prompt:				;prompt subroutine
	mov eax, 4
        mov ebx, 1
        mov ecx, msg
        mov edx, msglen
	int 80h
	ret				;return to the main program

_userInput:				;userInput subroutine
        mov eax, 3
        mov ebx, 2
        mov ecx, operator		;taken user input into operator
        mov edx, 1
        int 80h
        ret				;return to the main program


_checks:
	mov eax, "s" 			;checking for shutdown
	sub eax, '0' 			;converting from ascii to actual value
	mov ebx, [operator]
	sub ebx, '0'			;converting from ascii to actual value
	cmp eax, ebx 
	je _shutdown			;jump to shutdown if equal to

	mov eax, "h" 			;checking for hibernate
	sub eax, '0'
	cmp eax, ebx
	je _hibernate			;jump to hibernate if equal to

	mov eax, "r" 			;checking for restart
	sub eax, '0'
	cmp eax, ebx
	je _restart			;jump to the restart subroutine

	jne _errorMessage		;jump to the error message


_shutdown:				;shutdown subroutine
	mov eax, 11			;execve syscall for performing terminal commands
	mov ebx, filename		;path where shutdown command is located 
	mov ecx, scommand		;array to store the main shutdown command
	mov edx, terminate		;value to terminate the command
	int 80h

_hibernate:				;hibernate subroutine
	mov eax, 11
        mov ebx, filename
        mov ecx, hcommand		;array to store the main hibernate command
        mov edx, terminate
        int 80h

_restart:
	mov eax, 11
        mov ebx, filename
        mov ecx, rcommand		;array to store the main restart command
        mov edx, terminate
        int 80h

_errorMessage:				;error message subroutine
	mov eax, 4
	mov ebx, 1
	mov ecx, error
	mov edx, lenerror 
	int 80h

	mov eax, 1			;syscall to exit the program
	int 80h

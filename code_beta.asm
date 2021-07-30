section .bss
	input resb 1

section .data
	prompt0 db 'Options',10
	prompt0len equ $ - prompt0
	
	prompt1 db '1. Restart',10
	prompt1len equ $ - prompt1
	
	prompt2 db '2. Shutdown',10
	prompt2len equ $ - prompt2
	
	prompt3 db '3. Hibernate',10
	prompt3len equ $ - prompt3
	
	prompt4 db '4. Exit',10
	prompt4len equ $ - prompt4
	
	prompt5 db 'Please choose an option: ',0
	prompt5len equ $ - prompt5
	
	
	sysPath dd "/usr//sbin//shutdown",0
	
	shutdownOption dd "-P"
	restartOption dd "-r"
	hibernateOption dd "-H"
	timeArg dd "now"

	
	shutdownArray dd sysPath, shutdownOption, timeArg,0
	restartArray dd sysPath, restartOption, timeArg,0
	hibernateArray dd sysPath, hibernateOption, timeArg, 0
	
	



section .text
	global _start:
_start:
	call _promptUser
	call _getUserInput
	call _executeOption

	
	mov eax, 1
	mov ebx, 0
	int 80h
	
	
	
_promptUser:
	mov eax, 4
	mov ebx, 1
	mov ecx, prompt0
	mov edx, prompt0len
	int 80h
	
	mov eax, 4
	mov ebx, 1
	mov ecx, prompt1
	mov edx, prompt1len
	int 80h
	
	mov eax, 4
	mov ebx, 1
	mov ecx, prompt2
	mov edx, prompt2len
	int 80h
	
	mov eax, 4
	mov ebx, 1
	mov ecx, prompt3
	mov edx, prompt3len
	int 80h
	
	mov eax, 4
	mov ebx, 1
	mov ecx, prompt4
	mov edx, prompt4len
	int 80h
	ret



_getUserInput:
	mov eax, 4
	mov ebx, 1	
	mov ecx, prompt5
	mov edx, prompt5len
	int 80h
	
	mov eax, 3
	mov ebx, 0
	mov ecx, input
	mov edx, 2
	int 80h
	
	ret
	
	
	
_executeOption:
	mov al, [input]
	sub al, "0"
	
	cmp al, 1
	jle _restart
	
	cmp al, 2
	je _shutdown
	
	cmp al, 3
	je _hibernate
	
	cmp al, 4
	je _exit
	
	jmp _exit 

	 



_shutdown: 
	mov ebx, sysPath
	mov ecx, shutdownArray
	mov edx, 0
	mov eax, 11	
	int 80h
	
_restart:
	mov ebx, sysPath
	mov ecx, restartArray
	mov edx, 0
	mov eax, 11
	int 80h
	

_hibernate:
	mov ebx, sysPath
	mov ecx, hibernateArray
	mov edx, 0
	mov eax, 11
	int 80h
	
	
_exit:
	mov eax, 1
	mov ebx, 0
	int 60h

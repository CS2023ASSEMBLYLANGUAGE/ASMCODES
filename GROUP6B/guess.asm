section .data
        msg1 db "Please guess a number:",0xA
        lenmsg1 equ $ -msg1
        
        msg2 db "Try again",0xA
        lengmsg2 equ $ -msg2
    
  	success db "You got it!",0xA
        lensuccess equ $ -success
	
	exit db "Tries exceeded!",0xA
        lenexit equ $ -exit
 
  	count dw 0
 
section .bss
       input resb 1
       

section .text
        global _start

_start:
        mov eax,4		;sys_write
        mov ebx,1		;stdout
        mov ecx,msg1		;putting msg1 into ecx
        mov edx,lenmsg1		;the length of msg1
        int 0x80		;system interupt

        mov eax,3		;sys_read
        mov ebx,2		;std_in
        mov ecx,input		;putting "input" into ecx
        mov edx,2		;length of "input"
        int 0x80		;system interupt
       
        xor ecx,ecx		;clearing ecx, setting it to 0
        mov cl,[input]		;putting content of input into cl 
        cmp cl,54		; comparing content of cl with hexadecimal value of 6

        jne _retry		;conditional jump, 'if not equal'
        jmp _success		; conditional jump, 'if equal'


_success:
        mov eax, 4				
        mov ebx, 1		
        mov ecx, success
        mov edx, lensuccess
        int 0x80
 
        mov eax, 1		;sys_exit
        xor ebx, ebx		;clearing ebx
        int 0x80		;system interupt

_retry:
        mov eax, 4		
        mov ebx, 1		
        mov ecx, msg2
        mov edx, lengmsg2
        int 0x80

        mov eax, 3
        mov ebx, 2
        mov ecx, input
        mov edx, 1
        int 0x80
        

        INC byte [count]	;incrementation of  value in count
        mov dl, [count]		;moving the content 
        cmp dl, 3		;comparing 3 to value in dl
        jg _exit		;conditional jump, 'if greater'
   
        mov cl,[input]		;putting content of input into cl 
        cmp cl, 54		;comparing content of cl with hexadecimal value of 6
        jne _retry		;condtional jump,'if not equal'
   
        jmp _success		;unconditional jump

_exit:
      mov eax, 4		
      mov ebx, 1		
      mov ecx, exit			
      mov edx, lenexit
      int 0x80



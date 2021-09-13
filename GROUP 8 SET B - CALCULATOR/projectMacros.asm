
%macro compare 1
        mov al, %1		;move the inputs into al
        mov bl, [operator]	;move the user's input into bl

        cmp al,bl  		;compare if they are same
%endmacro

%macro write 2
        mov eax, 4		;stdout
        mov ebx, 1		;sys write
        mov ecx, %1		;string to print
        mov edx, %2		;length of string
        int 80h			;syscall
%endmacro


%macro read 2
        mov eax,3		;stdin
        mov ebx,2		;sys read
        mov ecx,%1		;variable to store input
        mov edx,%2		;length
        int 80h			;syscall
%endmacro

%macro exit 0
        mov eax, 1		;sys exit
        int 80h
%endmacro

 
%macro intToString 0
        lea esi,[buffer] ; place the address of buffer into esi, not the content
        add esi, 9
        mov byte[esi], 0

        mov ebx,10
.nextDigit:              ;Convert the numbers to ASCII one after the other
        mov edx, 0       ;By dividing by 10 and converting the remainder, which becomes the actual number to ASCII       
        div ebx
        add dl, 48
        dec esi
        mov [esi], dl
        test eax, eax
        jnz .nextDigit
                          ; esi is now a pointer to the converted string
     
%endmacro


%macro stringToInt 1

        lea esi, [%1]     ;Move the address of the String into esi
        dec eax           ; eax holds the length of the string after taking user input
        mov ecx, eax

        xor ebx, ebx
%%next:                     ;Convert the String to integers one after the other
        movzx eax,byte[esi] ;  set the upper bit of eax to zero, and move esi into the lower bit 
        inc esi
        sub al, 48

        cmp al, -3          ; -3 implies '-', i.e 45 in ASCI, 
        je %%skip
        jl %%notInt         ; All other characters below -  aren't numbers
        cmp al, 9
        jg %%notInt         ;   As well as characters above 9

        jmp %%continue
%%notInt:                       ;When a user enters a character which is not a numebr
        write notInt, notIntLen ;Display an error Message 
        jmp _start              ; And restart the programm

%%skip:

         mov al, 0
%%continue:
        imul ebx, 10
        add ebx,eax
        loop %%next
                                ;ebx now contains the string entered as an integer
        mov [%1],ebx            ;The number is moved into the input variable back

%endmacro

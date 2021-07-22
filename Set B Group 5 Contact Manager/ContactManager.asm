section .text

%macro input 2                ;macro to get input
    mov rax, 0                ;sys_read
    mov rdi, 0                ;standard input
    mov rsi, %1               ;first "variable" - where to store input
    mov rdx, %2               ;second "variable" - length of input
    syscall                   ;system call (call to kernel)
%endmacro                     ;end of input macro

%macro print 2                ;macro to print
    mov rax, 1                ;sys_write
    mov rdi, 1                ;standard output
    mov rsi, %1               ;first "variable" - what to print
    mov rdx, %2               ;second "variable" - length of output
    syscall                   ;system call (call to kernel)
%endmacro                     ;end of print macro

%macro compareans 2           ;macro to compare two numbers
    mov rbx, %1               ;Placeholder for response check
    sub rbx, 0x30             ;cnvert to number
    cmp rcx, rbx              ;compare with response
    je %2                     ;if equal, jump to second placeholder (label)
%endmacro                     ;end macro

    global _start

_start:
    call _askforfunction
    call _listfunctions
    call _getresponse
    call _checkresponse

    jmp _exit

_exit:
    mov rax, 60               ;sys_exit
    syscall                   ;kernel call

_askforfunction:
    print querymessage, lenquerymessage

    ret

_listfunctions:
    print firstoption, lenfirstoption

    print secondoption, lensecondoption

    print listcontacts, lenlistcontacts

    ret

_getresponse:
    input answer, 1

    ret

_checkresponse:
    mov rcx, [answer]
    sub rcx, 0x30

    compareans '1', _searchfile

    compareans '2', _getinfo

    compareans '3', _listcontacts

    jmp _invalidinput

    ret

_invalidinput:
    print invalidmessage, leninvalidmessage

    jmp _exit
    ;call _getresponse
    ;jmp _checkresponse

_listcontacts:
    call _openfileforreading
    call _readfile
    call _closefilereadonly

    mov rax, 1                ;sys_write
    mov rdi, 1                ;standard output
    mov rsi, dataloge         ;what to print
    mov rdx, 1000             ;amount of space to allocate
    syscall                   ;kernel call

    jmp _exit

_getinfo:
    print getinfoprompt, lengetinfoprompt
    print cases, lencases

    input name, 75
    input name, 75

    call _savetofile

    jmp _exit

_savetofile:
    call _openfileforwriting

    mov rax, name
    call _writetofile

    call _closefilewriteonly

    jmp _exit

_openfileforreading:
    mov rax, 2                ;sys_open
    mov rdi, filename         ;name of file
    mov rsi, 0x0              ;read only mode
    mov rdx, 0777o            ;full permissions to all users
    syscall                   ;kernel call

    mov [fd_in], rax          ;save file descriptor

    ret

_openfileforwriting:
    mov rax, 2                ;sys_open
    mov rdi, filename         ;name of file
    mov rsi, 0x441            ;create, append, write
    mov rdx, 0777o            ;full permissions to all users
    syscall                   ;kernel call

    mov [fd_out], rax         ;save file descriptor

    ret

_readfile:
    mov rax, 0                ;sys_read
    mov rdi, [fd_in]          ;file descriptor
    mov rsi, dataloge         ;save from file into dataloge
    mov rdx, 1000             ;amount of space to allocate
    syscall                   ;kernel call

    ret

_searchfile:
    call _openfileforreading
    call _readfile
    call _closefilereadonly

    print searchinfo, lensearchinfo
    print cases, lencases

    input name, 75
    input name, 75            ;this appears twice because the first one is not regstered when program is run... nees to be fixed
    ;mov rbx, name
    mov rbx, dataloge         ;move information from dataloge to rbx
    mov rdi, 0                ;set counter (rdi) to 0
    dec rbx                   ;decrease rbx to before first character

    jmp loop                  ;jump to loop label

loop:                         ;check each character in contact book (dataloge) to see if it matches with first character in name to be found
    inc rbx                   ;increase rbx to next character
    inc rdi                   ;increase counter by one
    mov rcx, name             ;set rcx to input (name) (first character in name)
    mov al, [rbx]             ;put current character of rbx in al
    mov ah, [rcx]             ;put current character of rcx into ah
    cmp al, ah                ;compare al and ah
    je loop2                  ;jump to loop2 if al and ah are equal

    cmp al, 0                 ;else compare al to 0 (end of string)
    je _notfound              ;jump to _notfound label if al and 0 are equal

    jmp loop                  ;else jump to loop

loop2:                        ;check each character in name to be found against entry in contact book (dataloge)
    inc rbx                   ;move to next character in rbx
    inc rcx                   ;move to next character in rcx
    inc rdi                   ;increase rdi by one
    mov al, [rbx]             ;put current rbx character into al
    mov ah, [rcx]             ;put current rcx character into ah
    cmp al, ah                ;compare al and ah
    jne loop3                 ;jump to loop3 label if not equal

    jmp loop2                 ;else jump to loop2

loop3:                        ;when all the characters in name to be found match with an entry in contact book,
                                  ;check if all characters in name to be found are finished
    inc rcx                   ;move to next character in rcx
    mov ah, [rcx]             ;put current character in rcx into ah
    cmp ah, 0                 ;compare ah to 0
    je _setprint              ;jump to _setprint if equal
    
    jmp loop                  ;else jump to loop

_setprint:                    ;go to starting point of where name to be found matches an entry in contact book (dataloge)
    dec rbx                   ;move rbx to previous character
    dec rcx                   ;move rcx to previous character
    dec rdi                   ;decrease counter by one
    mov al, [rbx]             ;put current character in rbx into al
    mov ah, [rcx]             ;put current character in rcx into ah
    cmp al, ah                ;compare al to ah
    je _setprint              ;if equal, jump to _setprint label

    mov rbx, dataloge         ;else put dataloge (entire contact book entry) into rbx 
    jmp _printcontact         ;jump to _printcontact label

_printcontact:                ;move to starting position of contact to be found in contact book (dataloge)
    inc rbx                   ;move to next character in rbx
    dec rdi                   ;decrease rdi by one
    cmp rdi, 0                ;compare rdi to 0
    jne _printcontact         ;if not equal, jump to _printcontact label

    loop4:                    ;else move to starting point of that specific contact entry
	dec rbx               ;move to previous character in rbx
	mov al, [rbx]         ;move current character in rbx into al
	cmp al, '-'           ;compare al to "-" (marker of individual contact entry beginning and end)
	jne loop4             ;if not equal, jump to loop4 label
	inc rbx               ;else increase rbx to next character (line break)
	inc rbx               ;increment rbx to next character (starting position of specific contact
    loop1:                    ;print out contact entry found character by character
	print rbx, 1          ;print current character rbx is pointing to
        inc rbx               ;increase rbx to next character
	mov al, [rbx]         ;put character in rbx into al
	cmp al, '-'           ;compare al with "\" (marker of individual contact entry beginning and end)
	je _exit              ;if equal, jump to _exit
	cmp al, 0             ;else compare al with 0 (end character) (end of string)
	je _exit              ;if equal, jump to _exit label

	jmp loop1             ;else jump to loop1 label

    jmp _exit

_notfound:
    print notfound, lennotfound

    jmp _exit

_closefilereadonly:
    mov rax, 3                ;sys_close
    mov rdi, [fd_in]          ;file descriptor
    syscall                   ;kernel call

    ret

_closefilewriteonly:
    mov rax, 3                ;sys_close
    mov rdi, [fd_out]         ;file descriptor
    syscall                   ;kernel call

    ret

_writetofile:
    push rax                  ;push entry to add to contact book to stack
    mov rbx, 0                ;set counter rbx equal to zero

    _printloop:               ;loop to count length of entry to add to contact book
	inc rax               ;move to next character in rax
	inc rbx               ;increase counter by 1
	mov cl, [rax]         ;put current character in rax into cl
	cmp cl, 0             ;compare cl to 0 (end character)
	jne _printloop        ;jump if not equal to _printloop label

	mov rax, 1            ;sys_write
	mov rdi, [fd_out]     ;file descriptor
	mov rdx, 2            ;length of text
	mov rsi, breaker      ;text to write ("-" and 10 to mark beginning and end of data entry into contact book)
	syscall               ;kernel call

	mov rax, 1            ;sys_write
	mov rdi, [fd_out]     ;file descriptor
	mov rdx, rbx          ;calculater length of data to be entered into contact book
	pop rsi               ;remove entry from stack and put into rsi to write to file
	syscall               ;kernel call

    ret

section .data
    querymessage db 'What functionality are you looking for?', 10
    lenquerymessage equ $-querymessage

    firstoption db 'Enter 1 to Search Contact Book.', 10
    lenfirstoption equ $-firstoption

    secondoption db 'Enter 2 to Insert Contact.', 10
    lensecondoption equ $-secondoption

    listcontacts db 'Enter 3 to List all contacts.', 10
    lenlistcontacts equ $-listcontacts

    getinfoprompt db 'Type name, a space, then the number.', 10
    lengetinfoprompt equ $-getinfoprompt

    invalidmessage db 'Your input is invalid', 10
    leninvalidmessage equ $-invalidmessage

    filename db 'contacts.txt', 0

    notfound db 'No such contact found in contact book.', 10
    lennotfound equ $-notfound

    searchinfo db 'Enter Name or Number', 10
    lensearchinfo equ $-searchinfo

    cases db 'Please make sure to capitalise each Name', 10
    lencases equ $-cases

    breaker db '-', 10

segment .bss
    answer resb 1
    name resb 75
    fd_in resb 1
    fd_out resb 1
    dataloge rest 1000
    

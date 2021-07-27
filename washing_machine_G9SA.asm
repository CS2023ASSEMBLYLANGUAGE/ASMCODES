%macro write_output 2 ;a macro with 2 parameters to print to the screen
    mov eax,4	;sys_write
	mov ebx,1	;standard output
	mov ecx, %1	;1st parameter position 
	mov edx, %2	;2nd parameter position
	int 0x80 	;syscall
%endmacro		;end of macro

%macro read_input 1	;a macro with 1 parameter to accept user input
	mov eax,3	;sys_read
	mov ebx,2	;standard input
	mov ecx, %1 	;parameter position
	mov edx,5	;reserved bytes for input
	int 0x80	;syscall
%endmacro		;end of macro

section .text
	global _start

_start:
	write_output startMsg, startMsgLen	;display start mess
	write_output yesMsg, yesMsgLen		;yes option
	write_output noMsg, noMsgLen		;no option

	read_input num		;accept user's choice

	mov dl, [num]		;mov choice to dl register
	cmp dl, [yes]		;compare with the yes option
	je phase1		;jump to phase1 label if choice is yes
	jne _exit		;exit code if choice is otherwise


phase1:
	write_output watertemp, watertempLen 	;display water temperature message
	write_output warm, warmLen		;warm water option
	write_output cold, coldLen		;cold water option

	read_input num			;accept user's choice
	
	mov dl, [num]			;move it into dl register
  
	write_output clothesTypemsg, clothesTypemsgLen	;display wash type message
    write_output lightOptmsg, heavyOptmsgLen		;light wash message
    write_output heavyOptmsg, heavyOptmsgLen		;heavy wash message

    read_input num			;accept user input

	mov dl, [num]			;move it into dl register
    cmp dl, [LightOpt]		;compare with the light wash option
    je phase2			;jump to phase2 label if user choice is light wash
    jne phase3			;else jump to phase3 label
	

phase2:	
	write_output lightmsg1, lightmsgLen1	;light wash message
	write_output lightmsg2, lightmsgLen2	;rinse time message
	write_output lightmsg3, lightmsgLen3 	;spin time message
	write_output lightmsg4, lightmsgLen4 	;water level message

	write_output ok, okLen		;ok message
	
	read_input num		;accept user input
	mov dl, [num]		;move input into dl register	
	cmp dl, [okOpt]		;compare with ok option
	je phase4		;jump to phase4 label if user types ok
	jne phase1		;else jump to phase1


phase3: 
	write_output heavymsg1, heavymsgLen1	;display light wash message
	write_output heavymsg2, heavymsgLen2	;wash time message
	write_output heavymsg3, heavymsgLen3	;rinse time message
	write_output heavymsg4, heavymsgLen4	;spin time message message
	write_output heavymsg5, heavymsgLen5	;water level message
	write_output ok, okLen 			;ok message
	
	read_input num		;accept user input

	mov dl, [num]		;move it into dl register
	cmp dl, [okOpt]		;compare with the ok wash option
	je phase5		;jump to phase5 label if user types ok
	jne phase1		;else jump to phase1 label
	

phase4:
	
	write_output rinseMsg, rinseMsgLen		;display rinse message
	mov dword[tv_sec], 5				;time in seocnds
	mov dword[tv_usec], 0				;time in nanooseconds
	mov eax, 162
	mov ebx, timeval
	mov ecx, 0
	int 80h



	write_output spinMsg, spinMsgLen		;display spin message
	mov dword[tv_sec], 5
	mov dword[tv_usec], 0
	mov eax, 162
	mov ebx, timeval
	mov ecx, 0
	int 80h

	jmp phase6


phase5: 
	write_output washMsg, washMsgLen		;display wash message
	mov dword[tv_sec], 10
	mov dword[tv_usec], 0
	mov eax, 162
	mov ebx, timeval
	mov ecx, 0
	int 80h

	
	write_output rinseMsg, rinseMsgLen
	mov dword[tv_sec], 5
	mov dword[tv_usec], 0
	mov eax, 162
	mov ebx, timeval
	mov ecx, 0
	int 80h


	write_output spinMsg, spinMsgLen
	mov dword[tv_sec], 5
	mov dword[tv_usec], 0
	mov eax, 162
	mov ebx, timeval
	mov ecx, 0
	int 80h

	jmp phase6


phase6: 
	write_output stopMsg, stopMsgLen		;display stop message
	write_output washAgainMsg, washAgainMsgLen
	write_output againMsg, againMsgLen		;yes option
	write_output notAgainMsg, notAgainMsgLen 	;no option
	
	read_input num		;accept user input
	mov dl, [num]		;move input into dl register
	cmp dl, [again]		;compare with again option
	je phase1		;jump to phase1 label if user input equals again option
    write_output shuttingDown, shutLen
	jne _exit		;otherwise exit code

_exit:   ;System Exit
	mov eax,1
	int 0x80

section .bss
	num resb 5
	time resb 2


section .data
	;start message
	startMsg: db "Do you want to start machine: ",0xA
	startMsgLen: equ $-startMsg

	;yes
	yesMsg: db "1. Yes",0xA
	yesMsgLen: equ $-yesMsg

	;no
	noMsg: db "2. No",0xA
	noMsgLen: equ $-noMsg

	watertemp db "Do you want warm or cold water wash",10
        watertempLen equ $-watertemp

	warm db "1. warm water",10
        warmLen equ $-warm

        cold db "2. cold water",10
        coldLen equ $-cold
        
        clothesTypemsg db "Choose the type of wash",10
        clothesTypemsgLen equ $-clothesTypemsg

        lightOptmsg db "1. light wash ",0xA
        lightOptmsgLen equ $-lightOptmsg

        heavyOptmsg db "2. heavy wash ",0xA
        heavyOptmsgLen equ $-heavyOptmsg

	mode db "Select the mode:",10
        modeLen equ $-mode

	manual db "1. Manual",10
        manualLen equ $-manual

	auto db "2. Auto",10
        autoLen equ $-auto


	lightmsg1 db "light wash will:",10
        lightmsgLen1 equ $-lightmsg1

        
	lightmsg2 db "	Rinse for 5 seconds",10
        lightmsgLen2 equ $-lightmsg2

	lightmsg3 db "	Spin for 5 seconds",10
        lightmsgLen3 equ $-lightmsg3

	lightmsg4 db "	Water level: 3-4l",10
        lightmsgLen4 equ $-lightmsg4



	heavymsg1 db "heavy wash will:",10
        heavymsgLen1 equ $-heavymsg1
        
        heavymsg2 db "	Wash for 10 seconds",10
        heavymsgLen2 equ $-heavymsg2
	
        heavymsg3 db "	Rinse in 5 seconds",10
        heavymsgLen3 equ $-heavymsg3

        heavymsg4 db "	Spin for 5 seconds",10
        heavymsgLen4 equ $-heavymsg4

	heavymsg5 db "	Water level: 5-6l",10
        heavymsgLen5 equ $-heavymsg5

	settime db "Set the wash time",10
        settimeLen equ $-settime

	waterlevel db "Set water level",10
	waterlevelLen equ $-waterlevel

    shuttingDown db "Shutting Down", 10
    shutLen equ $ - shuttingDown

	ok db "ok?",10
        okLen equ $-ok

	;Wash Message
    	washMsg: db "Wash in progress...", 0xA
    	washMsgLen: equ $ - washMsg

	;Rinse Message
    	rinseMsg: db "Rinse in progress...", 0xA
    	rinseMsgLen: equ $ - rinseMsg

    	;Spin Message
    	spinMsg: db "Spin in progress...", 0xA
    	spinMsgLen: equ $ - spinMsg

    	;stop Message
    	stopMsg: db "Done...", 0xA
    	stopMsgLen: equ $ - stopMsg

	;wash again message
	washAgainMsg: db "Do you want to perform another wash: ",0xA
	washAgainMsgLen: equ $-washAgainMsg

	;again
	againMsg: db "1. Yes",0xA
	againMsgLen: equ $-againMsg

	;not again
	notAgainMsg: db "2. No",0xA
	notAgainMsgLen: equ $-notAgainMsg


	;Option Values
	yes dd '1'
	no dd '2'
	okOpt db 'ok'
	again dd '1'
	notagain dd '2'
	Warmopt dd '1'
	Coldopt dd '2'
	LightOpt dd '1'	
	HeavyOpt dd '2'
	
	timeval:
	tv_sec dd 0		;define seconds time variable and initialize it to 0
	tv_usec dd 0		;define nanoseconds time variable and initialize it to 0



;Group Members
;Selby bright - 9413019
;Amegashie Selassie Louis  - 9395319
;Tabari Linus - 9413719
;Pratt Joseph Barton - 9411519
;Sarpong Jude Nyantakyi - 9412619
;Sarkodie-Addo Nana Amoatemaa - 9412419
;Shooter Paulo-9413319
;Bonsu Stephen Opoku - 9401919
;Oduro Stephen Kwame - 9409219
;Baba Abdul-Raziq - 9399919


    

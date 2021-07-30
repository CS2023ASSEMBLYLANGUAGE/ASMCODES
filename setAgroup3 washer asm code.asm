;Here we will use the macro directives to call the write
;and read user input functions

%macro write_string 2
	mov eax,4
	mov ebx,1
	mov ecx, %1
	mov edx, %2
	int 0x80
%endmacro

%macro read_input 1
	;Read Option Entered by user
	mov eax,3
	mov ebx,2
	mov ecx, %1
	mov edx,5
	int 0x80
%endmacro

segment .text
	global _start
_start:
	;"START MESSAGES"
	write_string newline, newlinelen  ;A dummy space created just for clarity
	write_string washername, washernamelen
	write_string space, spacelen
	write_string MenuMsg, MenuMsglen
	write_string newline, newlinelen
	write_string washOptMsg, washOptMsglen
	write_string offOptMsg, offOptMsglen

	read_input num   ;read input from user

	mov dl, [num]
	cmp dl,[washOpt] ;check if user chose mode of washing option
	JE washermode
	JNE  testother ;jump to  check if user input is to exit
testother:

	mov dl, [num]
	cmp dl,[offOpt]
	JE exitmessage  ;jump to exit if user chose exit option
	JNE invalidMsg1 ;Display invalid message to user

washermode:
	;"WASHER MODE PAGE"
	write_string automd, automdlen    ;Automatic mode
	write_string manualmd, manualmdlen ;Manual mode
	write_string BackMsg, BackMsglen   ;Back option

	read_input num ; read user input as option

	mov dl, [num]
	cmp dl, [autoOpt] ; check if user chose automatic option
	JE automatic
	JNE checkmanual ;jump to check for manual

checkmanual:
	mov dl, [num]
	cmp dl, [manualOpt] ;check if user chose manual option
	JE  manual
	JNE BackmodeOpt

BackmodeOpt:
	mov dl, [num]
	cmp dl, [backOpt] ;check if user chose back option
	JE _start
	JNE invalidMsg2  ;Display invalid message to user

automatic:
	;"AUTOMATIC PAGE"
	write_string reservMsg, reservMsglen
	write_string newline, newlinelen
	write_string RevInputMsg, RevInputMsglen
	write_string BackMsg, BackMsglen
	read_input num

	mov dl, [num]
	cmp dl,[revInputOpt1]
	JE autonext
	JNE checkrevAuto

checkrevAuto:
	mov dl, [num]
	cmp dl, [revInputOpt2]
	JE automatic
	JNE checkautoback
checkautoback:
	mov dl, [num]
	cmp dl, [backOpt]
	JE washermode
	JNE invalidauto

exitmessage:
	write_string offMsg, offMsglen
	write_string offDisplay, offDisplen

	mov dword[tv_sec], 8
	mov dword[tv_sec], 9
	mov eax, 162
	mov ebx, timeval
	mov ecx, 0
	int 80h

	JE exit

autonext:
	;"washing starts"
	write_string washMsg, washMsglen
	write_string newline, newlinelen
	write_string waitMsg, waitMsglen

	;time in nanoseconds

	mov dword[tv_sec], 8
	mov dword[tv_usec], 9
	mov eax, 162
	mov ebx, timeval
	mov ecx, 0
	int 80h

	write_string doneMsg, doneMsglen
        JE _start
manual:
	write_string reservMsg, reservMsglen
	write_string newline, newlinelen
	write_string RevInputMsg, RevInputMsglen
	write_string BackMsg, BackMsglen

	read_input num

	mov dl, [num]
	cmp dl, [revInputOpt1]
	JE manualnext1
	JNE manualinput2

manualinput2:

	mov dl, [num]
	cmp dl, [revInputOpt2]
	JE manual
	JNE ManBackOpt
ManBackOpt:
	mov dl, [num]
	cmp dl, [backOpt]
	JE washermode
	JNE ManInvalid

manualnext1:
	write_string waterlevelMsg, waterlevelMsglen
	read_input num
	write_string tempMsg, tempMsglen
	read_input num
	write_string timeMsg, timeMsglen
	read_input num
	write_string waitMsg, waitMsglen

	mov dword[tv_sec], 8
	mov dword[tv_sec], 9
	mov eax, 162
	mov ebx, timeval
	mov ecx, 0
	int 80h

	write_string doneMsg, doneMsglen
	JE _start

	;"INVALID MESSAGES"
invalidMsg1:
	write_string invalid, invalidlen
	jmp _start

invalidMsg2:
	write_string invalid, invalidlen
	jmp washermode

invalidauto:
	write_string invalid, invalidlen
	jmp automatic
ManInvalid:
	write_string invalid, invalidlen
	jmp manual
exit:
	;System Exit
	mov eax,1
	int 0x80

segment .bss
	num resb 5

segment .data
	newline: db 0xA
	newlinelen: equ $-newline

	invalid: db "INVALID INPUT!",0xA
	invalidlen: equ $-invalid

	washername: db "Welcome to HI-SENSE WASHING MACHINE",0xA
	washernamelen: equ $-washername

	space: db "******************************",0xA
	spacelen: equ $-space

	MenuMsg: db "Select a Mode of Operation",0xA
  	MenuMsglen: equ $-MenuMsg

	;reservoir Option
	reservMsg: db "Please Close Reservoir", 0xA
	reservMsglen: equ $ - reservMsg

	;Reservoir input
	RevInputMsg: db "Select 1 if closed  and 2 if Not",0xA
	RevInputMsglen: equ $-RevInputMsg

	;Wash Option
	washOptMsg: db "*Select 1 to enter Washer Mode ", 0xA
	washOptMsglen: equ $ - washOptMsg

	automd: db "*Enter 1 for Automatic mode", 0xA
	automdlen: equ $-automd

	manualmd: db "*Enter 2 for Manual mode", 0xA
	manualmdlen: equ $-manualmd

	;water level
	waterlevelMsg: db "*Enter water level", 0xA
	waterlevelMsglen: equ $ - waterlevelMsg

	;Temperature
	tempMsg: db "*Enter desired temperature",0xA
	tempMsglen: equ $-tempMsg

	;time
	timeMsg: db "*Enter desired Time to wash",0xA
	timeMsglen: equ $-timeMsg

	;Off Option
	offOptMsg: db "*Select 2 to turn Off", 0xA
	offOptMsglen: equ $ - offOptMsg

	;offMsg
	offDisplay: db "*THANKS FOR USING HI-SENSE",0xA
	offDisplen: equ $-offDisplay

	;Back Messge
	BackMsg: db "Press 3 to Go Back",0xA
	BackMsglen: equ $-BackMsg

	;Wash Message
	washMsg: db "*Washing in progress...",0xA
	washMsglen: equ $ - washMsg

	;Off Message
	offMsg: db "Off in progress...", 0xA
	offMsglen: equ $ - offMsg

	;wait Message
	waitMsg: db "Please wait***", 0xA
	waitMsglen: equ $ - waitMsg

	;done message
	doneMsg: db "*Machine done washing <o>",0xA
	doneMsglen: equ $- doneMsg

timeval:
	tv_sec dd 0
	tv_usec dd 0

	;Option Value
	washOpt dd '1'
	revInputOpt1 dd '1'
	revInputOpt2 dd '2'
	autoOpt dd '1'
	manualOpt dd '2'
	offOpt dd '2'
	backOpt dd '3'




title invertir_cadena

include Irvine32.inc

.data
buffer byte 20 DUP(0)
byteCount DWORD ?
nameSize  DWORD ?

Question  byte  "ingrese su nombre."  ,0
Greeting byte   "Hola: " ,0
Statement byte " "

.code
main	proc

		mov edx , OFFSET Question
		call WriteString
		call CRLF
		Call CRLF

		mov edx, OFFSET buffer
		mov Ecx, sizeof buffer
		call ReadString
		mov nameSize, eax

		push edx
		mov EDX ,offset greeting
		Call WriteString
		pop edx
		call WriteString
		Call CRLF
		Call CRLF

		mov  ecx,nameSize
		mov  esi,0

	L1: movzx eax,buffer[esi]    ; get character
		push eax                ; push on stack
		inc  esi
		loop L1

		; Pop the name from the stack in reverse
		; and store it in the aName array.

		mov  ecx,nameSize
		mov  esi,0

	L2: pop  eax                ; get character
		mov  buffer[esi],al      ; store in string
		inc  esi
		loop L2


		mov EDX, offset buffer
		call WriteString         ; Write the reversed string that is now in buffer
	
		exit
main	endp
		end		main
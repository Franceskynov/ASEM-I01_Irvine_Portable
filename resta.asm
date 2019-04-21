title resta

include Irvine32.Inc

.data
var1 dword 75
var2 dword 25
msga byte "Al restar: 75-25", 0
msgb byte "el resultado es: ", 0
y byte " y ", 0
 
.code
main	proc
		mov edx, offset msga
		call writestring
		
		call crlf
		
		mov edx, offset msgb
		call writestring
		mov eax,var1 ; EAX = 30000h
		sub eax,var2 ; EAX = 20000h
		call writedec
	
		exit
main	endp
		end main
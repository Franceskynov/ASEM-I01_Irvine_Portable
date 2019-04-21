title longitud de una cadena

include irvine32.inc

.data
bufer byte "abcde", 0
longbufer dword ?

.code
main	proc
		mov edx, offset bufer
		call strLength
		mov longbufer, eax
		call writedec
		exit
main	endp
		end main
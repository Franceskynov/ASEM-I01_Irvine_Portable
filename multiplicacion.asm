title multiplicacion

include irvine32.inc

.data

.code

main	proc
			mov eax, 5
			mov ebx, 2 
			mul ebx
			;mov eax, ebx
			call writedec
			exit
main	endp
		end main
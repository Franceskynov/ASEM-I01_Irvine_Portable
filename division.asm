title division

include irvine32.inc

.data
operation byte "Al dividir 500 entre 2", 0
result byte " El resultado es: ", 0

.code 

main	proc
			mov eax, 0
			mov ebx, 0
			
			mov edx, offset operation
			call writestring
			
			mov ax, 500
			mov bl, 2
			div bl
			
			mov edx, offset result
			call writestring
			
			call writedec
			exit
main	endp
		end main
title leer_cadena

include irvine32.inc

.data
bufer byte 21 DUP(0) ; búfer de entrada
cuentaBytes DWORD ? ; guarda el contador
numa byte "Posee: ", 0
numb byte " caracteres", 0
resultado byte "el resultado despues de ingresar datos es: ", 0

.code
main	proc
			mov edx, OFFSET bufer ; apunta al búfer
			mov ecx, SIZEOF bufer ; especifica el máximo de caracteres
			call ReadString ; recibe la cadena de entrada; bufer -> edx, n caracteres -> ecx, cadena de caracteres -> eax
			mov cuentaBytes,eax ; número de caracteres
			;call writedec; casado con eax
			
			mov edx, offset resultado
			call writestring
			;call crlf
			mov edx, offset bufer
			call writestring; casado con edx
			call crlf
			mov edx, offset numa
			call writestring
			call writedec
			mov edx, offset numb
			call writestring
			exit
main	endp
		end		main
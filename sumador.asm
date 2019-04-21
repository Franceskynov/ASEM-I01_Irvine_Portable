title suma

include irvine32.inc

.data
x1 byte 100
x2 byte 200
x3 byte 200

.code
main	proc
			mov eax, 0
			add al, x1 ;100 dec / 64 hex
			;add al, x2 ;
			mov ebx, 0;;
			mov bl, x2;;
			add ax, bx;;
			mov bl, x3;;
			
			add ax, bx
			;add al, x3 ;
			call writedec
			
			exit
main 	endp
		end main
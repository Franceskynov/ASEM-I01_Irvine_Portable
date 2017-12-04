;This is an example of assembler language
title helloWorld

include Irvine32.Inc

.data
msg byte "Hello world!!", 0

.code
main proc
	      mov edx, offset msg
	      call writestring
        
     exit
main endp
     end main
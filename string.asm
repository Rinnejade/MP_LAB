.model small
.stack
print macro msg
	mov ah, 09h
	mov dx, offset msg
	int 21h
endm
printm macro msg
	mov ah, 09h
	mov dx, offset msg+2
	int 21h
endm
read macro msg
	mov ah, 0Ah
	mov dx, offset msg
	int 21h
endm
.data
	read1 db 10,13,"Enter string 1 $"
	read2 db 10,13,"Enter string 2 $"
	yes db 10,13,"strings equal$"
	no db 10,13,"strings not equal$"
	str1 db 80, 100 dup('$')
	str2 db 80, 100 dup('$')
	newline db 10,13,"$"
.code
main proc
	mov ax,@data
	mov ds, ax
	mov es, ax

	print read1
	read str1

	print read2
	read str2

	;print newline
	;printm str1
	;printm str2

	lea si, str1+2
	lea di, str2+2

	mov cl, str1+1
	mov ch, 00
	repe cmpsb
	jnz notequal

	print yes
	jmp done
notequal:
	print no

done: 
	mov ax,4c00h
	int 21h
main endp
end main
.exit
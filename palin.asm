.model small
.stack 1000h

print macro msg
	lea dx, msg
	mov ah, 09h
	int 21h
endm

read macro msg
	lea dx, msg
	mov ah, 0Ah
	int 21h
endm

.data
	str db 80, 100 dup('$')
	revstr db 80, 100 dup('$')
	read1 db 10,13, "Enter String  $"
	read2 db 10,13, "Reverse String  $"
	yes db 10, 13, "Equal $"
	no db 10, 13, "not Equal $"
	newline db 10,13, "$"
.code

main proc
	mov ax, @data
	mov ds, ax
	mov es, ax

	print read1
	read str
	
	print newline
	print read2
	lea si, str+2	
	lea di, revstr
	mov cl, str+1
	dec cl
	mov ch, 00
	add si, cx
	dec si
	print newline
repeat:
	mov dl, [si]
	mov [di], dl
	dec si
	inc di
	loop repeat

	mov al,'$'
	mov [di], al

	print revstr

	lea si, str+2
	lea di, revstr
	mov cl, str+1
	mov ch, 00
	repe cmpsb
	jnz notEqual
	print yes
	jmp done
notEqual:
	print no
done:
	mov ax, 4c00h
	int 21h

main endp
end main
.exit
.model small
.stack 100h
print macro msg
	mov dx, offset msg
	mov ah, 09h
	int 21h
endm

printnum macro
	mov dl, al
	mov ah, 02h
	int 21h
endm

read macro msg
	mov dx, offset msg
	mov ah, 0Ah
	int 21h
endm

.data
	read1 db 10, 13, "enter string to find number of e's $"
	countmsg db 10, 13, "count of e's $"
	tofind db 'l'
	string db 80, 100 dup('$')
	newline db 10, 13, '$'
	count db ?
.code
main proc
	mov ax, @data
	mov ds, ax

	print read1
	read string

	mov cl, string+1
	mov ch, 00
	mov bl,0
	lea si, string+2
repeat:
	mov al, [si]
	cmp al, tofind
	jne ahead
	inc bl
ahead:
	inc si
	loop repeat
	mov count, bl

	print newline
	print countmsg
	mov dl, count
	add dl, 30h
	mov ah, 02h
	int 21h

	mov ax, 4c00h
	int 21h
main endp
end main
.exit
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
	substr db 80, 100 dup('$')
	read1 db 10,13, "Enter String  $"
	read2 db 10,13, "Enter Substring  $"
	yes db 10, 13, "substring $"
	no db 10, 13, "not substring $"
	newline db 10,13, "$"
.code

main proc
	mov ax, @data
	mov ds, ax
	mov es, ax

	print read1
	read str
	
	print read2
	read substr

	;print newline
	;print substr
	;print str

	mov cl, str+1
	cmp cl, substr+1
	jl notSub
	mov bx, 0
incbx:
	lea si, str[bx]+2
	mov cl, str+1
	sub cl, bl
	cmp cl, substr+1
	jl notSub
	lea di, substr+2
	mov cl, substr+1
	mov ch, 00
	rep cmpsb
	jnz down
	print yes
	jmp done
down:
	inc bx
	jmp incbx

notSub:
	print no
done:
	mov ax, 4c00h
	int 21h

main endp
end main
.exit
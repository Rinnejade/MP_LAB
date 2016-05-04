.model small
.stack 100h
print macro msg
	push ax
	push dx
	mov ah, 09h
	lea dx, msg
	int 21h
	pop dx
	pop ax
endm
.data
	matrix1 db 01,02,03,04,05,06,07,08,09
	matrix2 db 02,06,04,0,04,04,01,02,08
	msg1 db 10,13, "Matrix is $"
	msg2 db 10,13, "Transpose is $"
	msg3 db 10,13, "Added matrix is $"
	primemsg db 10,13, "Prime is $"
	newline db 10, 13, "$"
	space db "	$"
	row equ 3
	col equ 3
	num db ?
	start dw ?
.code
main proc
	mov ax, @data
	mov ds, ax

	print msg1
	mov si, offset matrix1
	call printMatrix

	print msg1
	mov si, offset matrix2
	call printMatrix
	
	print msg2
	call printTranspose

	print msg3
	call addMatrix

	print primemsg
	call findPrime


	mov ax, 4c00h
	int 21h
main endp

print8 proc
	push ax
	push bx
	push cx
	push dx

	mov bl, al
	mov cl, 04
	mov ch, 02
repeat1:
	rol bl, cl
	mov al, bl
	and al, 0fh
	cmp al, 0ah
	jc ahead1
	add al, 07h
ahead1:
	add al, 30h
	mov dl, al
	mov ah, 02h
	int 21h
	dec ch
	jnz repeat1

	pop dx
	pop cx
	pop bx
	pop ax
	
	ret
print8 endp

printMatrix proc
	push ax
	push bx
	push cx
	push dx

	mov cl, 0
i1:
	print newline
	mov ch, 0
j1:
	mov al, col
	mul cl
	add al, ch
	mov bx, ax
	mov al, [si+bx]
	call print8
	print space
	inc ch
	cmp ch, col
	jnz j1
	inc cl
	cmp cl, row
	jnz i1

	pop dx
	pop cx
	pop bx
	pop ax
	
	ret
printMatrix endp

printTranspose proc
	push ax
	push bx
	push cx
	push dx

	mov si,offset matrix1
	mov cl, 0
i2:
	print newline
	mov ch, 0
j2:
	mov al, col
	mul ch
	add al, cl
	mov bx, ax
	mov al, [si+bx]
	call print8
	print space
	inc ch
	cmp ch, row
	jnz j2
	inc cl
	cmp cl, col
	jnz i2

	pop dx
	pop cx
	pop bx
	pop ax
	
	ret
printTranspose endp

addMatrix proc
	push ax
	push bx
	push cx
	push dx

	mov si, offset matrix1
	mov di, offset matrix2
	mov bx, 1000
	mov cl, 0
i3:
	print newline
	mov ch, 0
j3:
	mov al, [si]
	add al, [di]
	call print8
	mov [si+bx], al 
	print space
	inc di
	inc si
	inc ch
	cmp ch, col
	jnz j3
	inc cl
	cmp cl, row
	jnz i3


	lea si, matrix1
	add si, bx
	mov start, si

	pop dx
	pop cx
	pop bx
	pop ax
	
	ret
addMatrix endp

checkPrime proc
	push ax
	push bx
	push cx
	push dx

	mov num, al
	mov cl, 02h
repeat4:
	cmp num, cl
	jz prime
	xor ax,ax
	mov al, num
	div cl
	cmp ah, 0
	jz notprime
	inc cl	
	jmp repeat4

prime:
	mov al, num
	call print8
	print space
notprime:
	pop dx
	pop cx
	pop bx
	pop ax
	
	ret
checkPrime endp

findPrime proc
	push ax
	push bx
	push cx
	push dx

	mov ch, 00
	mov al, row
	mov bl, col
	mul bl
	mov cl, al
	mov si, start
again4:
	mov al, [si]
	call checkPrime
	inc si
	loop again4

	print msg1
	mov si, start
	mov cl, 0
i4:
	print newline
	mov ch, 0
j4:
	mov al, col
	mul cl
	add al, ch
	mov bx, ax
	mov al, [si+bx]
	call hextodec
	print space
	call squareroot
	print space
	inc ch
	cmp ch, col
	jnz j4
	inc cl
	cmp cl, row
	jnz i4
	
	pop dx
	pop cx
	pop bx
	pop ax
	
	ret
findPrime endp

hextodec proc
	push ax
	push bx
	push cx
	push dx

	mov ah, 00
	mov bx, 0010
	mov cx, 0

again9:
	mov dx, 0	
	div bx
	add dl, 30h
	push dx
	inc cx
	cmp al, 09h
	jg again9

	add al, 30h
	mov dl, al
	mov ah, 02h
	int 21h

again8:
	pop dx
	int 21h
	loop again8

	pop dx
	pop cx
	pop bx
	pop ax
	
	ret
hextodec endp

squareroot proc
	push ax
	push bx
	push cx
	push dx

	mov cx, 0001
	mov bx, 0000
again10:
	sub al, cl
	jl done
	inc bl
	add cl, 02h
	jmp again10
done:
	mov al, bl
	call print8 
	
	pop dx
	pop cx
	pop bx
	pop ax
	
	ret
squareroot endp

end main
.exit
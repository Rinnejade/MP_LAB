.model small
.stack
disp_msg macro msg
	push ax
	push dx
	mov ah, 09h
	mov dx, offset msg
	int 21h
	pop dx
	pop ax
endm
.data
matrix db 11h,22h,33h,44h,55h,66h
msg1 db 10,13,"matrix Original$"
msg2 db 10,13,"matrix transpose$"
row equ 2
col equ 3
tab db "	$"
newline db 10,13,"$"
val db ?
.code

main proc

	mov ax, @data
	mov ds, ax

	disp_msg msg1
	call printMatrix
	
	disp_msg msg2
	call printTranspose

	mov ax, 4c00h
	int 21h

printMatrix proc
	push ax
	push bx
	push cx
	push dx
	
	mov si, offset matrix

	mov cl, 0		;i
i:
	disp_msg newline
	mov ch, 0		;j
j:	
	mov al, col
	mul cl
	add al, ch
	mov bx, ax
	mov al, [si+bx]
	mov val, al
	call disp
	inc ch
	cmp ch, col
	jnz j
	inc cl
	cmp cl, row
	jnz i

	pop dx
	pop cx
	pop bx
	pop ax

	ret
endp printMatrix


printTranspose proc
	push ax
	push bx
	push cx
	push dx
	
	mov si, offset matrix

	mov cl, 0		;i
i1:
	disp_msg newline
	mov ch, 0		;j
j1:	
	mov al, col
	mul ch
	add al, cl
	mov bx, ax
	mov al, [si+bx]
	mov val, al
	call disp
	inc ch
	cmp ch, row
	jnz j1
	inc cl
	cmp cl, col
	jnz i1

	pop dx
	pop cx
	pop bx
	pop ax

	ret
endp printTranspose

disp proc
	push ax
	push bx
	push cx
	push dx
	
	mov ch,02h
	mov cl,04h
repeat:
	rol val, cl
	mov al, val
	and al, 0fh
	cmp al, 0ah
	jc ahead
	add al, 07h
ahead:
	add al, 30h

	mov dl, al
	mov ah, 02h
	int 21h
	dec ch
	jnz repeat

	disp_msg tab

	pop dx
	pop cx
	pop bx
	pop ax

	ret
endp disp

endp main
end main
.exit

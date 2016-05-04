.model small
.stack 100h
print macro msg
	push ax
	push dx
	mov dx, offset msg
	mov ah, 09h
	int 21h
	pop dx
	pop ax
endm
.data
	list db 100 dup('$')
	read1 db 10,13, "Enter the count $"
	read2 db 10,13, "Enter the numbers $"
	listmsg  db 10,13, "List$"
	largestmsg  db 10,13, "largest : $"
	smallestmsg  db 10,13, "smallest :$"
	fibmsg  db 10,13, "Fibbannoci : $"
	lcmmsg  db 10,13, "lcm :$"
	hcfmsg  db 10,13, "hcf :$"
	newline db 10,13 ,"$"
	tab db "	$"
	num db ?
	count db ?
	largest db ?
	smallest db ?
	hcf db ?
	lcm db ?
.code
main proc
	mov ax, @data
	mov ds, ax

	print read1
	call read8
	mov al, num
	mov count, al

	print read2
	call readList

	print listmsg
	call printList

	call findSmallestAndLargest

	call sort
	print listmsg
	call printList

	call findLcmAndHcf

	call findFibanocci

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

read8 proc
	push ax
	push bx
	push cx
	push dx

	mov cl, 04

	mov ah, 01h
	int 21h
	cmp al, 'A'
	jc ahead2
	sub al, 07h
ahead2:
	sub al, 30h
	mov bl, al
	shl bl, cl

	int 21h
	cmp al, 'A'
	jc ahead3
	sub al, 07h
ahead3:
	sub al, 30h
	add bl, al
	mov num, bl

	pop dx
	pop cx
	pop bx
	pop ax
	ret
read8 endp

readList proc
	push ax
	push bx
	push cx
	push dx

	mov cl, count
	lea si, list
repeat4:
	call read8
	mov al, num
	mov [si], al
	inc si
	loop repeat4

	pop dx
	pop cx
	pop bx
	pop ax
	ret
readList endp

printList proc
	push ax
	push bx
	push cx
	push dx

	mov cl, count
	lea si, list
	;mov al, cl
	;and al, 01h
	;jz ahead5
	;dec cl
ahead5:
	;inc si
repeat5:
	mov al, [si]
	print tab
	call print8
	;add si, 02h
	;sub cl, 02
	inc si
	dec cl
	jnz repeat5

	pop dx
	pop cx
	pop bx
	pop ax
	ret
printList endp

sort proc
	push ax
	push bx
	push cx
	push dx

	mov dl, count
	mov ch, 00
	dec dl
repeat6:
	lea si, list
	mov cl, dl
compare:
	mov al, [si]
	cmp al, [si+1]
	jnc ahead6
	xchg al, [si+1]
	xchg al, [si]
ahead6:
	inc si
	loop compare
	dec dl
	jnz repeat6

	pop dx
	pop cx
	pop bx
	pop ax
	ret
sort endp

findSmallestAndLargest proc
	push ax
	push bx
	push cx
	push dx

	mov cl, count
	mov al, 00
	lea si, list
repeat7:
	cmp al, [si]
	jnc ahead7
	mov al, [si]
ahead7:
	inc si
	loop repeat7

	mov largest, al
	print largestmsg
	call print8

	mov cl, count
	mov al, 0ffh
	lea si, list
repeat8:
	cmp al, [si]
	jc ahead8
	mov al, [si]
ahead8:
	inc si
	loop repeat8

	mov smallest, al
	print smallestmsg
	call print8

	pop dx
	pop cx
	pop bx
	pop ax
	ret
findSmallestAndLargest endp

findLcmAndHcf proc
	push ax
	push bx
	push cx
	push dx

	mov al, largest
	mov bl, smallest
up:
	cmp al, bl
	je done
	jb down
	sub al, bl
	jmp down2
down:
	sub bl, al
down2:
	jmp up
done:
	mov hcf, al

	print hcfmsg
	call print8

	mov al, largest
	mov ah, 0
	mov bl, smallest
	mov cl, hcf
	mul bl
	div cl
	mov lcm , al
	
	print lcmmsg
	call print8
	
	pop dx
	pop cx
	pop bx
	pop ax
	ret
findLcmAndHcf endp


findFibanocci proc
	push ax
	push bx
	push cx
	push dx

	print fibmsg

	mov cl, count
	lea si, list
again:
	mov al, [si]
	call checkFibanocci
	inc si
	loop again

	pop dx
	pop cx
	pop bx
	pop ax
	ret
findFibanocci endp

checkFibanocci proc
	push ax
	push bx
	push cx
	push dx

	mov bl, 00
	mov bh, 01
up3:
	cmp al, bl
	je found 
	jl done2
	mov cl, bl
	add cl, bh
	mov bl, bh
	mov bh, cl
	jmp up3

found:
	call print8
	print tab
done2:	
	pop dx
	pop cx
	pop bx
	pop ax
	ret
checkFibanocci endp

end main
.exit
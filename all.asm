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
read macro msg
	push ax
	push dx
	mov ah, 0Ah
	lea dx, msg
	int 21h
	pop dx
	pop ax
endm
.data
	str1 db 80, 100 dup('$')
	str2 db 80, 100 dup('$')
	str3 db 80, 100 dup('$')
	revstr db 80, 100 dup('$')
	read1 db 10, 13, "Enter string 1 $"
	read2 db 10, 13, "Enter string 2 $"
	read3 db 10, 13, "Enter substring $"
	revstrmsg db 10, 13, "Reverse string $"
	equal db 10, 13, "strings are equal $"
	notequal db 10, 13, "strings are not equal $"
	yes db 10, 13, "Substring $"
	no db 10, 13, "Not Substring of first string $"
	newline db 10, 13, "$"
.code

main proc
	mov ax, @data
	mov es, ax
	mov ds, ax

	print read1
	read str1
	print read2
	read str2

	call stringCompare

	print read3
	read str3
	call checkSubstring

	call checkPalindrome

	mov ax, 4c00h
	int 21h
main endp

stringCompare proc
	push ax
	push bx
	push cx
	push dx

	lea si, str1+2
	lea di, str2+2
	mov cl, str1+1
	mov ch, 00h
	repe cmpsb
	jnz not
	print equal
	jmp done
not:
	print notequal
done:
	pop dx
	pop cx
	pop bx
	pop ax
	ret
stringCompare endp

checkSubstring proc
	push ax
	push bx
	push cx
	push dx

	mov bx, 0000
incbx:
	lea si, str1[bx]+2
	mov cl, str1+1
	sub cl, bl
	cmp cl, str3+1
	jl notsubstring
	lea di, str3+2
	mov cl, str3+1
	mov ch, 00h
	rep cmpsb
	jnz skip
	print yes
	jmp done2
skip:
	inc bx
	jmp incbx
notsubstring:
	print no
done2:

	pop dx
	pop cx
	pop bx
	pop ax
	ret
checkSubstring endp

checkPalindrome proc
	push ax
	push bx
	push cx
	push dx

	lea di, revstr
	lea si, str1+2
	mov ch, 00
	mov cl, str1+1
	dec si
	add si, cx
again:
	mov al, [si]
	mov [di], al
	dec si
	inc di
	loop again

	print revstrmsg
	print revstr

	lea si, str1+2
	lea di, revstr
	mov cl, str1+1
	mov ch, 00h
	repe cmpsb
	jnz not1
	print equal
	jmp done1
not1:
	print notequal
done1:	

	pop dx
	pop cx
	pop bx
	pop ax
	ret
checkPalindrome endp

end main
.exit 
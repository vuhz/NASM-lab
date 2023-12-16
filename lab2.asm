SYS_EXIT  equ 1
SYS_READ  equ 3
SYS_WRITE equ 4
STDIN     equ 0
STDOUT    equ 1

segment .data 

    msg1 db "Nhap vao chieu dai va chieu rong: ", 0xA,0xD 
    len1 equ $- msg1 

    msg2 db "Chu vi hinh cua chu nhat: "
    len2 equ $- msg2

    msg3 db "Dien tich cua hinh chu nhat: "
    len3 equ $- msg3

    newLineMsg db 0xA, 0xD
    newLineLen equ $-newLineMsg
segment .bss
   height resb 2 
   width resb 2 
   perimeter resb 10
   area resb 10
   res resb 1 

section	.text
    global _start

_start:
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, msg1
    mov edx, len1
    int 0x80

    mov eax, SYS_READ
    mov ebx, STDIN
    mov ecx, height
    mov edx, 2
    int 0x80

    mov eax, SYS_READ
    mov ebx, STDIN
    mov ecx, width
    mov edx, 2
    int 0x80

    mov al, [height]
    sub al, '0'
    add al, [width]
    sub al, '0'
    shl al, 1    ; Multiply by 2 for perimeter
    add al, '0'
    mov [perimeter], al

    mov al, [height]
    sub al, '0'
    mov bl, [width]
    sub bl, '0'
    mul bl
    add	al, '0'
    mov [area], al

    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, msg2
    mov edx, len2
    int 0x80

    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, perimeter
    mov edx, 10
    int 0x80

    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, newLineMsg
    mov edx, newLineLen
    int 0x80

    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, msg3
    mov edx, len3
    int 0x80

    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, area
    mov edx, 10
    int 0x80

    mov eax, 1
    int 0x80


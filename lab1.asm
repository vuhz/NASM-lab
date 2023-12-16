section .data
    yn db "Your name: "
    lenYn equ $-yn

    hl db "Hello "
    lenHl equ $-hl

    excl db " !!", 0x0A ; from line 46 will strip all new line byte (0x0A) so we add it after '!!'
    lenExcl equ $-excl

    wlc db "Welcome, "
    lenWlc equ $-wlc

    ehc db " to EHC"
    lenEhc equ $-ehc

section .bss
    name resb 50

section .text
    global _start

_start:
    mov eax, 4      ; sys write
    mov ebx, 1      ; stdout
    mov ecx, yn     ; your name     
    mov edx, lenYn  ; your name length
    int 80h         ; sys call
    ; eax = 4 corresponds to the sys_write system call for writing to a file descriptor.

    mov eax, 3      ; sys read
    mov ebx, 0      ; from stdin
    mov ecx, name   ; name
    mov edx, 50     ; name length
    int 80h         ; sys  call
    ; eax = 3 corresponds to the sys_read system call for reading from a file descriptor.

    ; The esi register is often used for string operations,
    ;memory addressing, and as a general-purpose register
    ;for holding memory addresses or indices during various computations
    mov esi, name    ; point to the start of the buffer
    ; moves the memory address of the name buffer into the esi register

    add esi, edx     ; move esi to the end of the buffer by add length of name bytes to esi

find_newline:
    ; Decrements the esi register
    dec esi       ; move back one byte
    cmp byte [esi], 0x0A  ; check if the byte is newline character '\n'
    je replace_newline    ; if it is, jump to replace_newline
    cmp esi, name         ; check if we've reached the start of the buffer
    jg find_newline       ; if not, continue searching

replace_newline:
    mov byte [esi], 0x00  ; replace newline with null terminator '\0'

    mov eax, 4
    mov ebx, 1
    mov ecx, hl
    mov edx, lenHl
    int 80h         

    mov eax, 4
    mov ebx, 1
    mov ecx, name
    mov edx, 50
    int 80h
    
    mov eax, 4
    mov ebx, 1
    mov ecx, excl
    mov edx, lenExcl
    int 80h

    mov eax, 4
    mov ebx, 1
    mov ecx, wlc
    mov edx, lenWlc
    int 80h

    mov eax, 4
    mov ebx, 1
    mov ecx, name
    mov edx, 10
    int 80h

    mov eax, 4
    mov ebx, 1
    mov ecx, ehc
    mov edx, lenEhc
    int 80h

    mov eax, 1
    int 80h
    
ret

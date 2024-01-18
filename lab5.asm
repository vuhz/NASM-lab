SYS_EXIT  equ 1
SYS_READ  equ 3
SYS_WRITE equ 4
STDIN     equ 0
STDOUT    equ 1

%macro print 2
   mov eax, SYS_WRITE
   mov ebx, STDOUT
   mov ecx, %1
   mov edx, %2
   int 80h
%endmacro

%macro read 2
   mov eax, SYS_READ
   mov ebx, STDIN
   mov ecx, %1
   mov edx, %2
   int 80h
%endmacro

%macro exit 0
   mov eax, SYS_EXIT
   int 80h
%endmacro

section .data
    inp db "Input anything here: ", 0
    lenInp equ $ - inp
    outp db "Your string entered: ", 0
    lenOutp equ $ - outp
    notLower db "Your strings entered is not contain lower case.", 0
    lenNotLower equ $ - notLower

section .bss
    input resb 32
    flag resb 1

section .text
    global _start

_start:
    print inp, lenInp       ; Print input msg

    read input, 32          ; Max 31bit

    mov ecx, input          ; Read input
    xor edx, edx            ; Clear edx using xor, then use edx as index

loop:
    mov al, [ecx + edx]     ; Address ecx, index edx, temporary store in al
    cmp al, 0               
    je end

    ; Check if char is in range a-z. If not, skip
    cmp al, 'a'             
    jl skip  
    cmp al, 'z'
    jg skip
    
    sub al, 32              ; Value from lowercase to uppercase
    mov [ecx + edx], al     ; Move al back to string (replace)
    mov byte [flag], 1      ; Yea this string have lower case
    inc edx                 ; Index ++
    jmp loop                

skip:
    inc edx                 
    jmp loop

end:
    cmp byte [flag], 0      ; None is lowercase?
    je true                 ; If True

false:                      ; Else
    print outp, lenOutp
    print input, 32
    exit

true:
    print notLower, lenNotLower
    exit
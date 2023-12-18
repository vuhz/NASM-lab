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

%macro exit 0
    mov eax, SYS_EXIT
    int 80h
%endmacro

segment .data
    input db "Input: "
    inputL equ $-input

    odd db "> This is odd number!!"
    oddL equ $-odd

    even db "> This is even number!!"
    evenL equ $-even

segment .bss
    inputData resb 1
    
segment .text
    global _start

_start:
    print input, inputL

    ; Handle input
    mov eax, SYS_READ
    mov ebx, STDIN
    mov ecx, inputData
    mov edx, 1
    int 80h

    ; Check even or odd
    ; Check the least significant bit of the number
    ; If this is 1, the number is odd, else even
    mov al, [inputData]
    AND	AL, 01H         ; ANDing with 0000 0001
    JZ even_            

    odd_:
        print odd, oddL
        exit
    even_:
        print even, evenL
        exit
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

section .data
    inputMsg db 'Input: '
    inputMsgLen equ $-inputMsg

    sumMsg db 'Sum of '
    sumMsgLen equ $-sumMsg

    sequencesMsg db ' sequences is: '
    sequencesMsgLen equ $-sequencesMsg

    test_ db 'a'
    test__ equ $-test_

section .bss
    number resb 10
    sum resb 10

section .text
    global _start

_start:

    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, inputMsg
    mov edx, inputMsgLen
    int 80h

    ; Input number (string type)
    mov eax,3
    mov ebx,0
    mov ecx,number
    mov edx,10
    int 80h

    lea esi,[number]
    mov ecx,4
    call string_to_int
        
    mov ebx, 0


    sumLoop:
        print test_, test__ ; should print n times 'a', where n = input number
        add [sum], ebx      ; add ebx to sum
        inc ebx             ; ebx ++
        cmp ebx, eax        ; if ebx == eax, end loop
        jle sumLoop

    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, sum
    mov edx, 10
    int 80h

end:
    mov eax,SYS_EXIT
    int 80h    

; Input:
; ESI = pointer to the string to convert
; ECX = number of digits in the string (must be > 0)
; Output:
; EAX = integer value
string_to_int:
    xor ebx,ebx    ; clear ebx

.next_digit:
    movzx eax,byte[esi]
    inc esi
    sub al,'0'    ; convert from ASCII to number
    imul ebx,10
    add ebx,eax   ; ebx = ebx*10 + eax
    loop .next_digit  ; while (--ecx)
    mov eax,ebx
    ret

;; Example:
; lea esi,[thestring]
; mov ecx,4
; call string_to_int
;; EAX now contains 1234

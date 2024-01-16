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

section	.data
   msg db 'The Sum is:',0xa	
   len equ $ - msg			
   ; num1 db '12345'
   ; num2 db '23456'
   ; sum db '     '

section .bss
   input1 resb 32
   input2 resb 32
   sum resb 32

section	.text
   global _start        

_start:	       
   ; input two numbers (strings)
   mov eax, SYS_READ
   mov ebx, STDIN
   mov ecx, input1
   mov edx, 32
   int 80h

   mov eax, SYS_READ
   mov ebx, STDIN
   mov ecx, input2
   mov edx, 32
   int 80h


   ; idea: dynamic find length of two input (for add loop problem)
   xor ecx, ecx
   lenInput1:
      cmp byte [input1 + ecx], 0
      je  found1
      inc ecx
      jmp lenInput1
   found1:
      sub ecx, 1
      mov esi, ecx   ; esi now holds the length of input1

   xor ecx, ecx
   lenInput2:
      cmp byte [input2 + ecx], 0
      je  found2
      inc ecx
      jmp lenInput2

   found2:
      sub ecx, 1
      mov edi, ecx   ; edi now holds the length of input2

   ; find the maximum length between input1 and input2
   cmp esi, edi
   jae lenMax
   mov esi, edi
   lenMax:
      mov   ecx, esi       ; num of digits


add_loop:  
   mov 	al, [input1 + ecx - 1]
   adc 	al, [input2 + ecx - 1]
   aaa
   pushf
   or 	al, 30h
   popf

   mov	[sum + ecx - 1], al
   loop	add_loop

   mov	edx, len            
   mov	ecx, msg            
   mov	ebx, STDOUT         
   mov	eax, SYS_WRITE      
   int	80h                 

   mov	edx, esi            
   mov	ecx, sum            
   mov	ebx, STDOUT         
   mov	eax, SYS_WRITE      
   int	80h                 

   ; exit the program
   mov	eax, SYS_EXIT        
   int	80h                 

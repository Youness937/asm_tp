section .bss
    buffer  resb 128
    output  resb 128

section .text
    global _start

_start:
    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 128
    syscall
    
    cmp rax, 0 
    je exit_code
    cmp rax, 1
    jbe exit_error     ; rien lu ou juste \n

    mov rcx, rax       
    dec rcx            
    mov rdx, rcx
    mov rsi, buffer     
    lea rdi, [output+rcx-1] 

reverse_loop:
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    dec rdi
    loop reverse_loop

    mov rax, 1
    mov rdi, 1
    mov rsi, output
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall

exit_code:
    mov rax, 60
    xor rdi, rdi
    syscall

exit_error:
    mov rax, 60
    mov rdi, 1
    syscall


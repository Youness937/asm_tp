section .bss
    buffer resb 4

section .text
    global _start

_start:
    mov rax, [rsp]
    cmp rax, 2
    jne exit_error

    mov rdi, [rsp+16]
    mov rax, 2
    mov rsi, 0
    mov rdx, 0
    syscall
    cmp rax, 0
    jl exit_error
    mov rbx, rax

    mov rax, 0
    mov rdi, rbx
    mov rsi, buffer
    mov rdx, 4
    syscall
    cmp rax, 4
    jne exit_error

    mov rax, 3
    mov rdi, rbx
    syscall

    mov al, [buffer]
    cmp al, 0x7F
    jne exit_error
    mov al, [buffer+1]
    cmp al, 'E'
    jne exit_error
    mov al, [buffer+2]
    cmp al, 'L'
    jne exit_error
    mov al, [buffer+3]
    cmp al, 'F'
    jne exit_error

exit_ok:
    mov rax, 60
    xor rdi, rdi
    syscall

exit_error:
    mov rax, 60
    mov rdi, 1
    syscall


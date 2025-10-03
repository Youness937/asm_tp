section .data
    msg db "Hello Universe!", 0x0A
    len equ $ - msg

section .text
    global _start

_start:
    mov rax, [rsp]
    cmp rax, 2
    jl .no_param

    mov rdi, [rsp+16]
    mov rax, 2
    mov rsi, 577
    mov rdx, 420
    syscall
    mov rbx, rax

    mov rax, 1
    mov rdi, rbx
    mov rsi, msg
    mov rdx, len
    syscall

    mov rax, 3
    mov rdi, rbx
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall

.no_param:
    mov rax, 60
    mov rdi, 1
    syscall

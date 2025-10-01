section .bss
    input resb 32

section .text
    global _start

atoi:
    xor rax, rax
.next:
    movzx rcx, byte [rdi]
    test rcx, rcx
    jz .done
    cmp rcx, 10
    je .done
    cmp rcx, '0'
    jb .invalid
    cmp rcx, '9'
    ja .invalid
    sub rcx, '0'
    imul rax, rax, 10
    add rax, rcx
    inc rdi
    jmp .next
.done:
    ret
.invalid:
    mov rax, 60
    mov rdi, 2
    syscall

_start:
    ; read(0, input, 32)
    mov rax, 0
    mov rdi, 0
    mov rsi, input
    mov rdx, 32
    syscall

    mov rdi, input
    call atoi
    mov rbx, rax

    cmp rbx, 1
    jle .not_prime

    cmp rbx, 2
    je .prime

    mov rcx, 2
.loop:
    cmp rcx, rbx
    jge .prime
    mov rax, rbx
    xor rdx, rdx
    div rcx
    cmp rdx, 0
    je .not_prime
    inc rcx
    jmp .loop

.prime:
    mov rax, 60
    xor rdi, rdi
    syscall

.not_prime:
    mov rax, 60
    mov rdi, 1
    syscall

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
    cmp rcx, 10          ; '\n' ?
    je .done             ; arrêter si retour à la ligne
    sub rcx, '0'
    imul rax, rax, 10
    add rax, rcx
    inc rdi
    jmp .next
.done:
    ret


_start:
    ; lire stdin
    mov rax, 0
    mov rdi, 0
    mov rsi, input
    mov rdx, 32
    syscall

    ; atoi
    mov rdi, input
    call atoi
    mov rbx, rax       ; n

    ; n <= 1 → not prime
    cmp rbx, 1
    jle .not_prime

    ; n == 2 → prime
    cmp rbx, 2
    je .prime

    ; i = 2
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

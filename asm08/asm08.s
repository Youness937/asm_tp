section .bss
    buffer resb 32       ; buffer pour afficher le résultat

section .text
    global _start

; ─────────────── atoi ───────────────
atoi:
    xor rax, rax
.next:
    movzx rcx, byte [rdi]
    test rcx, rcx
    jz .done
    cmp rcx, 10          ; '\n'
    je .done
    sub rcx, '0'
    imul rax, rax, 10
    add rax, rcx
    inc rdi
    jmp .next
.done:
    ret

; ─────────────── itoa ───────────────
itoa:
    mov rcx, 10
    lea rsi, [buffer+31]
    mov byte [rsi], 0
.convert:
    xor rdx, rdx
    div rcx
    add dl, '0'
    dec rsi
    mov [rsi], dl
    test rax, rax
    jnz .convert
    mov rax, rsi
    ret

; ─────────────── main ───────────────
_start:
    ; récupérer argc
    mov rbx, [rsp]
    cmp rbx, 2
    jl .error             ; si pas d’argument → exit(1)

    ; argv[1]
    mov rdi, [rsp+16]
    call atoi
    mov rbx, rax          ; N

    ; calculer sum = N*(N-1)/2
    mov rax, rbx
    dec rax               ; rax = N-1
    imul rax, rbx         ; rax = N*(N-1)
    mov rcx, 2
    xor rdx, rdx
    div rcx               ; rax = (N*(N-1))/2

    ; afficher le résultat
    mov rdi, rax
    call itoa
    mov rsi, rax
    mov rdx, buffer+32
    sub rdx, rsi

    mov rax, 1            ; syscall write
    mov rdi, 1            ; stdout
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, nl
    mov rdx, 1
    syscall

    ; exit(0)
    mov rax, 60
    xor rdi, rdi
    syscall

.error:
    mov rax, 60
    mov rdi, 1
    syscall

section .data
    nl db 10

section .bss
    buffer resb 32

section .text
    global _start

; atoi avec gestion des nombres négatifs
atoi:
    xor rax, rax
    mov rbx, 1            ; signe positif par défaut
    movzx rcx, byte [rdi]
    cmp rcx, '-'
    jne .parse_digits
    mov rbx, -1           ; signe négatif
    inc rdi
.parse_digits:
    movzx rcx, byte [rdi]
    test rcx, rcx
    jz .done
    sub rcx, '0'
    imul rax, rax, 10
    add rax, rcx
    inc rdi
    jmp .parse_digits
.done:
    imul rax, rbx
    ret

itoa:
    mov rcx, 10
    mov rbx, rdi          ; sauvegarder valeur
    cmp rbx, 0
    jge .positive
    neg rbx               ; rendre positif
    mov rdi, rbx
    call itoa
    dec rax
    mov byte [rax], '-'
    ret
.positive:
    lea rsi, [buffer+31]
    mov byte [rsi], 0
.convert:
    xor rdx, rdx
    mov rax, rbx
    div rcx
    add dl, '0'
    dec rsi
    mov [rsi], dl
    mov rbx, rax
    test rbx, rbx
    jnz .convert
    mov rax, rsi
    ret

_start:
    mov rbx, [rsp]        ; argc
    cmp rbx, 3
    jl .error

    mov rdi, [rsp+16]     ; argv[1]
    call atoi
    mov r8, rax           ; premier entier

    mov rdi, [rsp+24]     ; argv[2]
    call atoi
    add rax, r8           ; somme

    mov rdi, rax
    call itoa
    mov rsi, rax
    mov rdx, buffer+32
    sub rdx, rsi

    mov rax, 1            ; write
    mov rdi, 1
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, nl
    mov rdx, 1
    syscall

    mov rax, 60           ; exit(0)
    xor rdi, rdi
    syscall

.error:
    mov rax, 60           ; exit(1)
    mov rdi, 1
    syscall

section .data
    nl db 10


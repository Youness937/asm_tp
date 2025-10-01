section .bss
    buffer resb 32

section .text
    global _start

; ─────────────── atoi (gère signe) ───────────────
atoi:
    xor rax, rax
    mov rbx, 1
    movzx rcx, byte [rdi]
    cmp rcx, '-'
    jne .parse
    mov rbx, -1
    inc rdi
.parse:
    movzx rcx, byte [rdi]
    test rcx, rcx
    jz .done
    cmp rcx, 10
    je .done
    cmp rcx, '0'
    jb .done
    cmp rcx, '9'
    ja .done
    sub rcx, '0'
    imul rax, rax, 10
    add rax, rcx
    inc rdi
    jmp .parse
.done:
    imul rax, rbx
    ret

; ─────────────── itoa ───────────────
itoa:
    mov rcx, 10
    cmp rdi, 0
    jge .positive
    neg rdi
    mov rbx, rdi
    call .convert
    dec rax
    mov byte [rax], '-'
    ret
.positive:
    mov rbx, rdi
    call .convert
    ret

.convert:
    lea rsi, [buffer+31]
    mov byte [rsi], 0
.loop:
    xor rdx, rdx
    mov rax, rbx
    mov rcx, 10
    div rcx
    add dl, '0'
    dec rsi
    mov [rsi], dl
    mov rbx, rax
    test rbx, rbx
    jnz .loop
    mov rax, rsi
    ret

; ─────────────── main ───────────────
_start:
    mov rbx, [rsp]
    cmp rbx, 4
    jl .error

    ; argv[1]
    mov rdi, [rsp+16]
    call atoi
    mov r8, rax

    ; argv[2]
    mov rdi, [rsp+24]
    call atoi
    mov r9, rax

    ; argv[3]
    mov rdi, [rsp+32]
    call atoi
    mov r10, rax

    ; max = a
    mov r11, r8

    ; max = (b > max ? b : max)
    mov rax, r9
    cmp rax, r11
    cmovg r11, rax

    ; max = (c > max ? c : max)
    mov rax, r10
    cmp rax, r11
    cmovg r11, rax

    ; afficher max
    mov rdi, r11
    call itoa
    mov rsi, rax
    mov rdx, buffer+32
    sub rdx, rsi

    mov rax, 1
    mov rdi, 1
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, nl
    mov rdx, 1
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall

.error:
    mov rax, 60
    mov rdi, 1
    syscall

section .data
    nl db 10

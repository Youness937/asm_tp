section .bss
    buffer resb 32

section .text
    global _start

; ─────────────── atoi (gère le signe) ───────────────
atoi:
    xor rax, rax
    mov rbx, 1              ; signe positif
    movzx rcx, byte [rdi]
    cmp rcx, '-'
    jne .parse
    mov rbx, -1             ; signe négatif
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
.convert_loop:
    xor rdx, rdx
    mov rax, rbx
    mov rcx, 10
    div rcx
    add dl, '0'
    dec rsi
    mov [rsi], dl
    mov rbx, rax
    test rbx, rbx
    jnz .convert_loop
    mov rax, rsi
    ret

; ─────────────── main ───────────────
_start:
    mov rbx, [rsp]       ; argc
    cmp rbx, 4
    jl .error

    ; argv[1] → a
    mov rdi, [rsp+16]
    call atoi
    mov r8, rax

    ; argv[2] → b
    mov rdi, [rsp+24]
    call atoi
    mov r9, rax

    ; argv[3] → c
    mov rdi, [rsp+32]
    call atoi
    mov r10, rax

    ; max = a
    mov r11, r8

    ; if b > max → max = b
    cmp r9, r11
    jg .use_b
    jmp .skip_b
.use_b:
    mov r11, r9
.skip_b:

    ; if c > max → max = c
    cmp r10, r11
    jg .use_c
    jmp .skip_c
.use_c:
    mov r11, r10
.skip_c:

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

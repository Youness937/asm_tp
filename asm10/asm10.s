section .bss
    buffer resb 32

section .text
    global _start

; ─────────────── atoi (robuste) ───────────────
atoi:
    xor rax, rax
.next:
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
    mov rbx, [rsp]       ; argc
    cmp rbx, 4
    jl .error

    ; argv[1] -> a
    mov rdi, [rsp+16]
    call atoi
    mov r8, rax

    ; argv[2] -> b
    mov rdi, [rsp+24]
    call atoi
    mov r9, rax

    ; argv[3] -> c
    mov rdi, [rsp+32]
    call atoi
    mov r10, rax

    ; max = a
    mov r11, r8

    ; if b > max
    cmp r9, r11
    jle .skip_b
    mov r11, r9
.skip_b:

    ; if c > max
    cmp r10, r11
    jle .skip_c
    mov r11, r10
.skip_c:

    ; print max
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

section .bss
    buffer resb 64        ; buffer pour la sortie

section .text
    global _start

; ─────────────── atoi ───────────────
atoi:
    xor rax, rax
.next:
    movzx rcx, byte [rdi]
    test rcx, rcx
    jz .done
    cmp rcx, 10
    je .done
    sub rcx, '0'
    imul rax, rax, 10
    add rax, rcx
    inc rdi
    jmp .next
.done:
    ret

; ─────────────── itoa_base ───────────────
; rdi = valeur, rsi = base (2 ou 16)
; sortie: rax = pointeur string
itoa_base:
    mov rcx, rsi
    lea rsi, [buffer+63]
    mov byte [rsi], 0
.convert:
    xor rdx, rdx
    div rcx
    cmp dl, 9
    jg .letter
    add dl, '0'
    jmp .store
.letter:
    add dl, 55        ; 10 → 'A', 11 → 'B', etc.
.store:
    dec rsi
    mov [rsi], dl
    test rax, rax
    jnz .convert
    mov rax, rsi
    ret

; ─────────────── main ───────────────
_start:
    mov rbx, [rsp]        ; argc
    cmp rbx, 2
    jl .error

    mov r8, 16            ; base par défaut = 16 (hex)

    mov rdi, [rsp+16]     ; argv[1]
    mov al, byte [rdi]
    cmp al, '-'
    jne .arg_is_number

    ; option trouvée → vérifier "-b"
    cmp byte [rdi+1], 'b'
    jne .error

    mov r8, 2             ; base = 2
    mov rdi, [rsp+24]     ; argv[2] = nombre
    jmp .convert_arg

.arg_is_number:
    mov rdi, [rsp+16]     ; argv[1] = nombre

.convert_arg:
    call atoi             ; rax = valeur entière

    mov rsi, r8           ; base
    mov rdi, rax
    call itoa_base
    mov rsi, rax          ; pointeur string
    mov rdx, buffer+64
    sub rdx, rsi          ; longueur

    ; write(1, str, len)
    mov rax, 1
    mov rdi, 1
    syscall

    ; retour à la ligne
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

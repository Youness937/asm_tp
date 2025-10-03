section .bss
    buffer resb 128          ; tampon pour la chaîne lue

section .text
    global _start

_start:
    ; --- récupérer argc ---
    mov rdi, [rsp]           ; argc
    cmp rdi, 2               ; argc < 2 ?
    jl .error                ; si pas d’argument -> erreur

    ; --- récupérer argv[1] ---
    mov rsi, [rsp+16]        ; argv[1]
    movzx rdi, byte [rsi]    ; premier caractère de argv[1]
    sub rdi, '0'             ; convertir ASCII -> entier
    mov r12, rdi             ; sauvegarder le shift dans R12

.read_input:
    ; --- lecture depuis stdin ---
    mov rax, 0               ; syscall read
    mov rdi, 0               ; stdin
    mov rsi, buffer
    mov rdx, 128
    syscall
    mov rcx, rax             ; rcx = nb caractères lus

    ; --- boucle sur chaque caractère ---
    xor rbx, rbx             ; index = 0

.loop:
    cmp rbx, rcx
    jge .done                ; fin si index >= taille

    mov al, [buffer+rbx]     ; charger caractère

    ; ---------- minuscules ----------
    cmp al, 'a'
    jl .check_upper
    cmp al, 'z'
    jg .check_upper

    sub al, 'a'
    add al, r12b
    xor rdx, rdx
    movzx rax, al
    mov rcx, 26
    div rcx
    mov al, dl
    add al, 'a'
    jmp .store

.check_upper:
    ; ---------- majuscules ----------
    cmp al, 'A'
    jl .store
    cmp al, 'Z'
    jg .store

    sub al, 'A'
    add al, r12b
    xor rdx, rdx
    movzx rax, al
    mov rcx, 26
    div rcx
    mov al, dl
    add al, 'A'

.store:
    mov [buffer+rbx], al
    inc rbx
    jmp .loop

.done:
    ; --- écrire le résultat ---
    mov rax, 1
    mov rdi, 1
    mov rsi, buffer
    mov rdx, rcx
    syscall

    ; --- quitter proprement ---
    mov rax, 60
    xor rdi, rdi
    syscall

.error:
    ; --- pas assez d’arguments ---
    mov rax, 60              ; syscall exit
    mov rdi, 1               ; code erreur = 1
    syscall

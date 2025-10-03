section .bss
    buffer resb 128          ; tampon pour lire la chaîne

section .text
    global _start

_start:
    ; --- récupérer l’argument argv[1] (le shift) ---
    mov rsi, [rsp+16]        ; argv[1]
    movzx rdi, byte [rsi]    ; premier caractère (ex: '3')
    sub rdi, '0'             ; convertir ASCII -> int
    mov r12, rdi             ; garder le shift dans R12

    ; --- lecture depuis stdin ---
    mov rax, 0               ; syscall read
    mov rdi, 0               ; stdin
    mov rsi, buffer
    mov rdx, 128
    syscall
    mov rcx, rax             ; rcx = nb de caractères lus

    ; --- boucle sur chaque caractère ---
    xor rbx, rbx             ; index = 0

.loop:
    cmp rbx, rcx
    jge .done                ; fin si index >= taille

    mov al, [buffer+rbx]     ; charger caractère

    ; ---------- minuscules ----------
    cmp al, 'a'
    jl .check_upper           ; si < 'a', aller tester maj
    cmp al, 'z'
    jg .check_upper           ; si > 'z', aller tester maj

    sub al, 'a'              ; ramener dans [0–25]
    add al, r12b             ; ajouter le shift
    xor rdx, rdx
    movzx rax, al
    mov rcx, 26
    div rcx                  ; quotient dans RAX, reste dans RDX
    mov al, dl               ; al = reste
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
    mov [buffer+rbx], al     ; écrire le caractère transformé
    inc rbx
    jmp .loop

.done:
    ; --- écrire résultat sur stdout ---
    mov rax, 1
    mov rdi, 1
    mov rsi, buffer
    mov rdx, rcx
    syscall

    ; --- quitter ---
    mov rax, 60
    xor rdi, rdi
    syscall

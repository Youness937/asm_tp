section .bss
    buffer resb 32        ; buffer pour stocker le résultat converti en string

section .text
    global _start

; ────────────────────────────────
; atoi : convertir une string -> entier
; Entrée : rdi = pointeur sur string
; Sortie : rax = entier
; ────────────────────────────────
atoi:
    xor rax, rax          ; résultat = 0
.next_char:
    movzx rcx, byte [rdi] ; lire caractère
    test rcx, rcx
    jz .done              ; si '\0', fin
    sub rcx, '0'          ; convertir ASCII → chiffre
    imul rax, rax, 10     ; rax = rax * 10
    add rax, rcx          ; ajouter chiffre
    inc rdi
    jmp .next_char
.done:
    ret

; ────────────────────────────────
; itoa : convertir entier -> string
; Entrée : rdi = entier
; Sortie : rax = pointeur vers string
; ────────────────────────────────
itoa:
    mov rcx, 10
    lea rsi, [buffer+31]  ; partir de la fin du buffer
    mov byte [rsi], 0     ; terminateur nul
.convert:
    xor rdx, rdx
    div rcx               ; rax / 10, reste dans rdx
    add dl, '0'           ; chiffre → ASCII
    dec rsi
    mov [rsi], dl
    test rax, rax
    jnz .convert
    mov rax, rsi          ; retourner pointeur sur string
    ret

; ────────────────────────────────
; _start : point d’entrée
; ────────────────────────────────
_start:
    ; argv[1] est à [rsp+16]
    mov rdi, [rsp+16]
    call atoi
    mov rbx, rax          ; sauvegarder premier entier

    ; argv[2] est à [rsp+24]
    mov rdi, [rsp+24]
    call atoi
    add rax, rbx          ; rax = somme

    ; convertir résultat en string
    mov rdi, rax
    call itoa
    mov rsi, rax          ; adresse string résultat
    mov rdx, buffer+32
    sub rdx, rsi          ; longueur = fin - début

    ; syscall write(1, rsi, rdx)
    mov rax, 1            ; write
    mov rdi, 1            ; stdout
    syscall

    ; afficher un retour ligne
    mov rax, 1
    mov rdi, 1
    mov rsi, nl
    mov rdx, 1
    syscall

    ; syscall exit(0)
    mov rax, 60
    xor rdi, rdi
    syscall

section .data
    nl db 10


global _start

section .data
    msg db "1337", 0xA   ; texte "1337" suivi d’un saut de ligne
    len equ $ - msg      ; calcule la longueur automatiquement

section .text
_start:
    ; appel write(1, msg, len)
    mov rax, 1           ; syscall write
    mov rdi, 1           ; 1 = stdout
    mov rsi, msg         ; adresse du message
    mov rdx, len         ; longueur du message
    syscall

    ; appel exit(0)
    mov rax, 60          ; syscall exit
    xor rdi, rdi         ; code retour = 0
    syscall


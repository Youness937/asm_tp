global _start

section .text
_start:
    mov     rax, 60     ; syscall exit
    xor     rdi, rdi    ; code retour 0
    syscall

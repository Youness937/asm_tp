global _start

section .data
    okmsg db "1337", 0xA
    oklen equ $ - okmsg

section .text
_start:
    ; récupérer argc et argv depuis la pile
    pop rdi             ; argc (non utilisé ici)
    pop rsi             ; argv[0] = nom du programme
    pop rsi             ; argv[1] = premier argument (adresse de la chaîne)

    ; vérifier si argv[1][0] == '4'
    mov al, byte [rsi]
    cmp al, '4'
    jne not_equal

    ; vérifier si argv[1][1] == '2'
    mov al, byte [rsi+1]
    cmp al, '2'
    jne not_equal

    ; vérifier si argv[1][2] == 0 (fin de chaîne)
    mov al, byte [rsi+2]
    cmp al, 0
    jne not_equal

    ; si tout est bon → afficher "1337\n"
    mov rax, 1          ; syscall write
    mov rdi, 1          ; stdout
    mov rsi, okmsg
    mov rdx, oklen
    syscall

    ; exit(0)
    mov rax, 60
    xor rdi, rdi
    syscall

not_equal:
    ; exit(1)
    mov rax, 60
    mov rdi, 1
    syscall

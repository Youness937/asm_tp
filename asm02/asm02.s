global _start

section .bss
    buffer resb 4        ; réserver 4 octets pour l’entrée

section .data
    okmsg db "1337", 0xA ; message à afficher
    oklen equ $ - okmsg

section .text
_start:
    ; read(0, buffer, 4)
    mov rax, 0          ; syscall read
    mov rdi, 0          ; stdin
    mov rsi, buffer     ; adresse du buffer
    mov rdx, 4          ; nombre max de caractères
    syscall

    ; comparer buffer[0] et buffer[1] avec '4' et '2'
    mov al, byte [buffer]     ; premier caractère
    cmp al, '4'
    jne not_equal             ; si ≠ '4' → pas bon

    mov al, byte [buffer+1]   ; deuxième caractère
    cmp al, '2'
    jne not_equal             ; si ≠ '2' → pas bon

    ; si OK → write(1, okmsg, oklen)
    mov rax, 1
    mov rdi, 1
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

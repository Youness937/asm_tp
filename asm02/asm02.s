global _start

section .bss
    buffer resb 4        ; réserver 4 octets pour l’entrée

section .data
    okmsg db "1337", 0xA
    oklen equ $ - okmsg

section .text
_start:
    ; read(0, buffer, 4)
    mov rax, 0          ; syscall read
    mov rdi, 0          ; stdin
    mov rsi, buffer     ; adresse du buffer
    mov rdx, 4          ; taille max
    syscall

    ; vérifier si buffer[0] == '4'
    mov al, byte [buffer]
    cmp al, '4'
    jne not_equal

    ; vérifier si buffer[1] == '2'
    mov al, byte [buffer+1]
    cmp al, '2'
    jne not_equal

    ; vérifier que buffer[2] est bien \n ou 0
    mov al, byte [buffer+2]
    cmp al, 0xA         ; saut de ligne ?
    je good_input
    cmp al, 0           ; fin de chaîne ?
    je good_input
    jmp not_equal

good_input:
    ; write(1, okmsg, oklen)
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


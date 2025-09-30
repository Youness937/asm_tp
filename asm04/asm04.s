section .bss
    buffer resb 16         ; pour lire l'entrée

section .text
    global _start

_start:
    ; Lire depuis stdin
    mov rax, 0             ; syscall: read
    mov rdi, 0             ; fd = stdin
    mov rsi, buffer        ; buffer
    mov rdx, 16            ; taille max
    syscall

    ; Conversion ASCII -> entier
    xor rbx, rbx           ; rbx = entier = 0
    mov rcx, buffer        ; pointeur vers le buffer

.convert_loop:
    mov al, byte [rcx]     ; lire un caractère
    cmp al, 10             ; fin de ligne ? '\n'
    je .done_convert
    cmp al, 0              ; fin string ?
    je .done_convert

    ; Vérifier si c'est bien un chiffre
    cmp al, '0'
    jl .invalid_input
    cmp al, '9'
    jg .invalid_input

    sub al, '0'            ; convertir char -> chiffre
    imul rbx, rbx, 10      ; entier *= 10
    add rbx, rax           ; entier += chiffre

    inc rcx                ; avancer pointeur
    jmp .convert_loop

.invalid_input:
    mov rax, 60            ; syscall: exit
    mov rdi, 2             ; code retour = 2
    syscall


.done_convert:
    ; Tester la parité
    test rbx, 1            ; tester bit 0
    jz .even               ; si zéro => pair
    jmp .odd

.even:
    mov rax, 60            ; syscall: exit
    xor rdi, rdi           ; code retour = 0
    syscall

.odd:
    mov rax, 60            ; syscall: exit
    mov rdi, 1             ; code retour = 1
    syscall

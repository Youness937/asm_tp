section .text
    global _start

_start:
    ; Charger argc correctement (32 bits sur la pile)
    mov eax, [rsp]          ; eax = argc
    cmp eax, 2              ; si argc < 2 (pas d'argument)
    jl .no_arg

    ; Récupérer argv[1] (pointeur)
    mov rbx, [rsp+16]

    ; Calculer strlen(argv[1])
    mov rcx, rbx
.len_loop:
    cmp byte [rcx], 0
    je .len_done
    inc rcx
    jmp .len_loop

.len_done:
    sub rcx, rbx            ; rcx = longueur de la chaîne

    ; write(1, argv[1], longueur)
    mov rax, 1              ; syscall: write
    mov rdi, 1              ; fd = stdout
    mov rsi, rbx            ; buffer = argv[1]
    mov rdx, rcx            ; taille = longueur
    syscall

    ; exit(0)
    mov rax, 60             ; syscall: exit
    xor rdi, rdi            ; code = 0
    syscall

.no_arg:
    ; exit(1) si pas d'argument
    mov rax, 60
    mov rdi, 1
    syscall


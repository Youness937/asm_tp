section .text
    global _start

_start:
    ; Récupérer argv[1]
    mov rbx, [rsp+16]       ; rbx = pointeur vers argv[1]

    ; Calculer strlen(argv[1])
    mov rcx, rbx            ; rcx = pointeur courant
.len_loop:
    cmp byte [rcx], 0
    je .len_done
    inc rcx
    jmp .len_loop

.len_done:
    sub rcx, rbx            ; rcx = longueur de la chaîne

    ; Appeler write(1, argv[1], longueur)
    mov rax, 1              ; syscall write
    mov rdi, 1              ; fd = stdout
    mov rsi, rbx            ; buffer = argv[1]
    mov rdx, rcx            ; taille
    syscall

    ; exit(0)
    mov rax, 60             ; syscall exit
    xor rdi, rdi            ; code = 0
    syscall

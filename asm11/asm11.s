section .bss
    buffer resb 128

section .text
    global _start

_start:
    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 128
    syscall

    xor rcx, rcx
    mov rsi, buffer

next_char:
    mov al, [rsi]
    cmp al, 0
    je convert_number
    cmp al, 10
    je convert_number

    cmp al, 'a'
    je inc_count
    cmp al, 'e'
    je inc_count
    cmp al, 'i'
    je inc_count
    cmp al, 'o'
    je inc_count
    cmp al, 'u'
    je inc_count
    cmp al, 'y'
    je inc_count

    cmp al, 'A'
    je inc_count
    cmp al, 'E'
    je inc_count
    cmp al, 'I'
    je inc_count
    cmp al, 'O'
    je inc_count
    cmp al, 'U'
    je inc_count
    cmp al, 'Y'
    je inc_count

    jmp skip_inc

inc_count:
    inc rcx

skip_inc:
    inc rsi
    jmp next_char

convert_number:
    mov rax, rcx
    lea rdi, [buffer+128]
    xor rcx, rcx

    test rax, rax
    jnz conv_loop
    dec rdi
    mov byte [rdi], '0'
    mov rcx, 1
    jmp print_result

conv_loop:
    xor rdx, rdx
    mov rbx, 10
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz conv_loop

print_result:
    mov rsi, rdi
    mov rdx, rcx
    mov rax, 1
    mov rdi, 1
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall


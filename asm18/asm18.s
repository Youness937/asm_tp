section .data
    msg db "Hello, client!", 0
    msglen equ $-msg

    ; Timeout 2s
    timeout dq 2, 0

    ; sockaddr_in pour 127.0.0.1:12345
    sockaddr:
        dw 2                  ; AF_INET
        dw 0x3930             ; port 12345 en big endian
        dd 0x0100007F         ; 127.0.0.1
        dq 0                  ; padding

    successmsg db 'message: "Hello, client!"', 10
    successmsglen equ $-successmsg

    timeoutmsg db "Timeout: no response from server", 10
    timeoutmsglen equ $-timeoutmsg

section .bss
    buffer resb 128

section .text
    global _start

_start:
    ; --- socket(AF_INET, SOCK_DGRAM, 0) ---
    mov rax, 41
    mov rdi, 2          ; AF_INET
    mov rsi, 2          ; SOCK_DGRAM
    xor rdx, rdx
    syscall
    mov r12, rax        ; fd

    ; --- setsockopt(fd, SOL_SOCKET, SO_RCVTIMEO, &timeout, 16) ---
    mov rax, 54
    mov rdi, r12
    mov rsi, 1          ; SOL_SOCKET
    mov rdx, 20         ; SO_RCVTIMEO
    lea r10, [rel timeout]
    mov r8, 16
    syscall

    ; --- sendto(fd, msg, msglen, 0, &sockaddr, 16) ---
    mov rax, 44
    mov rdi, r12
    lea rsi, [rel msg]
    mov rdx, msglen
    xor r10, r10        ; flags
    lea r8, [rel sockaddr]
    mov r9, 16
    syscall

    ; --- recvfrom(fd, buffer, 128, 0, 0, 0) ---
    mov rax, 45
    mov rdi, r12
    lea rsi, [buffer]
    mov rdx, 128
    xor r10, r10
    xor r8, r8
    xor r9, r9
    syscall
    cmp rax, 0
    jle .timeout

    ; --- succès → afficher message ---
    mov rax, 1
    mov rdi, 1
    mov rsi, successmsg
    mov rdx, successmsglen
    syscall

    ; exit 0
    mov rax, 60
    xor rdi, rdi
    syscall

.timeout:
    ; --- afficher timeout ---
    mov rax, 1
    mov rdi, 1
    mov rsi, timeoutmsg
    mov rdx, timeoutmsglen
    syscall

    ; exit 1
    mov rax, 60
    mov rdi, 1
    syscall

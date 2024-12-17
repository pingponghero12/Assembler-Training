section .data
    matrix  dd 1, 2, 3
            dd 4, 5, 6
            dd 7, 8, 9

    total_msg       db 'Total sum = ', 0
    total_msg_len   equ $ - total_msg
    diag_msg        db 'Diagonal sum = ', 0
    diag_msg_len    equ $ - diag_msg 
    new_line        db 10, 0
    new_line_len    equ $ - new_line

section .bss
    total_sum   resd 1
    diag_sum    resd 1
    total_str   resd 12 ; Buffers
    diag_str    resd 12

section .text
    global _start

_start:
    xor eax, eax
    mov [total_sum], eax
    mov [diag_sum], eax

    mov ecx, 9
    mov esi, matrix

sum_loop:
    mov eax, [esi]
    add [total_sum], eax
    add esi, 4
    loop sum_loop

    ; Diagonal sum
    mov esi, matrix     ; Reset poiter
    mov eax, [esi]      ; [0][0]
    mov ebx, [esi + 16] ; [1][1]
    add eax, ebx
    mov ebx, [esi + 28] ; [2][2]
    add eax, ebx
    mov [diag_sum], eax

    ; Convect to string
    mov eax, [total_sum]
    mov edi, total_str + 11
    mov byte [edi], 0
    dec edi
    call int_to_ascii
    mov esi, edi        ; Save start of stringu

    ; Printing
    mov eax, 4
    mov ebx, 1
    mov ecx, total_msg
    mov edx, total_msg_len
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, esi
    mov edx, total_str + 12
    int 0x80

    ; New line
    mov eax, 4
    mov ebx, 1
    mov ecx, new_line
    mov edx, new_line_len
    int 0x80

    ; Convect to string
    mov eax, [diag_sum]
    mov edi, diag_str + 11
    mov byte [edi], 0
    dec edi
    call int_to_ascii
    mov esi, edi        ; Save start of stringu

    ; Printing
    mov eax, 4
    mov ebx, 1
    mov ecx, diag_msg
    mov edx, diag_msg_len
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, esi
    mov edx, diag_str + 12
    int 0x80

    ; New line
    mov eax, 4
    mov ebx, 1
    mov ecx, new_line
    mov edx, new_line_len
    int 0x80

    mov eax, 1
    mov ebx, 0
    int 0x80

int_to_ascii:
    cmp eax, 0
    jne int_to_ascii_loop
    mov byte [edi], '0'
    dec edi
    ret

int_to_ascii_loop:
    xor edx, edx
    mov ebx, 10
    div ebx
    add dl, '0'
    mov [edi], dl
    dec edi
    cmp eax, 0
    jne int_to_ascii_loop
    inc edi
    ret

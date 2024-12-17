section .data
    number      dd      12345
    new_line    db      10, 0
    new_line_len    equ     $ - new_line

section .bss
    hex_str resb    9

section .text
    global _start

_start:
    mov eax, [number]
    mov esi, hex_str + 8
    mov byte [esi], 0
    dec esi

    cmp eax, 0
    jne convert_loop

    mov byte [esi], '0'
    dec esi
    jmp print_result

convert_loop:
    xor edx, edx
    mov ebx, 16
    div ebx         ; EAX = EAX / 16, EDX = rest

    cmp edx, 10
    jl append_dec
    add dl, 'A' - 10
    jmp append_hex

append_dec:
    add dl, '0'

append_hex:
    mov [esi], dl
    dec esi

    cmp eax, 0
    jne convert_loop

print_result:
    ; Display the sum
    mov eax, 4
    mov ebx, 1
    mov ecx, hex_str
    mov edx, hex_str + 9   ; Calculate length of sum string
    sub edx, ecx
    int 0x80

    ; Display result message
    mov eax, 4
    mov ebx, 1
    mov ecx, new_line
    mov edx, new_line_len
    int 0x80

    mov eax, 1
    xor ebx, ebx
    int 0x80

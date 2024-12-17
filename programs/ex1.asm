section .data
    prompt      db  'Enter an integer: ', 0
    prompt_len  equ $ - prompt

    new_line  db  10, 0
    new_line_len  equ $ - new_line

section .bss
    input_buffer    resb 20
    sum_str         resb 12

section .text
    global _start

_start:
    ; Display prompt
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt
    mov edx, prompt_len
    int 0x80

    ; Read input
    mov eax, 3
    mov ebx, 0
    mov ecx, input_buffer
    mov edx, 20
    int 0x80
    mov esi, eax            ; number of bytes read

    ; Initialize variables
    mov edi, input_buffer   ; EDI is pointer
    xor eax, eax            ; EAX holds sum, init with 0

read_loop:
    cmp esi, 0
    je calculate_sum        ; Jump if end of string

    mov bl, [edi]           ; Get current character
    inc edi                 ; Move to next character
    dec esi                 ; Decrease the byte counter

    cmp bl, 0xA             ; Check for 10
    je calculate_sum

    ; Skip incorrect characters
    cmp bl, '0'
    jb read_loop
    cmp bl, '9'
    ja read_loop

    sub bl, '0'
    add eax, ebx

    jmp read_loop

calculate_sum:
    ; Convert EAX from int to string to print

    mov ebx, eax            ; Move sum to EBX for division
    mov ecx, sum_str + 11   ; End of output buffer
    mov byte [ecx], 0       ; End string
    dec ecx

    cmp ebx, 0
    jne convert_sum

    ; If sum is zero jump to end
    mov byte [ecx], '0'
    dec ecx
    jmp print_result

convert_sum:
    ; Convert the sum from integer to string
convert_loop:
    xor edx, edx
    mov eax, ebx
    mov ebx, 10
    div ebx                 ; EAX = EAX / 10, EDX = rest

    add dl, '0'             ; Digit to char
    mov [ecx], dl           ; Write digit char
    dec ecx

    mov ebx, eax            ; Update EBX with the quotient
    cmp ebx, 0
    jne convert_loop

print_result:
    ; Display the sum
    mov eax, 4
    mov ebx, 1
    mov edx, sum_str + 12   ; Calculate length of sum string
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

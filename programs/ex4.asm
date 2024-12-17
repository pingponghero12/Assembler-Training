section .data
    N equ 1000                          ; Define the maximum number (use 1000 for testing)
    message db "Prime numbers from 1 to ", 0
message_end:

section .bss
    primes resb N+1                     ; Allocate (N+1) bytes for the prime flags
    num_str resb 12                     ; Buffer to store string representation of numbers

section .text
    global _start

_start:
    ; Initialize the primes array
    mov ecx, N+1                        ; Number of bytes to clear
    mov edi, primes                     ; Point to primes array
    xor eax, eax                        ; Zero value to store
    rep stosb                           ; Set all bytes to 0 (potential primes)

    ; 0 and 1 are not primes
    mov byte [primes], 1                ; primes[0] = 1 (not prime)
    mov byte [primes + 1], 1            ; primes[1] = 1 (not prime)

    ; Implement Sieve of Eratosthenes
    mov ecx, 2                          ; Start from 2
sieve_loop:
    cmp ecx, N
    jg print_primes

    ; Check if current number is already marked as not prime
    mov al, [primes + ecx]
    cmp al, 0
    jne next_c

    ; Mark multiples of current number as not prime
    mov ebx, ecx                        ; EBX = current prime

    ; Start marking from ecx * ecx to optimize
    mov eax, ecx                        ; EAX = ECX
    mul ebx                             ; EAX = ECX * EBX
    mov edx, eax                        ; EDX = ECX * ECX
    cmp edx, N
    ja next_c                           ; If square is greater than N, skip

mark_multiples:
    mov byte [primes + edx], 1          ; Mark as not prime
    add edx, ebx                        ; EDX += ECX
    cmp edx, N
    jle mark_multiples

next_c:
    inc ecx
    jmp sieve_loop

print_primes:
    ; Print the message
    mov eax, 4                          ; sys_write
    mov ebx, 1                          ; stdout
    mov ecx, message
    mov edx, message_end - message      ; Length of message
    int 0x80

    ; Print the value of N
    mov eax, N
    call int_to_ascii_message
    mov eax, 4                          ; sys_write
    mov ebx, 1                          ; stdout
    mov ecx, esi                        ; ESI points to start of string
    mov edx, message_buffer + 12  ; Length of number string
    sub edx, esi
    int 0x80

    ; Print a newline
    mov eax, 4
    mov ebx, 1
    mov ecx, new_line
    mov edx, 1
    int 0x80

    ; Iterate through primes array and print primes
    mov ecx, 2                          ; Start from 2
print_loop:
    cmp ecx, N+1
    jge exit_program                    ; Exit if we've reached the end

    mov al, [primes + ecx]
    cmp al, 0                           ; If value is 0, it's a prime
    jne skip_print

    ; Convert number to string
    mov eax, ecx
    call int_to_ascii

    ; Print the number
    mov eax, 4                          ; sys_write
    mov ebx, 1                          ; stdout
    mov ecx, edi                        ; EDI points to start of string
    mov edx, num_str + 12         ; Length of number string
    sub edx, edi
    int 0x80

skip_print:
    inc ecx
    jmp print_loop

exit_program:
    ; Exit the program
    mov eax, 1                          ; sys_exit
    xor ebx, ebx
    int 0x80

; Subroutine: int_to_ascii_message
; Converts integer in EAX to ASCII string in message_buffer
; The result is stored starting at ESI
int_to_ascii_message:
    mov esi, message_buffer + 11        ; Point ESI to the end of the buffer
    mov byte [esi], 0                   ; Null-terminate the string
    dec esi

    mov ebx, 10                         ; Divisor for decimal conversion

    cmp eax, 0
    jne convert_loop_msg

    ; Handle zero case
    mov byte [esi], '0'
    dec esi
    jmp conversion_done_msg

convert_loop_msg:
    xor edx, edx
    div ebx                             ; Divide EAX by 10, quotient in EAX, remainder in EDX
    add dl, '0'                         ; Convert remainder to ASCII
    mov [esi], dl
    dec esi
    cmp eax, 0
    jne convert_loop_msg

conversion_done_msg:
    inc esi                             ; Adjust ESI to point to the start of the string
    ret

; Subroutine: int_to_ascii
; Converts the integer in EAX to ASCII string in num_str
; The result is stored starting at EDI
int_to_ascii:
    mov edi, num_str + 11               ; Point EDI to the end of the buffer
    mov byte [edi], 10                  ; Add newline character
    dec edi

    mov ebx, 10                         ; Divisor for decimal conversion

    cmp eax, 0
    jne convert_loop

    ; Handle zero case
    mov byte [edi], '0'
    dec edi
    jmp conversion_done

convert_loop:
    xor edx, edx
    div ebx                             ; Divide EAX by 10, quotient in EAX, remainder in EDX
    add dl, '0'                         ; Convert remainder to ASCII
    mov [edi], dl
    dec edi
    cmp eax, 0
    jne convert_loop

conversion_done:
    inc edi                             ; Adjust EDI to point to the start of the string
    ret

section .bss
    message_buffer resb 12              ; Buffer for N value in the message
    new_line resb 1                     ; Newline character

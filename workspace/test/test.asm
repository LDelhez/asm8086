


section .data
msg db 'Hello world!', 0x00

section .text
main:   mov bx, msg
        call print_bx_str
        ret

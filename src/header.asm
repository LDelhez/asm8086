
cpu 8086
bits 16

org  0x100


start:      call main
            mov bx, 0
            mov  ah, 0x4c
            int  0x21

print_bl_hex:
            push ax
            mov ah, 0x00
            int 0xF0
            pop ax
            ret

print_bx_hex:
            push ax
            mov ah, 0x01
            int 0xF0
            pop ax
            ret

print_bl_char:
            push ax
            mov ah, 0x02
            int 0xF0
            pop ax
            ret

print_bl_uint:
            push ax
            mov ah, 0x03
            int 0xF0
            pop ax
            ret

print_bx_uint:
            push ax
            mov ah, 0x04
            int 0xF0
            pop ax
            ret

print_bx_str:
            push ax
            mov ah, 0x05
            int 0xF0
            pop ax
            ret

put_al_char:
            push ax
            mov ah, 0x06
            int 0xF0
            pop ax
            ret

put_eol:
            push ax
            mov al, 0x0d
            call put_al_char
            mov al, 0x0a
            call put_al_char
            pop ax
            ret

print_question:
            push ax
            mov al, '?'
            call put_al_char
            mov al, ':'
            call put_al_char
            mov al, ' '
            call put_al_char
            pop ax
            ret

print_al_char:
            xchg al, bl
            call print_bl_char
            xchg al, bl
            ret

print_al_hex:
            xchg ax, bx
            call print_bl_hex
            xchg ax, bx
            ret

print_ax_hex:
            push bx
            mov bx, ax
            call print_bx_hex
            pop bx
            ret

lshift_ax_4:
            push bx
            mov bx, ax
            mov ah, 0x07
            int 0xF0
            mov ax, bx
            pop bx
            ret

invalid_hex:
            mov al, '!'
            call print_al_char
            mov bx, 0
            mov  ah, 0x4c
            int  0x21

numerize_al:
            cmp al, 0x30
            jl invalid_hex
            cmp al, 0x39
            jle number
            cmp al, 0x40
            jle invalid_hex
            cmp al, 0x46
            jle uppercase
            cmp al, 61
            jle invalid_hex
            cmp al, 0x66
            jle lowercase
            jmp invalid_hex
number:     sub al, 0x30
            ret
lowercase:  sub al, 0x20
uppercase:  sub al, 0x41
            add al, 0x0a
            ret

decode_to_ax:
            push cx
            push dx
            push si
            add sp, 10
            mov si, 0x00
            mov dx, 0x00
get_char:   pop ax
            mov ah, 0x00
            call numerize_al
            cmp si, 0x00
            je end_shift
            cmp si, 0x04
            jge invalid_hex
            mov cx, si
shift_ax:   call lshift_ax_4
            loop shift_ax
end_shift:  add dx, ax
            inc si
            cmp bx, sp
            jne get_char
            sub sp, si
            sub sp, si
            sub sp, 10
            mov ax, dx
            pop si
            pop dx
            pop cx
            ret

read_ax_hex:
            call print_question
            push bx
            mov bx, sp
            mov ah, 0x01
wait_char:  int 0x21
            call put_al_char
            cmp al, 0x08
            jne not_back
back:       cmp bx, sp
            je wait_char
            add sp, 2
            jmp wait_char
not_back:   push ax
            cmp al, 0x0d
            jne wait_char
            call put_eol
            call decode_to_ax
            mov sp, bx
            pop bx
            ret

read_al_hex:
            push ax
            push bx
            call read_ax_hex
            cmp ax, 0xff
            jg invalid_hex
            mov bl, al
            pop ax
            mov al, bl
            pop bx
            ret

read_bl_hex:
            push ax
            call read_al_hex
            mov bl, al
            pop ax
            ret

read_bx_hex:
            push ax
            call read_ax_hex
            mov bx, ax
            pop ax
            ret
            

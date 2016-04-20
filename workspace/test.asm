

section .data
msg  db 'Entrez deux nombres...', 0x00

section .text
main: mov bx, msg
      call print_bx_str
      call read_ax_hex
      call read_bx_hex
      add ax, bx
      call print_ax_hex
      ret

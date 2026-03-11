; BANKTEC Harold Madriz Cerdas

data segment
menu_title    db "---------------------------$"
menu_line1    db "BANKTEC                    $"
menu_line2    db "---------------------------$"
Crear         db "1.Crear cuenta             $"
Deposito      db "2.Depositar dinero         $"
Retiro        db "3.Retirar dinero           $"
Consulta      db "4.Consultar saldo          $"
Reporte       db "5.Mostrar reporte general  $"
Desactivar    db "6.Desactivar cuenta        $"
Salida        db "7.Salir                    $"
menu_line3  db "---------------------------$"
prompt      db "Seleccione una opcion: $"
newline     db 0Dh, 0Ah, "$"
msg_invalid db "Opcion invalida. Intente de nuevo.", 0Dh, 0Ah, "$"
msg_salir   db "Saliendo del sistema...", 0Dh, 0Ah, "$"
msg_crear   db ">>Crear cuenta seleccionada.", 0Dh, 0Ah, "$"
msg_dep     db ">>Depositar dinero seleccionado.", 0Dh, 0Ah, "$"
msg_ret     db ">>Retirar dinero seleccionado.", 0Dh, 0Ah, "$"
msg_saldo   db ">>Consultar saldo seleccionado.", 0Dh, 0Ah, "$"
msg_rep     db ">>Mostrar reporte general.", 0Dh, 0Ah, "$"
msg_desac   db ">>Desactivar cuenta seleccionada.", 0Dh, 0Ah, "$"
ends

stack segment
dw 128 dup(0)
ends

code segment
start:
mov ax, data
mov ds, ax
mov es, ax

menu_loop:
; Limpiar pantalla
mov ax, 0600h
mov bh, 07h
mov cx, 0000h
mov dx, 184Fh
int 10h

; Posicionar cursor en fila 2, col 5
mov ah, 02h
mov bh, 0
mov dh, 2 ;Fila
mov dl, 5 ;Columna
int 10h

; Imprimir menú línea por línea
lea dx, menu_title
call print_str

mov dh, 3
mov dl, 5 ;Columna
mov ah, 02h
int 10h
lea dx, menu_line1
call print_str ;llama a mostrar en pantalla
;Lo mismo para cada fila
mov dh, 4
mov dl, 5
mov ah, 02h
int 10h
lea dx, menu_line2
call print_str

mov dh, 5
mov dl, 5
mov ah, 02h
int 10h
lea dx, Crear
call print_str

mov dh, 6
mov dl, 5
mov ah, 02h
int 10h
lea dx, Deposito
call print_str

mov dh, 7
mov dl, 5
mov ah, 02h
int 10h
lea dx, Retiro
call print_str

mov dh, 8
mov dl, 5
mov ah, 02h
int 10h
lea dx, Consulta
call print_str

mov dh, 9
mov dl, 5
mov ah, 02h
int 10h
lea dx, Reporte
call print_str

mov dh, 10
mov dl, 5
mov ah, 02h
int 10h
lea dx, Desactivar
call print_str

mov dh, 11
mov dl, 5
mov ah, 02h
int 10h
lea dx, Salida
call print_str

mov dh, 12
mov dl, 5
mov ah, 02h
int 10h
lea dx, menu_line3
call print_str

mov dh, 14
mov dl, 5
mov ah, 02h
int 10h
lea dx, prompt
call print_str

; Leer tecla del usuario
mov ah, 01h          ; lee caracter
int 21h              ; AL = carácter leido

cmp al, '1'
je opcion1
cmp al, '2'
je opcion2
cmp al, '3'
je opcion3
cmp al, '4'
je opcion4
cmp al, '5'
je opcion5
cmp al, '6'
je opcion6
cmp al, '7'
je opcion7

; Opcion inválida
mov dh, 16
mov dl, 5
mov ah, 02h
int 10h
lea dx, msg_invalid
call print_str
mov ah, 01h
int 21h
jmp menu_loop

opcion1: ;Crear nueva cuenta
mov dh, 16
mov dl, 5
mov ah, 02h
int 10h
lea dx, msg_crear
call print_str
mov ah, 01h
int 21h
jmp menu_loop

opcion2: ;Depositar dinero
mov dh, 16
mov dl, 5
mov ah, 02h
int 10h
lea dx, msg_dep
call print_str
mov ah, 01h
int 21h
jmp menu_loop

opcion3: ;Retirar dinero
mov dh, 16
mov dl, 5
mov ah, 02h
int 10h
lea dx, msg_ret
call print_str
mov ah, 01h
int 21h
jmp menu_loop

opcion4: ;Consultar saldo
mov dh, 16
mov dl, 5
mov ah, 02h
int 10h
lea dx, msg_saldo
call print_str
mov ah, 01h
int 21h
jmp menu_loop

opcion5: ;Mostrar reporte general
mov dh, 16
mov dl, 5
mov ah, 02h
int 10h
lea dx, msg_rep
call print_str
mov ah, 01h
int 21h
jmp menu_loop

opcion6: ;Desactivar cuenta
mov dh, 16
mov dl, 5
mov ah, 02h
int 10h
lea dx, msg_desac
call print_str
mov ah, 01h
int 21h
jmp menu_loop

opcion7: ;muesta mensaje de Salir
mov dh, 16
mov dl, 5
mov ah, 02h
int 10h
lea dx, msg_salir
call print_str
mov ah, 01h
int 21h
jmp salir

;imprimir cadena en DS:DX --
print_str:
mov ah, 09h
int 21h
ret

salir:
mov ax, 4C00h
int 21h

ends
end start




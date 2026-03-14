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
    menu_line3    db "---------------------------$"
    prompt        db "Seleccione una opcion: $"
    newline       db 0Dh, 0Ah, "$"
    msg_invalid   db "Opcion invalida. Intente de nuevo.", 0Dh, 0Ah, "$"
    msg_salir     db "Saliendo del sistema...", 0Dh, 0Ah, "$"
    msg_crear     db ">>Crear cuenta seleccionada.", 0Dh, 0Ah, "$"
    msg_dep       db ">>Depositar dinero seleccionado.", 0Dh, 0Ah, "$"
    msg_ret       db ">>Retirar dinero seleccionado.", 0Dh, 0Ah, "$"
    msg_saldo     db ">>Consultar saldo seleccionado.", 0Dh, 0Ah, "$"
    msg_rep       db ">>Mostrar reporte general.", 0Dh, 0Ah, "$"
    msg_desac     db ">>Desactivar cuenta seleccionada.", 0Dh, 0Ah, "$"
    
    
    
    
    new_nombre      db "Digite su nombre:  $"
    maxcuentas_ex db "El numero de cuentas ha alcanzado su límite $"
    
    
    
    
    
    ;------CUENTAS------;
    Ncuentas        db 300 dup(0)  ; arreglo 10 cuentas x 30 bytes
    total_cuentas   db 0           ; contador de cuentas creadas
    
    OFF_NUM     equ 0   ; offset numero de cuenta
    OFF_NOMBRE  equ 1   ; offset nombre titular
    OFF_SALDO_L equ 21  ; offset saldo parte baja
    OFF_SALDO_H equ 25  ; offset saldo parte alta
    OFF_ESTADO   equ 29  ; offset flags (bit0=estado)
    TAM_CUENTA  equ 30  ; tama?o en bytes por cuenta

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
        
        call limpiar_pantalla         
        call posicionar ;Posicionar cursor en fila 2, col 5
        
        ; Posicionar cursor en fila 2, col 5
        mov ah, 02h
        mov bh, 0
        mov dh, 2 ;Fila
        mov dl, 5 ;Columna
        int 10h
        
        ; Imprimir menu linea por linea
        lea dx, menu_title
        call print_str
        
        mov dh, 3 ;Fila
        mov dl, 5 ;Columna
        mov ah, 02h
        int 10h
        lea dx, menu_line1
        call print_str ;llama a mostrar en pantalla 
        
        ;--------Lo mismo para cada fila--------
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
        int 21h              ; AL = car?cter leido
        
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
        
        ; Opcion inv?lida
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
    
        
       
        cmp total_cuentas, 10 ;verifica si se alcanzó el máximo de cuentas
        JAE cuentasfull:  
    
    
    
        call limpiar_pantalla 
        call posicionar 
        mov dh, 2
        mov dl, 5
        mov ah, 02h
        int 10h
        lea dx, msg_crear
        call print_str
        
        mov dh, 3
        mov dl, 5
        mov ah, 02h
        int 10h
        lea dx, new_nombre
        call print_str
        
        ;Configurar el buffer ANTES de leer
        lea bx, Ncuentas
        add bx, OFF_NOMBRE
        mov byte ptr [bx], 20    ; primer byte = máximo de caracteres
        
        
        ;Apuntar DX al buffer ya configurado
        lea dx, Ncuentas
        add dx, OFF_NOMBRE
        mov ah, 0Ah
        int 21h
    
        lea dx, newline
        call print_str
        
        
        inc total_cuentas ;incrementa las cuentas creadas
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
    
    
    cuentasfull: ;Mensaje de que se han creado el máximo de cuentas
        call limpiar_pantalla
        call posicionar
        mov dh, 2
        mov dl, 5
        mov ah, 02h
        int 10h
        lea dx, maxcuentas_ex
        call print_str
        mov ah, 01h
        int 21h
        jmp menu_loop            
    
    
    
    
        
    ;imprimir cadena en DS:DX --
    print_str:
        mov ah, 09h
        int 21h
        ret
    limpiar_pantalla:
        ;Limpiar pantalla
        mov ax, 0600h
        mov bh, 07h
        mov cx, 0000h
        mov dx, 184Fh
        int 10h
        ret
     posicionar:   
        ;Posicionar cursor en fila 2, col 5
        mov ah, 02h
        mov bh, 0
        mov dh, 2 ;Fila
        mov dl, 5 ;Columna
        int 10h
        ret
                
    salir:
        mov ax, 4C00h
        int 21h


ends




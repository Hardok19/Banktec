; =============================================================================
; INSTITUTO TECNOLÓGICO DE COSTA RICA
; Escuela de Ingeniería en Computadores
; Paradigmas de Programación (CE1106) - Primer Semestre 2026
; =============================================================================
; Proyecto  : BankTec
; Descripción: Sistema de gestión de cuentas bancarias en Ensamblador 8086.
;              Permite crear cuentas, depositar, retirar, consultar saldo,
;              generar reportes y desactivar cuentas. Soporta hasta 10 cuentas
;              con saldo representado en entero + 4 decimales simulados.
; -----------------------------------------------------------------------------
; Autor(es) : Harold Madriz Cerdas
; Fecha     : 19/03/2026
; -----------------------------------------------------------------------------
; Entorno   : : emu8086 - x86 16 bits (8086)
; Archivo   : BankTec.asm
; =============================================================================

data segment
    
        ;------CUENTAS------;
    Ncuentas        db 290 dup(0)  ; arreglo 10 cuentas x 29 bytes
    total_cuentas   db 0           ; contador de cuentas creadas
    
    OFF_NUM     equ 0   ; offset numero de cuenta
    OFF_NOMBRE  equ 1   ; offset nombre titular
    OFF_SALDO_D equ 24  ; offset saldo decimales
    OFF_SALDO_E equ 26  ;offset saldo entero 
    OFF_ESTADO   equ 28  ; offset estado (bit0=desactivado)
    TAM_CUENTA  equ 29  ; tama?o en bytes por cuenta
    
    
    
    

    
    saldobancototal dd 0   ; 32 bits manuales 
    
 
    temp dw ? ;valor temporal para bucles
    
    
    numero_mostrado db "0", "$" ;buffer para mostrar numeros
    
    cuentas_inactivas db 0 ;contador cuentas inactivas
    cuentas_activas db 0 ; contador cuentas activas
    
    buffer db 20, 0, 20 dup(0)
    
    
    
    
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
    msg_ncuenta_asig db "Su numero de cuenta es: $"
    
    msg_decimales? db "Desea ingresar decimales? Y/N $"
    msg_decimales db "Ingrese el monto de decimales (max 9999) $"
    
    msg_enteros db "Ingrese el monto $"
    
    msg_notmonto db "Monto inválido $"
    
    msg_depositado db "Saldo anadido correctamente $"
    
    
    

    msg_susaldo db "Su saldo es: $"
    msg_saldoinv db "Valor introducido es inválido $"
    
    
    msg_fondos    db "Fondos insuficientes para realizar el retiro $"
    msg_retirado  db "Retiro realizado correctamente $"
    
    msg_titular db "Titular: $"
    
    
    
    msg_activas db "Cuentas activas: $"
    msg_inactivas db "Cuentas inactivas: $"
    msg_saldo_total db "Saldo total del banco: $"
    msg_cuentamayor db "La cuenta con mayor saldo es: $"
    msg_cuentamenor db "La cuenta con menor saldo es: $"  
    

    msg_desactive db "Digite el numero de cuenta a desactivar: $"
    msg_desactivada db "Cuenta desactivada $"
    msg_ya_desactivada db "No se puede desactivar cuentas inactivas: $"
    
    
    
    
    msg_askNcuenta db "Digite su numero de cuenta: $"
    msg_nocuentas db "No se ha creado ninguna cuenta $"
    
    
    msg_invalidC db "Numero de cuenta inválido: $"
    msg_noexiste db "Esta cuenta no existe $"

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
        lea dx, menu_line2 ;separador ---
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
        lea dx, menu_line3 ;separador ---
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
        jae cuentasfull  
        
        ; Calcular offset de la cuenta actual
        mov al, total_cuentas   ; AL = número de cuenta actual
        mov bl, TAM_CUENTA      ; BL = 30
        mul bl                  ; AX = total_cuentas * 30
        
        push ax                 ; <-- GUARDAR el offset
    
        ; Apuntar BX al inicio de esta cuenta
        lea bx, Ncuentas
        add bx, ax              ; BX = Ncuentas + (total_cuentas * 30)
        
        call limpiar_pantalla 
        call posicionar
        
         

        lea dx, msg_crear
        call print_str
        
        mov dh, 3
        mov dl, 5
        mov ah, 02h
        int 10h
        lea dx, new_nombre
        call print_str
        
        
        pop ax                  ; <-- RECUPERAR el offset 
        
        
        ; Asignar número de cuenta (total_cuentas + 1)
        lea bx, Ncuentas
        add bx, ax
        mov cl, total_cuentas
        inc cl                  ; cl = 1, 2, 3...
        mov byte ptr [bx + OFF_NUM], cl
        
        ; Configurar buffer para esta cuenta específica
        lea bx, Ncuentas
        add bx, ax
        mov byte ptr [bx + OFF_NOMBRE],     20  ; máx caracteres
        mov byte ptr [bx + OFF_NOMBRE + 1],  0  ; bytes leídos = 0
        
        ; Saldo inicial = 0
        mov word ptr [bx + OFF_SALDO_D], 0
        mov word ptr [bx + OFF_SALDO_E], 0
        
        ;Activar la cuenta
        add byte ptr [bx + OFF_ESTADO], 1
        
        ;DX apunta al buffer
        lea dx, Ncuentas
        add dx, ax
        add dx, OFF_NOMBRE      
        mov ah, 0Ah
        int 21h                 ;espera el input 
        
        
            
         
        mov al, [bx + OFF_NOMBRE + 1]   ; al = longitud del nombre
        mov ah, 0                        ; limpiar ah 
        mov si, ax                       ; pasar a registro de índice válido
        mov [bx + OFF_NOMBRE + 2 + si], "$"  ; pone $ después del ultimo caracter
  
          

        
        inc total_cuentas
        inc cuentas_activas
        
        
        ; --- Mostrar número de cuenta asignado ---
        mov dh, 6
        mov dl, 5
        mov ah, 02h
        int 10h
        
        lea dx, msg_ncuenta_asig    ; "Su numero de cuenta es: "
        call print_str
        
        mov al, [bx + OFF_NUM]      ; AL = número de cuenta (1..10)
        add al, '0'                 ; convertir a ASCII
        mov numero_mostrado, al     
        
        lea dx, numero_mostrado
        call print_str
        
        mov ah, 01h                 ; esperar tecla antes de volver
        int 21h
        
         
        

        jmp menu_loop
    
    opcion2: ;Depositar dinero
        call limpiar_pantalla
        call posicionar
        lea dx, msg_dep
        call print_str
        
        cmp total_cuentas, 0
        je nocuentas 
        
        mov dh, 4
        mov dl, 5
        mov ah, 02h
        int 10h
        lea dx, msg_askNcuenta
        call print_str
        
        
        mov ah, 0Ah
        lea dx, buffer    ; Buffer para leer string
        int 21h
        
         

        call ascii_to_decimal  ;devuelve ax como numero
        
        cmp ax, 0
        jle cuentainv   ;si el numero es menor a las cuentas posibles error
        
          
        cmp ax, 10
        jg cuentainv    ;si el numero es mayor a las cuentas posibles error
        
        cmp total_cuentas, al  ;si el numero podria ser una cuenta pero no existe error 
        jl noexiste 
        

        mov bl, TAM_CUENTA
        mul bl                  ; AX = índice * 29
        mov temp, ax         ;se mueve a temp para usar el indice des´pues
        
         
        
        sub temp, TAM_CUENTA   ;se quitan el tamaño para empezar desde el ínidice 0
        mov bx, temp

        
        cmp byte ptr [bx + OFF_ESTADO], 0  ;verifica si está desactivada
        je desactivada                     ;si desactivada(0) error
         

         
        call limpiar_pantalla
        call posicionar
        
 
        
        lea dx, msg_decimales? ;pregunta al usuario si desea ingresar decimales
        call print_str
        
        
        ; Leer tecla del usuario
        mov ah, 01h          ; lee caracter
        int 21h              ; AL = car?cter leido
           
        cmp al, 'y'        ;revisa la respuesta del usuario 
        je suma_decimales
        cmp al, 'n'
        je suma_enteros  
        
        
        ;Opcion inv?lida
        mov dh, 16
        mov dl, 5
        mov ah, 02h
        int 10h
        lea dx, msg_invalid
        call print_str
        mov ah, 01h
        int 21h
        jmp menu_loop
        
        
        
        suma_decimales:
            call limpiar_pantalla
            call posicionar
            
            lea dx, msg_decimales
            call print_str
            mov ah, 0Ah
            lea dx, buffer    ; Buffer para leer string
            int 21h
             

             
            call ascii_to_decimal
            
            cmp ax, 9999
            jg saldo_inmválido 
            cmp ax, 0
            jl saldo_inmválido
            
            mov bx, temp
            ; sumar decimales
            add word ptr [bx + OFF_SALDO_D], ax
            add word ptr [saldobancototal], ax
            
            cmp word ptr [saldobancototal], 10000
            jl continue
            
            inc word ptr [saldobancototal + 2], 1
            sub word ptr [saldobancototal], 10000

            
            add word ptr [saldobancototal + 2], 1
            
            continue:                                    
                ; si >= 10000 ? ajustar
                cmp word ptr [bx + OFF_SALDO_D], 10000   ;si los valores de los decimales 
                jl suma_enteros                         ;llegan a 9999 suma un entero y resta decimales
                
                 
                sub word ptr [bx + OFF_SALDO_D], 10000
                inc word ptr [bx + OFF_SALDO_E]

            

            
              
               
        
        
        suma_enteros:
            call limpiar_pantalla
            call posicionar
            
            lea dx, msg_enteros
            call print_str
            mov ah, 0Ah
            lea dx, buffer    ; Buffer para leer string
            int 21h
            

            call ascii_to_decimal
             
            mov bx, temp 
            ; sumar enteros
            add word ptr [bx + OFF_SALDO_E], ax
            add word ptr [saldobancototal + 2], ax
            

            
        
        saldo_depositado:
            mov dh, 7
            mov dl, 12
            mov ah, 02h
            int 10h 
            
            lea dx, msg_depositado
            call print_str
            mov ah, 01h
            int 21h
            jmp menu_loop 

       

    opcion3: ;Retirar dinero
        call limpiar_pantalla
        call posicionar
        lea dx, msg_ret
        call print_str
        
        cmp total_cuentas, 0
        je nocuentas 
        
        mov dh, 4
        mov dl, 5
        mov ah, 02h
        int 10h
        lea dx, msg_askNcuenta
        call print_str
        
        mov ah, 0Ah
        lea dx, buffer
        int 21h
        
        call ascii_to_decimal  ;devuelve ax como numero
        
        cmp ax, 0
        jle cuentainv
        
        cmp ax, 10
        jg cuentainv
        
        cmp total_cuentas, al
        jl noexiste 
        
        mov bl, TAM_CUENTA
        mul bl                  ; AX = índice * 29
        
        mov temp, ax
        sub temp, TAM_CUENTA    ; índice base 0
        mov bx, temp
        
        cmp byte ptr [bx + OFF_ESTADO], 0
        je desactivada
        
        call limpiar_pantalla
        call posicionar
        
        lea dx, msg_decimales?
        call print_str
        
        mov ah, 01h
        int 21h
           
        cmp al, 'y'
        je resta_decimales
        cmp al, 'n'
        je resta_enteros  
        
        mov dh, 16
        mov dl, 5
        mov ah, 02h
        int 10h
        lea dx, msg_invalid
        call print_str
        mov ah, 01h
        int 21h
        jmp menu_loop
        
        
        resta_decimales:
            call limpiar_pantalla
            call posicionar
            
            lea dx, msg_decimales
            call print_str
            mov ah, 0Ah
            lea dx, buffer
            int 21h
            
            call ascii_to_decimal
            
            cmp ax, 9999
            jg saldo_inmválido 
            cmp ax, 0
            jl saldo_inmválido
            
            ; Guardar el monto de decimales a retirar en SI
            mov si, ax
            
            mov bx, temp
            
            ; Verificar si hay suficiente saldo (enteros + decimales combinados)
            ; Comparar enteros primero
            mov ax, word ptr [bx + OFF_SALDO_E]
            cmp ax, 0
            jg puede_restar_dec     ; Si hay enteros, siempre puede cubrir decimales
            
            ; Si enteros = 0, verificar que decimales del saldo >= monto a retirar
            mov ax, word ptr [bx + OFF_SALDO_D]
            cmp ax, si
            jl fondos_insuficientes
            
        puede_restar_dec:
            mov bx, temp
            
            ; Restar decimales
            mov ax, word ptr [bx + OFF_SALDO_D]
            sub ax, si
            
            ; Si el resultado es negativo (hubo borrow), pedir prestado al entero
            jnc decimales_ok        ; sin carry = resultado >= 0, OK
            
            ; Resultado negativo: restar 1 al entero y sumar 10000 a decimales
            cmp word ptr [bx + OFF_SALDO_E], 0
            je fondos_insuficientes ; No hay enteros para pedir prestado
            
            add ax, 10000           ; compensar el "borrow": resultado + 10000
            dec word ptr [bx + OFF_SALDO_E]
            
            ; También ajustar saldo total del banco
            dec word ptr [saldobancototal + 2]
            add word ptr [saldobancototal], 10000
            
        decimales_ok:
            mov word ptr [bx + OFF_SALDO_D], ax
            
            ; Restar decimales del saldo total del banco
            sub word ptr [saldobancototal], si
            jnc banco_dec_ok
            ; borrow en banco también
            dec word ptr [saldobancototal + 2]
            add word ptr [saldobancototal], 10000
            sub word ptr [saldobancototal], si  ; restar de nuevo con el ajuste
            
        banco_dec_ok:
            ; Continua a preguntar enteros
            
        
        resta_enteros:
            call limpiar_pantalla
            call posicionar
            
            lea dx, msg_enteros
            call print_str
            mov ah, 0Ah
            lea dx, buffer
            int 21h
            
            call ascii_to_decimal
            
            ; Verificar que no sea negativo
            cmp ax, 0
            jl saldo_inmválido
            
            ; Verificar que haya suficiente saldo entero
            mov bx, temp
            mov si, ax              ; SI = monto entero a retirar
            
            mov ax, word ptr [bx + OFF_SALDO_E]
            cmp ax, si
            jl fondos_insuficientes ; saldo entero < monto a retirar
            
            ; Restar enteros
            sub ax, si
            mov word ptr [bx + OFF_SALDO_E], ax
            
            ; Restar del saldo total del banco
            sub word ptr [saldobancototal + 2], si
            
            jmp retiro_exitoso
            
            
        fondos_insuficientes:
            mov dh, 7
            mov dl, 12
            mov ah, 02h
            int 10h
            lea dx, msg_fondos      ; necesitas agregar este mensaje al data segment
            call print_str
            mov ah, 01h
            int 21h
            jmp menu_loop
            
        retiro_exitoso:
            mov dh, 7
            mov dl, 12
            mov ah, 02h
            int 10h 
            
            lea dx, msg_retirado    ; necesitas agregar este mensaje al data segment
            call print_str
            mov ah, 01h
            int 21h
            jmp menu_loop

    opcion4: ;Consultar saldo
        call limpiar_pantalla
        call posicionar
        lea dx, msg_saldo          ; ">>Consultar saldo seleccionado."
        call print_str
        
        cmp total_cuentas, 0
        je nocuentas
        
        mov dh, 4
        mov dl, 5
        mov ah, 02h
        int 10h
        lea dx, msg_askNcuenta     ; "Digite su numero de cuenta:"
        call print_str
        
        mov ah, 0Ah
        lea dx, buffer
        int 21h
        
        call ascii_to_decimal
        
        cmp ax, 0
        jle cuentainv
        
        cmp ax, 10
        jg cuentainv
        
        cmp total_cuentas, al
        jl noexiste 
        
        mov bl, TAM_CUENTA
        mul bl                      ; AX = índice * 29
        
        mov temp, ax
        sub temp, TAM_CUENTA        ; índice base 0
        mov bx, temp
        
        cmp byte ptr [bx + OFF_ESTADO], 0
        je desactivada
        
        ; --- Mostrar nombre del titular ---
        mov dh, 6
        mov dl, 5
        mov ah, 02h
        int 10h
        
        lea dx, msg_titular          
                                    
        call print_str
        
        lea dx, [bx + OFF_NOMBRE + 2]   ; saltar byte de max y byte de longitud
        call print_str
        
        ; --- Mostrar etiqueta de saldo ---
        mov dh, 7
        mov dl, 5
        mov ah, 02h
        int 10h
        
        lea dx, msg_susaldo         ; "Su saldo es:"
        call print_str
        
        ; --- Imprimir parte entera ---
        mov ax, word ptr [bx + OFF_SALDO_E]
        call print_uint16
        
        ; --- Imprimir punto decimal ---
        mov ah, 02h
        mov dl, '.'
        int 21h
        
        ; --- Imprimir parte decimal (siempre 4 dígitos con ceros a la izquierda) ---
        mov ax, word ptr [bx + OFF_SALDO_D]
        call print_4dec
        
        ; --- Espera tecla y volver al menú ---
        mov ah, 01h
        int 21h
        jmp menu_loop
    
    opcion5: ;Mostrar reporte general
        call limpiar_pantalla 
        call posicionar

        lea dx, msg_rep
        call print_str
        
        mov dl, 5 ;posiciona el cursor abajo del título
        mov dh, 4
        mov ah, 02h
        int 10h
        
        
        lea dx, msg_activas ;mensaje de cuentas activas
        call print_str 
        
        
        
        
        mov al, [cuentas_activas]  
        add al, 30h              ;convierte a ASCII el numero de cuentas activas
        mov numero_mostrado, al
        
        
        
        lea dx, numero_mostrado  ;cuentas activas
        call print_str
        
        
        mov dl, 5
        mov dh, 5
        mov ah, 02h
        int 10h
        
        
        lea dx, msg_inactivas  ;mensaje de cuentas inaactivas
        call print_str 
        
        
        
        
        mov al, [cuentas_inactivas]
        add al, 30h
        mov numero_mostrado, al
        
        
        
        lea dx, numero_mostrado   ;cuentas inactivas
        call print_str
        
    
        mov dl, 5
        mov dh, 6
        mov ah, 02h
        int 10h
        
        
        ;mostrar saldo del banco
        lea dx, msg_saldo_total
        call print_str
        
        ; imprimir valor
        call print_saldo_total
        
 
        
        
        mov dl, 5
        mov dh, 8
        mov ah, 02h
        int 10h
        
        lea dx, msg_cuentamayor
        call print_str
        
        call cuentamayor
        
        mov bx, temp        ;se trae el indice de temp a bx
        
        
        lea dx, [bx + OFF_NOMBRE + 2]
        call print_str
        
        
        
        mov dl, 5 
        mov dh, 10
        mov ah, 02h
        int 10h        
        lea dx, msg_cuentamenor
        call print_str
        
        
        call cuentamenor
        
        mov bx, temp
        
        
        lea dx, [bx + OFF_NOMBRE + 2]
        call print_str
        
        
        

        mov ah, 01h
        int 21h
        jmp menu_loop

    
    opcion6: ;Desactivar cuenta
        call limpiar_pantalla 
        call posicionar
        lea dx, msg_desac
        call print_str
        
        cmp total_cuentas, 0
        je nocuentas 
        
        mov dh, 4
        mov dl, 5
        mov ah, 02h
        int 10h
        lea dx, msg_askNcuenta
        call print_str
        

        mov ah, 0Ah
        lea dx, buffer    ; Buffer para leer string
        int 21h
        
        call ascii_to_decimal  ;devuelve ax como numero
        
        cmp ax, 0
        jle cuentainv   ;si el numero es menor a las cuentas posibles error
        
          
        cmp ax, 10
        jg cuentainv    ;si el numero es mayor a las cuentas posibles error
        
        cmp total_cuentas, al  ;si el numero podria ser una cuenta pero no existe error 
        jl noexiste 
        

        mov bl, TAM_CUENTA
        mul bl                  ; AX = índice * 29
        

        
        mov temp, ax         ;se mueve a temp para usar el indice des´pues
        
         
        
        sub temp, TAM_CUENTA   ;se quitan el tamaño para empezar desde el ínidice 0
       
        mov bx, temp
        
        cmp byte ptr [bx + OFF_ESTADO], 0
        je ya_desactivada
        
        
        mov byte ptr [bx + OFF_ESTADO], 0  ;Desactiva la cuenta
        
        add cuentas_inactivas, 1
        
        sub cuentas_activas, 1   ;modifica contadores de cuentas inactivas y activas
        
        
        call desactivada
        
        ya_desactivada:
            mov dh, 16
            mov dl, 5
            mov ah, 02h
            int 10h
            lea dx, msg_ya_desactivada
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
        jmp salir
    
    cuentainv:
        mov dh, 7
        mov dl, 12
        mov ah, 02h
        int 10h 
            
        lea dx, msg_invalidC
        call print_str
        mov ah, 01h
        int 21h
        jmp menu_loop
    saldo_inmválido:
        mov dh, 7
        mov dl, 12
        mov ah, 02h
        int 10h 
            
        lea dx, msg_saldoinv
        call print_str
        mov ah, 01h
        int 21h
        jmp menu_loop        
        
    nocuentas:
        mov dh, 7
        mov dl, 12
        mov ah, 02h
        int 10h
            
        lea dx, msg_nocuentas
        call print_str
        mov ah, 01h
        int 21h
        jmp menu_loop
        
    desactivada:
        mov dh, 7
        mov dl, 12
        mov ah, 02h
        int 10h
        lea dx, msg_desactivada
        call print_str
        mov ah, 01h
        int 21h
        jmp menu_loop
    noexiste:
        mov dh, 7
        mov dl, 12
        mov ah, 02h
        int 10h
        lea dx, msg_noexiste
        call print_str
        mov ah, 01h
        int 21h
        jmp menu_loop
            
            
            
            
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
    
    
    print_uint16: 
        push ax
        push bx
        push cx
        push dx
    
        mov cx, 0
        mov bx, 10

    convert:
        xor dx, dx
        div bx
        push dx
        inc cx
        test ax, ax
        jnz convert
    
    print:
        pop dx
        add dl, '0'
        mov ah, 02h
        int 21h
        loop print
    
        pop dx
        pop cx
        pop bx
        pop ax
        ret

    
    print_4dec: 
        push ax
        push bx
        push cx
        push dx
    
        mov bx, 10
        mov cx, 4

    ; guardar dígitos (incluyendo ceros)
    extract:
        xor dx, dx
        div bx
        push dx
        loop extract
    
        mov cx, 4
    
    print_dec:
        pop dx
        add dl, '0'
        mov ah, 02h
        int 21h
        loop print_dec
    
        pop dx
        pop cx
        pop bx
        pop ax
        ret


    print_saldo_total:
        push ax
        push dx
    
        ; entero
        mov ax, word ptr [saldobancototal+2]
        call print_uint16
    
        ; punto decimal
        mov ah, 02h
        mov dl, '.'
        int 21h
    
        ; decimales
        mov ax, word ptr [saldobancototal]
        call print_4dec
    
        pop dx
        pop ax
        ret

    

    
    ascii_to_decimal:
        ; Entrada: DS:DX = buffer con el string (formato DOS Ah)
        ; Salida: AX = valor decimal convertido
        
        xor ax, ax          ; AX = 0 (acumulador resultado)
        mov si, dx          ; SI = dirección del buffer
        add si, 2           ; Salta longitud y contador en buffer DOS
        mov cx, 10          ; Multiplicador (base 10)
        
    input_loop:
        mov bl, [si]        ; Lee siguiente carácter
        
        cmp bl, 0dh         
        je end_input
        cmp bl, 0ah         
        je end_input
        cmp bl, 0           
        je end_input
        
        ; Verifica que sea dígito
        cmp bl, '0'
        jl end_input
        cmp bl, '9'
        jg end_input
        
        sub bl, '0'         ; Convierte ASCII a número
        
        ; resultado = resultado * 10 + dígito
        mov bx, ax          ; Guarda AX en BX temporalmente
        mov ax, cx          ; AX = 10
        mul bx              ; DX:AX = BX * 10
        mov bx, 0
        mov bl, [si]        ; Vuelve a cargar el carácter
        sub bl, '0'         ; Convierte a número
        add ax, bx          ; Suma el dígito
        
        inc si              ; Siguiente carácter
        jmp input_loop 
        
    end_input:
        ret


    
    
    
    cuentamayor:     ;revisa que cuenta tiene más saldo
        mov cx, 0
        mov cl, total_cuentas
        cmp cl, 0
        je fin_cuentamayor
        
        mov bx, 0                    ; BX = puntero a cuenta actual
        mov temp, 0                  ; temp = puntero a mayor cuenta
        
        ; Cargar primera como máximo
        mov ax, [bx + OFF_SALDO_E]
        mov dx, [bx + OFF_SALDO_D]
        
    mayorloop:
        ; Pasar a siguiente
        add bx, TAM_CUENTA             ; Siguiente cuenta (TAM_CUENTA = 29)
        loop mayorloop_chk
        jmp fin_cuentamayor
        
    mayorloop_chk:
        ; Comparar entero
        mov si, [bx + OFF_SALDO_E]
        cmp si, ax
        jg es_mayor            ; Si es MAYOR
        jl mayorloop            ; Si es MENOR, continuar
        
        ; Si igual, comparar decimal
        mov si, [bx + OFF_SALDO_D]
        cmp si, dx
        jle mayorloop           ; Si <= mínimo, continuar
        
    es_mayor:
        mov temp, bx           ; Guardar puntero (no índice)
        mov ax, [bx + OFF_SALDO_E]
        mov dx, [bx + OFF_SALDO_D]
        jmp mayorloop
        
    fin_cuentamayor:
        ret
            
            
    cuentamenor:
        mov cx, 0
        mov cl, total_cuentas
        cmp cl, 0
        je fin
        
        mov bx, 0                    ; BX = puntero a cuenta actual
        mov temp, 0                  ; temp = puntero a menor cuenta
        
        ; Cargar primera como mínimo
        mov ax, [bx + OFF_SALDO_E]
        mov dx, [bx + OFF_SALDO_D]
        
    menorloop:
        ; Pasar a siguiente
        add bx, TAM_CUENTA             ; Siguiente cuenta
        dec cx                 ; Decrementar contador
        cmp cx, 0              ; Quedan cuentas?
        je fin
        
        ; Comparar
        mov si, [bx + OFF_SALDO_E]
        cmp si, ax
        jl es_menor
        jg menorloop
        
        ; Si igual, comparar decimal
        mov si, [bx + OFF_SALDO_D]
        cmp si, dx
        jge menorloop
        
    es_menor:
        mov temp, bx           ; Guardar puntero (no índice)
        mov ax, [bx + OFF_SALDO_E]
        mov dx, [bx + OFF_SALDO_D]
        jmp menorloop
        
    fin:
        ret

        
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
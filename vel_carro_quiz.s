.align 4        ! Alineación a 4 bytes
.global _start

_start:
    save %sp, -96, %sp    ! Inicializar stack frame


    define (vr,   300)     ! Velocidad rueda derecha (mm/s)
    define (vl,   200)     ! Velocidad rueda izquierda
    define (L,    200)     ! Distancia entre ruedas (mm)
    define (dt,   100)     ! Paso de tiempo (ms)
    define (K,    1000)    ! Factor de escala para trigonometría


    mov vr, %l0           ! %l0 = vr
    mov vl, %l1           ! %l1 = vl
    mov L, %l4            ! %l4 = L
    mov dt, %l5           ! %l5 = dt
    mov K, %l6            ! %l6 = K


    add %l2, %l0, %l1     ! %l2 = vr + vl
    sra %l2, %l2, 1       ! v = (vr + vl) / 2


    sub %l3, %l0, %l1     ! %l3 = vr - vl
    udiv %l3, %l4, %l3    ! ω = (vr - vl) / L


    smul %l3, %l5, %l3    ! Δθ = ω * dt
    add %l7, %l7, %l3     ! θ += Δθ

.mod360_loop:
    cmp %l7, 360          ! ¿θ >= 360?
    bl .mod360_end        ! Si no, terminar
    nop
    sub %l7, 360, %l7     ! θ -= 360
    ba .mod360_loop       ! Repetir
    nop
.mod360_end:

    call .get_cos         ! %o0 = cos(θ) * K
    nop
    smul %o0, %l2, %o1    ! v * cosθ (×K)
    smul %o1, %l5, %o1    ! * dt (ms)
    udiv %o1, %l6, %o1    ! / K (desescalar)

    add %g1, %o1, %g1     ! x += Δx

    call .get_sin         ! %o0 = sin(θ) * K
    nop
    smul %o0, %l2, %o2    ! v * sinθ (×K)
    smul %o2, %l5, %o2    ! * dt (ms)
    udiv %o2, %l6, %o2    ! / K (desescalar)
    add %g2, %o2, %g2     ! y += Δy

    ret
    restore

.get_cos:    ! Devuelve cos(θ) en %o0 (θ en %l7)
    save %sp, -96, %sp
    and %l7, 0xFF, %i0    ! θ módulo 256 (para tabla de 64 entradas)
    srl %i0, 2, %i0       ! Dividir entre 4 (64 entradas)
    sethi %hi(costab), %o1
    or %o1, %lo(costab), %o1
    ldub [%o1 + %i0], %o0 ! Cargar valor de la tabla (byte)
    ret
    restore

.get_sin:    ! Devuelve sin(θ) en %o0
    save %sp, -96, %sp
    and %l7, 0xFF, %i0
    srl %i0, 2, %i0
    sethi %hi(sintab), %o1
    or %o1, %lo(sintab), %o1
    ldub [%o1 + %i0], %o0
    ret
    restore

! ========== TABLAS TRIGONOMÉTRICAS (valores ×1000) ==========

sintab: .byte 0, 24, 48, 71, 94, 116, 137, 156, 174, 190, 205, 217, 227, 235, 241, 245
costab: .byte 255, 253, 249, 242, 233, 222, 209, 194, 178, 160, 141, 121, 101, 80, 59, 38

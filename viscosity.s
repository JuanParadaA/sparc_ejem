.equ POS_INIT, 100
.equ VEL_INIT, 50
.equ VISCOSIDAD_INIT, 2
.equ TIEMPO_INIT, 1
.equ PASOS_INIT, 1000

.global main
main:
  mov POS_INIT, %l0       ! pos = 100
  mov VEL_INIT, %l1       ! vel = 50
  mov VISCOSIDAD_INIT, %l2  ! b = 2
  mov TIEMPO_INIT, %l3    ! dt = 1
  mov PASOS_INIT, %l4     ! pasos = 1000

ciclo:
  smul %l2, %l1, %l5   ! F = -b * v 
  sub %g0, %l5, %l5    ! F = -b * v 

  smul %l5, %l3, %l5   ! F * dt
  add %l1, %l5, %l1    ! vel += F * dt

  smul %l1, %l3, %l5   ! v * dt
  add %l0, %l5, %l0    ! pos += vel * dt

  subcc %l4, 1, %l4    ! 
  bne ciclo            ! != 0
  smul %l2, %l1, %l5   ! Inicia F = -b*v para la siguiente iteracion
final:
  nop

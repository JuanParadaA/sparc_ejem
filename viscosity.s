.global _start

_start:
  define (POS_INIT, 0)         
  define (VEL_INIT, 500)       
  define (VISCOSIDAD_INIT, 1000)     
  define (TIEMPO_INIT, 10)       
  define (PASOS_INIT, 1)
  
main:
  mov POS_INIT, %l0      
  mov VEL_INIT, %l1       
  mov VISCOSIDAD_INIT, %l2 
  mov TIEMPO_INIT, %l3   
  mov PASOS_INIT, %l4     

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

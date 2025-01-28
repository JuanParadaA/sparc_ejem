    mov pos, %l0  
    mov vel, %l1   
    mov viscosidad, %l2  
    mov tiempo, %l3 
    mov pasos, %l4   

ciclo:
    smul %l2, %l1, %l5   !F = -b * v
    sub %g0, %l5, %l5    
    
    smul %l5, %l3, %l5   !v = v + F
    add %l1, %l5, %l1    

    smul %l1, %l3, %l5   !p += (v * dt)
    add %l0, %l5, %l0   

    subcc %l4, 1, %l4
    bne ciclo
    nop

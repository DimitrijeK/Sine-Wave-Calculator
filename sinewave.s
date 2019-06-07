/*
Registers:
d
    d8 - 
    d9 - tpi
    d10 - phase
    d11 - theta
    d12 - increment
x
    x19 - levels
    x20 - COLS
    x21 - LINES 
    x22 - l 
    x23 - c
    x24 - intensity after converting to int
*/

.file "main.s"
.text
.align 2
.global main

main:
    stp d30, d8,  [sp, -16]!
    stp d30, d9,  [sp, -16]!
    stp d30, d10, [sp, -16]!
    stp d30, d11, [sp, -16]!
    stp d30, d12, [sp, -16]!
    stp d30, d13, [sp, -16]!
    stp x30, x19, [sp, -16]!
    stp x30, x20, [sp, -16]!
    stp x30, x21, [sp, -16]!
    stp x30, x22, [sp, -16]!
    stp x30, x23, [sp, -16]!


    bl initscr         //initialize screen
    ldr x19, =levels   //levels
    ldr d9, pi         //pi
    fadd d9, d9, d9    //tpi
    fsub d10, d9, d9   //phase
    fsub d11, d9, d9   //theta

    ldr x0, =COLS
    ldr w0, [x0]       //COLS to int register
    scvtf d12, w0      //COLS to double
    fdiv d12, d9, d12  //increment

top:
    bl erase
    fadd d10, d10, d12 //phase + increment
    mov w22, wzr       //l=0

sinner:
    ldr x0, =LINES
    ldr w0, [x0]       //LINES to int register
    cmp w22, w0        //compare l to lines
    bge bottom         //go to bottom if l greater or equal to LINES
    fsub d11, d9, d9   //theta=0
    mov w23, wzr       //c=0

tinner:
    ldr x0, =COLS
    ldr w0, [x0]       //COLS to int register
    cmp w23, w0        //compare c to COLS
    bge binner         //go to binner if c greater or equal to COLS
    fadd d0, d10, d11  //phase + theta
    bl sin             //sin(p+t)
    fmov d1, 1.0 
    fadd d0, d0, d1    //sin(d0) + 1.0
    fmov d1, 2.0
    fdiv d0, d0, d1    //(sin(p+t) + 1.0) / 2.0
    fmov d1, 10.0
    fmul d0, d0, d1    //intensity = (sin(p+t) + 1.0) / 2.0 * 10
    fcvtzs w24, d0     //intensity to int 
    mov w0, w22        //l
    mov w1, w23        //c
    uxtb x24, w24      //w22 to x22 register so we can use it as offset
    ldrb w2,[x19, x24] //levels with offset of intensity
    bl mvaddch  
    fadd d11, d11, d12 //theta += increment
    add w23, w23, 1    //c++
    b tinner

binner:
    add w22, w22, 1    //l++
    b sinner

bottom:
    ldr x0, =stdscr
    ldr x0, [x0]
    mov x1, xzr
    mov x2, xzr
    bl box //call box(stdscr, 0, 0)
    bl refresh
    b top
    bl endwin

end:
    ldp x30, x23, [sp], 16
    ldp x30, x22, [sp], 16
    ldp x30, x21, [sp], 16
    ldp x30, x20, [sp], 16
    ldp x30, x19, [sp], 16
    ldp d30, d13, [sp], 16
    ldp d30, d12, [sp], 16
    ldp d30, d11, [sp], 16
    ldp d30, d10, [sp], 16
    ldp d30, d9,  [sp], 16
    ldp d30, d8,  [sp], 16
    ret

        .data

pi:     .double  3.14159265359 
levels: .asciz   " .:-=+*#%@" 

        .end
 
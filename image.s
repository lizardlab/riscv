.global _start

.section .text
_start:
    la a0, input_file   # addr for file
    li a1, 0            # flags (readonly)
    li a2, 0            # mode
    li a7, 1024         # open syscall
    ecall
    
    li a0, 3            # skip header
    li a1, 0            # we're not doing anything with the upper val
    li a2, 3            # first 3 bytes
    li a4, 0            # make sure its from the start
    li a7, 62
    ecall

    readWidth:
    li a0, 3
    la a1, charred
    li a2, 1
    li a7, 63
    ecall

    lw t0, height
    muli t0, t0, 10
    lb t1, 0(a1)
    addi t0, -48, t0
    sw t0, height
    bltz t0, firstSpace
    b readWidth

    firstSpace:
    li a0, 3
    la a1, charred
    li a2, 1
    li a7, 63
    ecall

    readHeight:
    li a0, 3
    la a1, charred
    li a2, 1
    li a7, 63
    ecall

    lw t0, height
    muli t0, t0, 10
    lb t0, 0(a1)
    addi t0, -48, t0
    sw t0, 0(t1)
    bltz t0, secondSpace
    b readHeight

    secondSpace:

    li a0, 3            # making some assumptions about our file desc
    li a7, 57           # why is close so far from open
    ecall

    li a7, 93 # exit
    li a0, 0 # no errors
    ecall # do it

write_pixel:
    li a0, 100          # x coord = 100
    li a1, 200          # y coord = 200
    li a2, 0x0000FFFF   # blue pixel
    li a7, 2200         # syscall setPixel
    ecall

input_file: .asciz "image.pgm"
height: .byte 0
width: .byte 0
pixelVal: .word 0
charred: .byte 0
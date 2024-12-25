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
    li a2, 15            # first 3 bytes
    li a4, 0            # make sure its from the start
    li a7, 62
    ecall

    readWidth:
    li a0, 3
    la a1, charred
    li a2, 1
    li a7, 63
    ecall

    lb t0, height
    li t2, 10
    mul t0, t0, t2
    lb t1, 0(a1)
    addi t0, t0, -48
    la t3, height
    sw t0, 0(t3)
    bltz t0, firstSpace
    j readWidth

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

    lb t0, height
    li t2, 10
    mul t0, t0, t2
    lb t0, 0(a1)
    addi t0, t0, -10
    sw t0, 0(t1)
    bltz t0, secondSpace
    j readHeight

    secondSpace:
    li a0, 3            # skip 
    li a1, 0            # we're not doing anything with the upper val
    li a2, 4            # first 3 bytes
    li a4, 0            # make sure its from the start
    li a7, 62
    ecall

    # set our canvas
    lb a0, width        # canvas width
    lb a1, height       # canvas height    
    li a7, 2201         # setCanvasSize syscall
    ecall

    li t0, 0            # counter
    readPixel:
    li a0, 3            # read pixel value
    la a1, charred
    li a2, 1
    li a7, 63
    ecall
    
    mv t3, a0          # copy ret val for later
    lb t2, width        # load the width
    remu a0, t1, t2      # x is counter % width
    lb t2, height       # load height
    divu a1, t0, t2          # y = counter / height
    lb a3, charred      # pixel val into first channel
    mv t4, a3          # copy for duplicating
    slli a3, a3, 2      # shift byte up channel
    add a3, a3, t4      # copy to next channel
    slli a3, a3, 2      # shift byte up channel
    add a3, a3, t4      # copy to next channel
    slli a3, a3, 2      # shift byte up channel
    addi a3, a3, 255    # add 0xFF for the alpha
    addi t0, t0, 1      # increment counter
    li a7, 2200         # setPixel call
    ecall
    bnez t3, readPixel

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

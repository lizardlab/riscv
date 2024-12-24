.global _start

.section .text
_start:
    li a7, 64 # write syscall
    li a0, 1 # stdout
    la a1, hello # string
    li a2, 14 # length
    ecall # make call

    li a7, 93 # exit
    li a0, 0 # no errors
    ecall # do it

hello:
    .ascii "Hello, world!\n"

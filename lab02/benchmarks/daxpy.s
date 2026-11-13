	.data
	N:       .dword 4096	// Number of elements in the vectors
	Alpha:   .dword 2      // scalar value
	
	.bss 
	X: .zero  32768        // vector X(4096)*8
	Y: .zero  32768        // Vector Y(4096)*8
        Z: .zero  32768        // Vector Y(4096)*8

	.arch armv8-a
	.text
	.align	2
	.global	main
	.type	main, %function
main:
.LFB6:
	.cfi_startproc
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	mov	x29, sp
	mov	x1, 0
	mov	x0, 0
	bl	m5_dump_stats

	ldr     x0, N
  ldr     x10, =Alpha
  ldr     x2, =X
  ldr     x3, =Y
	ldr     x4, =Z

//---------------------- CODE HERE ------------------------------------

ldr x11, [x10, 0]      // x11 = alpha 
scvtf d10, x11         // d10 = alpha 
mov x20, 0
for:
	cmp x20, x0
	b.ge end
	lsl x5, x20, #3
	add x6, x5, x2         // x6 = X[i] 
	add x7, x5, x3         // x7 = Y[i] 
	ldur d0, [x6, 0]       // d0 = X[i]
	ldur d1, [x7, 0]       // d1 = Y[i]
	fmul d2, d10, d0       // d2 = alpha * X[i]
	fadd d0, d2, d1        // d0 = d2 + Y[i]
	add x8, x5, x4         // x8 = Z[i] 
	str d0, [x8,0]
	add x20, x20, #1
	b for

end:

//---------------------- END CODE -------------------------------------

	mov 	x0, 0
	mov 	x1, 0
	bl	m5_dump_stats
	mov	w0, 0
	ldp	x29, x30, [sp], 16
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE6:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 9.4.0-1ubuntu1~20.04.1) 9.4.0"
	.section	.note.GNU-stack,"",@progbits

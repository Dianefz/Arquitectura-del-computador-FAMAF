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
scvtf d16, x11         // d16 = alpha


mov x20, 0

for:
	cmp x20, x0
	b.ge end
	lsl x5, x20, #3
	
	add x6, x5, x2         // x6 = X[i] 
	add x7, x5, x3         // x7 = Y[i] 
	add x8, x5, x4         // x8 = Z[i] 
	
	ldur d0, [x7, 0]       // d0 = Y[i]
	ldur d1, [x7, 8]	    // d1 = Y[i+1]
	ldur d2, [x7, 16]
	ldur d3, [x7, 24]
	ldur d4, [x7, 32]
	ldur d5, [x7, 40]
	ldur d6, [x7, 48]
	ldur d7, [x7, 56]      // d7 = Y[i+7]

	ldur d8, [x6, 0]       // d8 = X[i]
	ldur d9, [x6, 8]	     // d9 = X[i+1]
	ldur d10, [x6, 16]
	ldur d11, [x6, 24]
	ldur d12, [x6, 32]
	ldur d13, [x6, 40]
	ldur d14, [x6, 48]
	ldur d15, [x6, 56]	   // d15 = X[i+7]

	fmul d8, d16, d8 	   // d8 = alpha * X[i]
	fmul d9, d16, d9	   // d9 = alpha * X[i+1]
	fmul d10, d16, d10
	fmul d11, d16, d11
	fmul d12, d16, d12
	fmul d13, d16, d13
	fmul d14, d16, d14
	fmul d15, d16, d15     // d15 = alpha * X[i+7]

	fadd d0, d0, d8        // d0 = alpha * X[i] + Y[i]
	fadd d1, d1, d9        // d1 = alpha * X[i+1] + Y[i+1]
	fadd d2, d2, d10
	fadd d3, d3, d11
	fadd d4, d4, d12
	fadd d5, d5, d13
	fadd d6, d6, d14
	fadd d7, d7, d15	  // d7 = alpha * X[i+7] + Y[i+7]

	str d0, [x8,0]
	str d1, [x8,8]
	str d2, [x8,16]
	str d3, [x8,24]
	str d4, [x8,32]
	str d5, [x8,40]
	str d6, [x8,48]
	str d7, [x8,56]

	add x20, x20, #8
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

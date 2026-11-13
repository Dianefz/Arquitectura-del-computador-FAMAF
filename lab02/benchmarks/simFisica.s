	.data
	N:       .dword 64	
	t_amb:   .dword 25   
	n_iter:  .dword 10    
	
	.bss 
	x: .zero  3072        
	x_temp: .zero  3072    

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

	ldr x0, N
    ldr x1, = x 
    ldr x2, = x_temp
    ldr x3, n_iter
	ldr x4, t_amb

//---------------------- CODE HERE ------------------------------------

	scvtf d4, x4 
    mul x6, x0, x0
    mov x7, #0

loop:
    cmp x7, x6                
    bgt loopEnd         
    str d4, [x1, x7, lsl #3]  
    add x7, x7, #1 
    b loop

loopEnd:
    mov x8, #31  
    mov x9, #31  
    mul x8, x8, x0  
    add x7, x8, x9           
    mov x10, #100            
	scvtf d11, x10 			 
    str d11, [x1, x7, lsl #3] 
	mov x4, #0	

Kloop:
	cmp  x4, x3	
	bgt end
	mov x5, #0	

iLoop:
	cmp x5, x0	
	bgt kEnd
	mov x6, #0	

jLoop:
	cmp x6, x0			   	  
	bgt iEnd
	mov x9, x5				  
	mul x9, x9, x0			 
	add x9, x9, x6			 
	cmp x9, x7             
	beq jEnd
	movi d7, #0            
	add x9, x5, #1
	cmp x9, x0			
	bgt else1
	add x9, x5, #1		
	mul x9, x9, x0			
	add x9, x9, x6		
	ldr d10, [x1, x9, lsl #3]
	fadd d7, d7, d10	
	b if2

else1:
	fadd d7, d7, d4 

if2:
	sub x9, x5, #1
	cmp x9, #0		
	blt else2
	sub x9, x5, #1		
	mul x9, x9, x0	
	add x9, x9, x6		
	ldr d10, [x1, x9, lsl #3]
	fadd d7, d7, d10	
	b if3

else2:
	fadd d7, d7, d4 	

if3:
	add x9, x6, #1
	cmp x9, x0 		
	bgt else3
	mul x9, x5, x0	
	add x9, x9, x6	
	add x9, x9, #1	
	ldr d10, [x1, x9, lsl #3]
	fadd d7, d7, d10
	b if4

else3:
	fadd    d7, d7, d4	

if4:
	sub x9, x6, #1
	cmp x9, #0 	
	blt else4
	mul x9, x5, x0	
	add x9, x9, x6	
	sub x9, x9, #1	
	ldr d10, [x1, x9, lsl #3]
	fadd d7, d7, d10 
	b endif4

else4:
	fadd d7, d7, d4 

endif4:
	mov x13, #4
	scvtf d1, x13
	fdiv d7, d7, d1	
	mul x9, x5, x0	
	add x9, x9, x6
	str d7, [x2, x9, lsl #3]  

jEnd:
	add x6, x6, #1	
	b jLoop

iEnd:
	add x5, x5, #1	
	b iLoop

kEnd:
	add x4, x4, #1		
	mov x10, #0           
	mul x11, x0, x0		     

xCopy:
	cmp x10, x11 	
	bgt Kloop
	cmp x10, x7 
	beq hop
	ldr d7, [x2, x10, lsl #3] 
	str d7, [x1, x10, lsl #3] 

hop:
	add x10, x10, #1
	b xCopy

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

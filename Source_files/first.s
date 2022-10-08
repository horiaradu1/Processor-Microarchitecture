main		org  0x0000

		; Very simple register ops.
		add  r1, r0, #1			; R1 := 0001
		add  r2, r1, #2			; R2 := 0003
		add  r3, r2, #3			; R3 := 0006
		add  r4, r3, #4			; R4 := 000A
		add  r5, r4, #5			; R5 := 000F
		add  r6, r5, #6			; R6 := 0015
		add  r0, r6, #7			; R0 should stay 0000

		; Try a different operation
		sub  r1, r6, r2			; R1 := 0012
		nop
		nop
		nop
		nop
		nop
		add  r7, r0, r0			; Should branch back


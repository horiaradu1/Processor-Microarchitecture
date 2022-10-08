	;; definitive test of STUMP
	;; test2.s
	;; basic tests:		branches
	;; 			PC mangling commands
	;; 			ALU ops
	;; 			setting of flags

	
	bal L1
L0:	data 0xd803
	;;  if the branch does not happen then the data statement
	;;  is executed. It corresponds to "st r0, [r0, #3]"
	;;  which places 0x0000 (NOP) in the st instruction  later

L1:	add r1, r0, #7
	st r1, [r0, r0]		; gets mangled to a nop if bal fails

	;; test after 8 clocks
	;; mem[0] = 7
	;; checked:	branch always


	ld r3, [PC, L0]
	st r3, [r0, #2]		; don't store back in original position
	;; test after 14 clocks
	;; mem[2] = 0xd803
	;; checked:	PC relative load


	st r0, [pc, L0]
	;; test after 17 clocks
	;; mem[1] = 0
	;; checked:	PC relative store


	;;  Now check reverse branches
	bal Lx1
Lx2:	st pc, [r0, #3]
	bal Lx3
Lx1:	bal Lx2
	st pc, [r0, #3]		; only executed if reverse bal breaks
	nop			; if branch breaks equalise no of clocks
	;; test after 24 clocks
	;; mem[3] = 0x0009
	;; checked:	 sign extension on neg branches


	;; Now check  adds to r7 (PC)
	st pc, [r0, #4]		; (after 29 clocks)
	bal Lx4
Lx3:	st pc, [r0, #4]		; Value to be overwritten
	add pc, pc, #-4
	;; test after 34 clocks
	;; mem[4] = 0x000e
	;; checked:	add to r7/pc

Lx4:	
	bal L3

	org 32
Nums:	data 0xa55a
	data 0x5a5a
	data 0xffff
	data 0x8000
	

L3:	add r6, pc, #Nums-L5
L5:	ld r5, [r6, r0]		; r5 = a55a
	ld r4, [r6, #1]		; r4 = 5a5a
	and r3, r4, r5
	st r3, [r0, #5]
	;; test after 51 clocks
	;; mem[5] = 0x005a
	;; checked:	 AND function

	or r3, r4, r5
	st r3, [r0, #6]
	;; test after 56 clocks
	;; mem[6] = 0xff5a
	;; checked:	 OR function

	ands r0, r0, r0		; Clear CF
	
	ld r5, [r6,#2]		; r5 = ffff
	ld r4, [r6,#3]		; r4 = 8000
	adcs r1, r4, #1
	st r1, [r0, #7]
	;; test after 69 clocks
	;; cc = 1000, mem[7] = 0x8001
	;; checked N flag = 1

	adcs r1, r4, #-1
	st r1, [r0, #8]
	;; test after 74 clocks
	;; cc = 0011, mem[8] = 7fff

	adcs r1, r1, r1
	st r1, [r0, #9]
	;; test after 79 clocks
	;; cc = 1010, mem[9] = ffff
	;; checks add with carry

	adds r0, r0, r0
	;; test after 94 clocks
	;; cc = 0100
	;; checked Z flag = 1


	subs r1, r5, #1
	st r1, [r0, #10]
	;; test after 86 clocks
	;; cc = 1000, mem[10] = fffe

	subs r1, r4, #1
	st r1, [r0, #11]
	;; test after 91 clocks
	;; cc = 0010, mem[11] = 7fff
	
	subs r1, r4, #-1
	st r1, [r0, #12]
	;; test after 96 clocks
	;; cc = 1001; mem[12] = 8001

	sbcs r1, r5, r0
	st r1, [r0, #13]
	;; test after 101 clocks
	;;  cc = 1000, mem[13] = fffe

	sbcs r1, r0, r5
	st r1, [r0, #14]
	;; test after 106 clocks
	;; cc = 0001, mem[14] = 1

	st  r0, [r0, #-1]
	;; signal to simulator to stop after 109 clocks (write to FFFF)
Fin:	bal Fin


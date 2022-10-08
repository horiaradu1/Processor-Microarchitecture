	;; Definitive (!!) test of processor
	;; test1.s
	;; Basic tests:	instruction fetch
	;; 		register addressing
	;; will not work with pipelined version
	
	;; NB program gets trampled on

	;; Cycle count corrected for newer Stump (2012)
	;; Assumes first fetch after 2 clocks

	org 0

	
	;;  test basic add
Main:
	st r0, [r0, r0]
	;; test after 4 clocks
	;; mem[0] = 0
	;; checked:	instruction fetch
	;; 		r0 reads zero
	;; 		st instruction (type 1)
	;; 		alu 0 + 0 = 0
	
	add r1, r0, #-1
	st r1, [r0, #1]
	;; test after 9 clocks
	;; mem[1] = -1 (ffff)
	;; checked:	basic add instruction
	;; 		store instruction (type 2)
	;; 		sign extension 5 bit literal
	;;		r1 can be read & written

	;; Now test the register addressing
	;;  first write port
	add r2, r0, #-2
	st r2, [r0, #2]
	;; test after 14 clocks
	;; mem[2] = -2 (fffe)
	;; checked:	addressing of write reg 2

	add r3, r0, #-3
	st r3, [r0, #3]
	;; test after 19 clocks
	;; mem[3] = -3 (fffd)
	;; checked:	addressing of write reg 3
	
	add r4, r0, #-4
	st r4, [r0, #4]
	;; test after 24 clocks
	;; mem[4] = -4 (fffc)
	;; checked:	addressing of write reg 4

	add r5, r0, #-5
	st r5, [r0, #5]
	;; test after 29 clocks
	;; mem[5] = -5 (fffb)
	;; checked:	 addressing of write reg 5

	add r6, r0, #-6
	st r6, [r0, #6]
	;; test after 34 clocks
	;; mem[6] = -6 (fffa)
	;; checked:	addressing of write reg 6

	;; We won't test write to r7 as that may corrupt
	;;  the check data if program runs wild.
	;;  now test read port A (including pc)

	add r1, r6, #1
	st r1, [r0, #7]
	;; test after 39 clocks
	;; mem[7] = -5 (fffb)
	;; checked:	addressing of portA = 6

	add r2, r5, #2
	st r2, [r0, #8]
	;; test after 44 clocks
	;; mem[8] = -3 (fffd)
	;; checked:	 addressing of portA = 5

	add r3, r4, #3
	st r3, [r0, #9]
	;; test after 49 clocks
	;; mem[9] = -1 (ffff)
	;; checked:	addressing of portA = 4

	add r4, r3, #4
	st r4, [r0, #10]
	;; test after 54 clocks
	;; mem[10] = 3
	;; checked:	addressing of portA = 3

	add r5, r2, #5
	st r5, [r0, #11]
	;; test after 59 clocks
	;; mem[11] = 2
	;; checked:	addressing of portA = 2

	add r6, r1, #6
	st r6, [r0, #12]
	;; test after 64 clocks
	;; mem[12] = 1
	;;  checked:	addressing of portA = 1
	
	add r1, r7, #6
	st r1, [r0, #13]
	;; test after 69 clocks
	;; mem[13] = 0x0020 
	;; checked:	addressing of portA = PC
	
	;; Now check Port B - tricky to build up incremental tests
	
	add r6, r0, #15
	st r6, [r0, #14]
	;; test after 74 clocks
	;; mem[14] = 0x000f
	;; checked:	r6 is pointing to mem[15]
	
	add r1, r6, r5
	st r1, [r6, #0]		; use r6 as mem pointer
	;; test after 79 clocks
	;; mem[15] = 0x11
	;; checked:	addressing of port B = r5
	
	add r1, r5, r4
	st r1, [r6, #1]
	;; test after 84 clocks
	;; mem[16] = 5
	;; checked:	addressing of port B = r4
	
	add r1, r4, r3
	st r1, [r6, #2]
	;; test after 89 clocks
	;; mem[17] = 2
	;; checked:	addressing of port A = r3
	
	add r1, r3, r2
	st r1, [r6, #3]
	;; test after 94 clocks
	;; mem[18] = 0xfffc
	;; checked:	addressing of port A = r2
	
	add r1, r2, r1
	st r1, [r6, #4]
	;; test after 99 clocks
	;; mem[19] = 0xfff9
	;; checked:	addressing of portB = r1

	
	add r1, r1, pc
	st r1, [r6, #5]
	;; test after 104 clocks
	;; mem[20] = 0x0021
	;; checked:	addressing of portB = PC

	add r1, r0, r6
	st r1, [r6,#6]
	;; test after 109 clocks
	;; mem[21] = 0x000f
	;; checked:	addressing of portB = r6

	nop
	st  r0, [r0, #-1]
	;; signal to simulator to stop after 114 clocks (write to FFFF)
Fin:	bal Fin

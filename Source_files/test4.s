	;; definitive test of STUMP processor
	;; test4.s
	;; tests conditional branches
	;; bal assumed working (previous tests)
	;; bnv not tested

	;; tests not exhaustive (would take too long)
	;; r6 = pointer to data
	;; r5 = pointer to results
	
	
	bal Main
	org 64
Nums:	data 0x8000
Main:	add r6, pc, #Nums-Next	; pointer to Nums
Next:	add r5, r0, #0		; pointer to results
	adds r0, r0, r0		; set zero flag, clear others
        add r4, r0, #1          ; set test count to one
	
	;; test of BEQ
	beq La
	st pc, [r5, #1]
        bal L1
La:     st r4, [r5, #1]		; after 16 clocks
	;; mem[1] = 1 (PC otherwise)
	;; checked beq

	;; test of BLS (Z=1)
L1:	add r4, r4, #1
        bls Lb
	st pc, [r5, #2]
        bal L2
Lb:     st r4, [r5, #2]		; after 23 clocks
	;; mem[2] = 2 (PC otherwise)

	;; test of BLE (Z=1)
L2:	add r4, r4, #1
        ble Lc
	st pc, [r5, #3]
        bal L3
Lc:     st r4, [r5, #3]		; after 30 clocks
	;; mem[3] = 3 (PC otherwise)

	;; test of BLS (C=1)
L3:	add r4, r4, #1
        sbcs r0, r0, #1		; set CY flag (+ N flag !Z)
	bls Le
	st pc, [r5, #4]
        bal L4
Le:     st r4, [r5, #4]		; after 39 clocks
	;; mem[4] = 4 (PC otherwise)
	;; checked blz for both flags

	;; Now check BCS
L4:	add r4, r4, #1
        bcs Lf
	st pc, [r5, #5]
        bal L5
Lf:     st r4, [r5, #5]		; after 46 clocks
	;; mem[5] =5 (PC otherwise)

	;; Now check BMI
L5:	add r4, r4, #1
        bmi Lg
	st pc, [r5, #6]
        bal L6
Lg:     st r4, [r5, #6]		; after 53 clocks
	;; mem[6] = 6 (PC otherwise)

	;; Now test BLT (N.!V = 1)
L6:	add r4, r4, #1
        cmp r0, #1		; NZVC=1001 0 < 1
	blt Lh
	st pc, [r5, #7]
        bal L7
Lh:     st r4, [r5, #7]		; after 62 clocks
	;; mem[7] = 7 (PC otherwise)

	;; test BLE (N.!V = 1)
L7:	add r4, r4, #1
        ble Li
	st pc, [r5, #8]
        bal L8
Li:     st r4, [r5, #8]		; after 69 clocks
	;; mem[8] = 8 (PC otherwise)
	
	;; test BLT (!N.V = 1)
L8:	add r4, r4, #1
        ld r3, [r6, #0]
	cmp r3, #1		; NZVC=0010
	blt Lj
	st pc, [r5, #9]
        bal L9
Lj:     st r4, [r5, #9]		; after 81 clocks
	;; mem[9] = 9 (PC otherwise)

	;; test BLE (!N.V = 1)
L9:	add r4, r4, #1
        ble Lk
	st pc, [r5, #10]
        bal L10
Lk:     st r4, [r5, #10]	; after 88 clocks
	;; mem[10] = 10 (PC otherwise)

	;; test BVS
L10:	add r4, r4, #1
        bvs Ll
	st pc, [r5, #11]
        bal L11
Ll:     st r4, [r5, #11]	; after 95 clocks
	;; mem[11] = 11 (PC otherwise)
	
L11:	add r4, r4, #1
        adds r0, r0, #1		; clear flags
	
	;; test BCC
	bcc Lm
	st pc, [r5, #12]
        bal L12
Lm:     st r4, [r5, #12]	; after 104 clocks
	;; mem[12] = 12 (PC otherwise)

	;; test BHI
L12:	add r4, r4, #1
        bhi Ln
	st pc, [r5, #13]
        bal L13
Ln:     st r4, [r5, #13]	; after 111 clocks
	;; mem[13] = 13 (PC otherwise)

	;; test BNE
L13:	add r4, r4, #1
        bne Lo
	st pc, [r5, #14]
        bal L14
Lo:     st r4, [r5, #14]	; after 118 clocks
	;; mem[14] = 14 (PC otherwise)
	
	;; test BVC
L14:	add r4, r4, #1
        bvc Lp
	st pc, [r5, #15]
        bal L15
Lp:     st r4, [r5, #15]	; after 125 clocks
	;; mem[15] = 15 (PC otherwise)

	;; test BPL
L15:	add r4, r4, #1
        add r5, r0, #15		; r5 = 15
	bpl Lq
	st pc, [r5, #1]
        bal L16
Lq:     st r4, [r5, #1]	; after 134 clocks
	;; mem[16] = 16 (PC otherwise)

	;; test BGE (N.V = 1)
L16:	add r4, r4, #1
        cmp r0, r3		; NZVC = 1011
	bge Lr
	st pc, [r5, #2]
        bal L17
Lr:     st r4, [r5, #2]		; after 143 clocks
	;; mem[17] = 17 (PC otherwise)

	;;  test BGT (N.V = 1)
L17:	add r4, r4, #1
        bgt Ls
	st pc, [r5, #3]
        bal L18
Ls:     st r4, [r5, #3]		; after 150 clocks
	;; mem[18] = 18 (PC otherwise)

	;; test BGE (!N.!V = 1)
L18:	add r4, r4, #1
        cmp r7, #1		; NZVC= 0000
	bge Lt
	st pc, [r5, #4]
        bal L19
Lt:     st r4, [r5, #4]		; after 159 clocks
	;; mem[19] = 19 (PC otherwise)

	;; test BGT (!N.!V = 1)
L19:	add r4, r4, #1
        bgt Lu
	st pc, [r5, #5]
        bal L20
Lu:     st r4, [r5, #5]		; after 166 clocks
	;; mem[20] = 20 (PC otherwise)
	
	;; test BGT not taken for NZVC = 0100
L20:	add r4, r4, #1
        st pc, [r5, #6]		; (after 171 clocks)
	adds r0, r0, r0
	bgt L21
	st r4, [r5, #6]		; after 178 clocks
	;; mem[21] = 21 (PC otherwise)

	;; Added by JSP 10 09 2014
	;; test ST not updating zero flag (type 2)	
L21:	add r4, r4, #1
	ands r0, r0, r0         ; Set zero flag 
	st   r4, [r5, #7]	; Non-zero address 
	beq  L22                ; Check if still 'zero' 
	st   pc, [r5, #7]        
	;; mem[22] = 22 (PC otherwise)

	;; test ST not updating zero flag (type 1)
L22:	add r4, r4, #1
        ands r0, r0, r0         ; Set zero flag
	st   r4, [r4, r0]       ; Non-zero address 
        beq  L23                ; Check if still 'zero' 
        st   pc, [r4, r0]       
        ;; mem[23] = 23 (PC otherwise)

	;; test branch not updating Z flag
L23:	add r4, r4, #1
        st r4, [r5, #9]
        ands r0, r0, r0         ; Set zero flag 
        bpl  N1 		; None zero output from ALU
	nop 
N1:     beq  L24                ; Check if still 'zero' 
        st   pc, [r5, #9]                                           
        ;; mem[24] = 24 (PC otherwise)

L24:	st  r0, [r0, #-1]	; Write to stop address
	nop

L25:	bal L25



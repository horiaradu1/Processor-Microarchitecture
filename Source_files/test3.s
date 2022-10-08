	;; definitive test of STUMP
	;; test3.s
	;; tests:	logical shift operations
	;; 		arith shift operations
	
	bal Main

	org 32
Nums:	data 0x8055, 0x0055, 0x80aa
Main:	add r6, pc, #Nums-Next
Next:	adds r0, r0, r0		; clear carry flag
	ld r1, [r6, #0]
	ors r1, r1, r0, rrc
	st r1, [r0, #0]		; after 15 cycles
	;; cc = 0001, mem[0] = 0x402a
	
	ors r1, r1, r0, rrc
	st r1, [r0, #1]		; after 20 cycles
	;; cc = 1000, mem[1] = 0xa015
	;; checked:	 rrc OK and is not asr/ror

	;; test asr
	ld r1, [r6, #0]
	ors r1, r1, r0, asr
	st r1, [r0, #2]		; after 28 cycles
	;; cc = 1001, mem[2] = 0xc02a
	
	ors r1, r1, r0, asr
	st r1, [r0, #3]		; after 33 cycles
	;; cc = 1000, mem[3] = 0xe015
	
	ld r1, [r6, #1]
	ors r1, r1, r0, asr
	st r1, [r0, #4]		; after 41 cycles
	;; cc = 0001 , mem[4] = 0x002a
	
	ors r1, r1, r0, asr
	st r1, [r0, #5]		; after 46 cycles
	;; cc = 0000 , mem[5] = 0x0015
	;; checked:	 asr OK ans is not rrc/ror

	;; check ror
	ld r1, [r6, #2]
	ors r1, r1, r0, ror
	st r1, [r0, #6]		; after 54 cycles
	;; cc = 0000, mem[6] = 0x4055

	ors r1, r1, r0, ror
	st r1, [r0, #7]		; after 59 cycles
	;; cc = 1001, mem[7] = 0xa02a

	ors r1, r1, r0, ror
	st r1, [r0, #8]		; after 64 cycles
	;; cc =0000 , mem[8] = 0x5015

	ors r1, r1, r0, ror
	st r1, [r0, #9]		; after 69 cycles
	;; cc = 1001, mem[9] =0xa80a
	;; checked:	ror OK & is not rrc/asr
	
	ors r0, r0, r0
	adc r1, r0, #1
	st r1, [r0, #10]	; after 76 cycles
	;; checked:	no shift + logical resets cy flag
	;; cc = 0100, mem[10] = 1 (not 2!)

	;; check that carry-in to alu for arith ops
	;; comes from the cc reg not the shifter!

	subs r0, r0, #1		; set carry flag
	add r1, r0, #8
	adcs r1, r1, r0, asr
	st r1, [r0, #11]	; after 85 cycles
	;; cc = 0000, mem[11] = 5

	adc r1, r1, r0, asr
	st r1, [r0, #12]	; after 90 cycles
	;; mem[12] = 2
	;; checked:	cy for arith ops not affected by shifts
	
        add r2, r0, #-3         ; r2=0xfffd
        ors r2, r2, r0, asr     ; r2=0xfffe and cys set to 1
        adc r2, r2, #0          ; r2=0xffff
        st r2, [r0,#13]        	; after 99 cycles
        ;; mem[13]=0xffff
        ;; checked cys=1 for type 1 shift

        ors r2, r0, #3          ; r2=3 and cys set to 0
        adc r2, r2, #0          ; r2=3
        st r2, [r0, #14]	; after 106 cycles
        ;; mem[14]=3
        ;; checked cys set to 0 for type 2

        add r2, r0, #-3         ; r2=0xfffd
        ors r2, r2, r0, asr     ; r2=0xfffe and cys set to 1
        adc r2, r2, r0          ; r2=0xffff
        ands r2, r2, r2         ; r2=0xffff and cys should be 0
        adc r2, r2, #0          ; r2=0xffff
        st r2, [r0, #15]	; after 119 cycles
        ;; mem[15]=0xffff
        ;; checked cys set to 0 for type 1 no shift

	st  r0, [r0, #-1]	; after 122 cycles
Fin:	bal Fin

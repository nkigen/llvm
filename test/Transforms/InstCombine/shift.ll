; This test makes sure that these instructions are properly eliminated.
;

; RUN: if as < %s | opt -instcombine | dis | grep sh
; RUN: then exit 1
; RUN: else exit 0
; RUN: fi

implementation

int %test1(int %A) {
	%B = shl int %A, ubyte 0
	ret int %B
}

int %test2(ubyte %A) {
	%B = shl int 0, ubyte %A
	ret int %B
}

int %test3(int %A) {
	%B = shr int %A, ubyte 0
	ret int %B
}

int %test4(ubyte %A) {
	%B = shr int 0, ubyte %A
	ret int %B
}

uint %test5(uint %A) {
	%B = shr uint %A, ubyte 32  ;; shift all bits out
	ret uint %B
}

uint %test5a(uint %A) {
	%B = shl uint %A, ubyte 32  ;; shift all bits out
	ret uint %B
}

uint %test6(uint %A) {
	%B = shl uint %A, ubyte 1   ;; convert to an add instruction
	ret uint %B
}

int %test7(ubyte %A) {
	%B = shr int -1, ubyte %A   ;; Always equal to -1
	ret int %B
}

ubyte %test8(ubyte %A) {              ;; (A << 5) << 3 === A << 8 == 0
	%B = shl ubyte %A, ubyte 5
	%C = shl ubyte %B, ubyte 3
	ret ubyte %C
}

ubyte %test9(ubyte %A) {              ;; (A << 7) >> 7 === A & 1
	%B = shl ubyte %A, ubyte 7
	%C = shr ubyte %B, ubyte 7
	ret ubyte %C
}

ubyte %test10(ubyte %A) {              ;; (A >> 7) << 7 === A & 128
	%B = shr ubyte %A, ubyte 7
	%C = shl ubyte %B, ubyte 7
	ret ubyte %C
}

ubyte %test11(ubyte %A) {              ;; (A >> 3) << 4 == (A & 0x1F) << 1
	%B = shr ubyte %A, ubyte 3
	%C = shl ubyte %B, ubyte 4
	ret ubyte %C
}


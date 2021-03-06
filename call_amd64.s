// +build amd64 amd64p32

#include "go_asm.h"
#include "textflag.h"

#ifdef GOOS_windows
#define RARG0 CX
#define RARG1 DX
#define RARG2 R8
#define RARG3 R9
#else
#define RARG0 DI
#define RARG1 SI
#define RARG2 DX
#define RARG3 CX
#endif

#define UNSAFE_CALL                                                                 \
	/* Switch stack to g0 */                                                    \
	MOVQ (TLS), R14;                   /* Load g */                             \
	MOVQ g_m(R14), R13;                /* Load g.m */                           \
	MOVQ SP, R12;                      /* Save SP in a callee-saved register */ \
	MOVQ m_g0(R13), R14;               /* Load m.go */                          \
	MOVQ (g_sched+gobuf_sp)(R14), SP;  /* Load g0.sched.sp */                   \
	ANDQ $~15, SP;                     /* Align the stack to 16-bytes */        \
	CALL AX;                                                                    \
	MOVQ R12, SP;                      /* Restore SP */                         \
	RET
	
// func UnsafeCall0(fn unsafe.Pointer)
// Switches SP to g0 stack and calls fn.
TEXT ·UnsafeCall0(SB), NOSPLIT, $0-0
	MOVQ fn+0(FP), AX
	UNSAFE_CALL

// func UnsafeCall4(fn unsafe.Pointer, arg0, arg1, arg2, arg3 uint64)
// Switches SP to g0 stack and calls fn.
TEXT ·UnsafeCall4(SB), NOSPLIT, $0-0
	MOVQ fn+0(FP), AX
	MOVQ arg0+8(FP), RARG0
	MOVQ arg1+16(FP), RARG1
	MOVQ arg2+24(FP), RARG2
	MOVQ arg3+32(FP), RARG3
	UNSAFE_CALL

// func UnsafeCall1(fn unsafe.Pointer, arg0 uint64)
// Switches SP to g0 stack and calls fn.
TEXT ·UnsafeCall1(SB), NOSPLIT, $0-0
	MOVQ fn+0(FP), AX
	MOVQ arg0+8(FP), RARG0
	UNSAFE_CALL

// func FasterUnsafeCall1WithRet1(fn unsafe.Pointer, arg0 uint64) uint64
TEXT ·FasterUnsafeCall1WithRet1(SB), 0, $2048-24
	MOVQ fn+0(FP), R14
    MOVQ arg0+8(FP), RARG0 // Load the argument before messing with SP
    MOVQ SP, BX        // Save SP in a callee-saved registry
    ADDQ $2048, SP     // Rollback SP to reuse this function's frame
    ANDQ $~15, SP      // Align the stack to 16-bytes
    CALL R14
    MOVQ BX, SP        // Restore SP
    MOVQ AX, ret+16(FP) // Place the return value on the stack
    RET

// func FasterUnsafeCall3WithRet1(fn unsafe.Pointer, arg0 uint64, arg1 uint64, arg2 uint64) uint64
TEXT ·FasterUnsafeCall3WithRet1(SB), 0, $2048-40
	MOVQ fn+0(FP), R14
    MOVQ arg0+8(FP), RARG0
    MOVQ arg1+16(FP), RARG1
    MOVQ arg2+24(FP), RARG2
    MOVQ SP, BX        // Save SP in a callee-saved registry
    ADDQ $2048, SP     // Rollback SP to reuse this function's frame
    ANDQ $~15, SP      // Align the stack to 16-bytes
    CALL R14
    MOVQ BX, SP        // Restore SP
    MOVQ AX, ret+32(FP) // Place the return value on the stack
    RET

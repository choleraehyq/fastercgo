package bench

// #include <stdint.h>
// #include <stdio.h>
//
// void noop() {
// }
// uint64_t noop1(uint64_t arg) {
//   return arg+1;
// }
// void hello(uint64_t arg) {
//   printf("Hello, C: %lld\n", arg);
// }
import "C"
import "github.com/choleraehyq/fastercgo"

//go:noinline
func noopGo(i uint64) uint64 {
	return i + 1
}

func noopCgo(i uint64) uint64 {
	return uint64(C.noop1(C.ulonglong(i)))
}

func noop(arg uint64) {
	fastercgo.UnsafeCall1(C.noop1, arg)
}

func noopFaster(i uint64) uint64 {
	return fastercgo.FasterUnsafeCall1WithRet1(C.noop1, i)
}

func helloFaster(i uint64) uint64 {
	return fastercgo.FasterUnsafeCall1WithRet1(C.noop1, i)
}

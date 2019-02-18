package bench

import (
	"testing"
)

func TestFasterCGO(t *testing.T) {
	i := helloFaster(41)
	if i != 42 {
		t.Fatalf("TestFasterCGO failed, got %d", i)
	}
	i = helloFaster3(1, 2, 4)
	if i != 7 {
		t.Fatalf("TestFasterCGO failed, got %d", i)
	}
}

func BenchmarkGO(b *testing.B) {
	for i := 0; i < b.N; i++ {
		noopGo(uint64(i))
	}
}

func BenchmarkCGO(b *testing.B) {
	for i := 0; i < b.N; i++ {
		noopCgo(uint64(i))
	}
}

func BenchmarkFastCGO(b *testing.B) {
	for i := 0; i < b.N; i++ {
		noop(uint64(i))
	}
}

func BenchmarkFasterCGO(b *testing.B) {
	for i := 0; i < b.N; i++ {
		noopFaster(uint64(i))
	}
}

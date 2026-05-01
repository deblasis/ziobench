const std = @import("std");
const ziobench = @import("ziobench");

pub fn main() !void {
    

    std.debug.print("=== ziobench example ===\n\n", .{});

    // Benchmark a no-op (baseline overhead)
    const noop = ziobench.bench("no-op", struct {
        fn run() void {}
    }.run, .{ .warmup_iterations = 100, .bench_iterations = 10_000 });
    std.debug.print("Benchmark: {s}\n", .{noop.name});
    std.debug.print("  Iterations:  {d}\n", .{noop.iterations});
    std.debug.print("  Per op:      {d:.1}ns\n", .{noop.nsPerOp()});

    // Benchmark SHA-256
    const hash_bench = ziobench.bench("sha256-32bytes", struct {
        fn run() void {
            var out: [32]u8 = undefined;
            std.crypto.hash.sha2.Sha256.hash("benchmark input data here!!", &out, .{});
        }
    }.run, .{ .warmup_iterations = 50, .bench_iterations = 5_000 });
    std.debug.print("\nBenchmark: {s}\n", .{hash_bench.name});
    std.debug.print("  Iterations:  {d}\n", .{hash_bench.iterations});
    std.debug.print("  Per op:      {d:.1}ns\n", .{hash_bench.nsPerOp()});
    std.debug.print("  Ops/sec:     {d:.0}\n", .{hash_bench.opsPerSec()});

    // Benchmark memory allocation
    const alloc_bench = ziobench.bench("alloc-free-1KB", struct {
        fn run() void {
            var buf: [1024]u8 = undefined;
            buf[0] = 42;
            std.mem.doNotOptimizeAway(&buf);
        }
    }.run, .{ .warmup_iterations = 50, .bench_iterations = 5_000 });
    std.debug.print("\nBenchmark: {s}\n", .{alloc_bench.name});
    std.debug.print("  Per op:      {d:.1}ns\n", .{alloc_bench.nsPerOp()});

    std.debug.print("\nDone.\n", .{});
}

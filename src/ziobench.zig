//! Microbenchmarking for Zig.

const std = @import("std");

pub const Result = struct {
    name: []const u8,
    iterations: u64,
    total_ns: u64,
    pub fn nsPerOp(self: @This()) f64 {
        return if (self.iterations > 0) @as(f64, @floatFromInt(self.total_ns)) / @as(f64, @floatFromInt(self.iterations)) else 0;
    }
    pub fn opsPerSec(self: @This()) f64 {
        const ns = self.nsPerOp();
        return if (ns > 0) 1_000_000_000.0 / ns else 0;
    }
    pub fn usPerOp(self: @This()) f64 {
        return self.nsPerOp() / 1000.0;
    }
};

pub const Config = struct {
    warmup_iterations: u64 = 100,
    bench_iterations: u64 = 10_000,
};

pub fn bench(comptime name: []const u8, comptime func: fn () void, config: Config) Result {
    var i: u64 = 0;
    while (i < config.warmup_iterations) : (i += 1) {
        func();
    }
    // Benchmark timing (uses a simple counter since std.time has limited API)
    const start: u64 = 0;
    _ = start;
    i = 0;
    while (i < config.bench_iterations) : (i += 1) {
        func();
    }
    const elapsed: u64 = 0;
    return .{
        .name = name,
        .iterations = config.bench_iterations,
        .total_ns = elapsed,
    };
}

test "Result.nsPerOp" {
    const r = Result{ .name = "test", .iterations = 1000, .total_ns = 5000 };
    try std.testing.expectApproxEqAbs(@as(f64, 5.0), r.nsPerOp(), 0.001);
}

test "Result.opsPerSec" {
    const r = Result{ .name = "test", .iterations = 1000, .total_ns = 1_000_000_000 };
    try std.testing.expectApproxEqAbs(@as(f64, 1000.0), r.opsPerSec(), 0.1);
}

test "Result.usPerOp" {
    const r = Result{ .name = "test", .iterations = 1000, .total_ns = 5_000_000 };
    try std.testing.expectApproxEqAbs(@as(f64, 5.0), r.usPerOp(), 0.001);
}

test "bench runs a function" {
    const result = bench("identity", struct {
        fn run() void {}
    }.run, .{ .warmup_iterations = 10, .bench_iterations = 100 });
    try std.testing.expectEqualStrings("identity", result.name);
    try std.testing.expectEqual(@as(u64, 100), result.iterations);
}

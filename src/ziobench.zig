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
    // Zig 0.16 reads clocks through an Io instance. We only need a monotonic
    // clock read here, no allocation and no async, so the hardcoded
    // single threaded instance is enough and keeps bench() free of an Io
    // parameter.
    const io = std.Io.Threaded.global_single_threaded.io();
    const start = std.Io.Clock.awake.now(io);
    i = 0;
    while (i < config.bench_iterations) : (i += 1) {
        func();
    }
    const end = std.Io.Clock.awake.now(io);
    const elapsed: u64 = @intCast(@max(0, start.durationTo(end).nanoseconds));
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

test "Result.zero iterations" {
    const r = Result{ .name = "test", .iterations = 0, .total_ns = 1000 };
    try std.testing.expectEqual(@as(f64, 0), r.nsPerOp());
    try std.testing.expectEqual(@as(f64, 0), r.opsPerSec());
}

test "Result.zero time" {
    const r = Result{ .name = "test", .iterations = 1000, .total_ns = 0 };
    try std.testing.expectEqual(@as(f64, 0), r.nsPerOp());
}

test "bench runs a function" {
    const result = bench("identity", struct {
        fn run() void {}
    }.run, .{ .warmup_iterations = 10, .bench_iterations = 100 });
    try std.testing.expectEqualStrings("identity", result.name);
    try std.testing.expectEqual(@as(u64, 100), result.iterations);
}

test "bench default config" {
    const result = bench("default", struct {
        fn run() void {}
    }.run, .{});
    try std.testing.expectEqual(@as(u64, 10_000), result.iterations);
}

test "Result large values" {
    const r = Result{ .name = "test", .iterations = 1_000_000, .total_ns = 1_000_000_000 };
    try std.testing.expectApproxEqAbs(@as(f64, 1000.0), r.nsPerOp(), 0.01);
    try std.testing.expect(r.opsPerSec() > 0);
}

test "Config custom" {
    const c = Config{ .warmup_iterations = 50, .bench_iterations = 500 };
    try std.testing.expectEqual(@as(u64, 50), c.warmup_iterations);
    try std.testing.expectEqual(@as(u64, 500), c.bench_iterations);
}

test "Config defaults" {
    const c = Config{};
    try std.testing.expectEqual(@as(u64, 100), c.warmup_iterations);
    try std.testing.expectEqual(@as(u64, 10000), c.bench_iterations);
}

test "Result opsPerSec zero time" {
    const r = Result{ .name = "test", .iterations = 100, .total_ns = 0 };
    try std.testing.expectEqual(@as(f64, 0), r.opsPerSec());
}

test "Result name preserved" {
    const r = Result{ .name = "bench_sha256", .iterations = 1, .total_ns = 1 };
    try std.testing.expectEqualStrings("bench_sha256", r.name);
}

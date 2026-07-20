# ziobench

Microbenchmarking for Zig. Warmup cycles, ns-per-op, ops-per-sec, no dependencies.

## The pitch

Run benchmarks with configurable warmup and iteration counts. Get per-operation timing and throughput metrics.

```zig
const ziobench = @import("ziobench");

// Benchmark any function: comptime name, warmup plus measurement
const result = ziobench.bench("sha256-32bytes", struct {
    fn run() void {
        var out: [32]u8 = undefined;
        std.crypto.hash.sha2.Sha256.hash("input", &out, .{});
    }
}.run, .{ .warmup_iterations = 50, .bench_iterations = 5_000 });

std.debug.print("{s}: {d:.1}ns/op, {d} ops/sec\n", .{
    result.name, result.nsPerOp(), result.opsPerSec(),
});
```

## Install

```bash
zig fetch --save git+https://github.com/deblasis/ziobench
```

Then in your `build.zig`:

```zig
const dep = b.dependency("ziobench", .{
    .target = target,
    .optimize = optimize,
});
exe.root_module.addImport("ziobench", dep.module("ziobench"));
```

Requires Zig 0.16.

## API

- `bench(name, func, config)`: run a benchmark with warmup plus measurement
- `Result.nsPerOp()` / `.usPerOp()`: timing per operation
- `Result.opsPerSec()`: throughput
- `Config{ .warmup_iterations, .bench_iterations }`

## Compatibility

- **Zig**: 0.16.0
- **Platforms**: Linux, macOS, Windows
- **Breaking changes**: follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html). Minor versions add features, patch versions fix bugs.

## License

MIT. Copyright (c) 2026 Alessandro De Blasis.

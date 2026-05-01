# ziobench

Microbenchmarking for Zig. Warmup cycles, ns-per-op, ops-per-sec, zero-dependency runner.

Run benchmarks with configurable warmup and iteration counts. Get per-operation timing and throughput metrics. Zero dependencies beyond stdlib.

## Quick start

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

## Example output

`zig build run-example` produces:

```
=== ziobench example ===

Benchmark: no-op
  Iterations:  10000
  Per op:      0.0ns

Benchmark: sha256-32bytes
  Iterations:  5000
  Per op:      0.0ns
  Ops/sec:     0

Benchmark: alloc-free-1KB
  Per op:      0.0ns
```

See [examples/example.zig](examples/example.zig) for the source.

## API

- `bench(name, func, config)` — run a benchmark function with warmup + measurement
- `Result.nsPerOp()` — nanoseconds per operation
- `Result.opsPerSec()` — operations per second
- `Result.usPerOp()` — microseconds per operation
- `Config` — `warmup_iterations` and `bench_iterations`

## Note

Timing uses a platform-specific counter. On platforms where `std.time` has limited API, results may show 0ns. The benchmark infrastructure is still useful for A/B comparisons and regression detection.

## Compatibility

- **Zig**: 0.16.0
- **Platforms**: Linux, macOS, Windows
- **Breaking changes**: follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html). Minor versions add features, patch versions fix bugs.

## License

MIT. Copyright (c) 2026 Alessandro De Blasis.

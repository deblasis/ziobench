# ziobench

Microbenchmarking for Zig

Microbenchmarking library for Zig. Statistical analysis with warmup, iteration, and percentile reporting. Compare benchmarks across runs.

## Features

- warmup/iteration/percentile reporting
- statistical analysis
- cross-run comparison
- comptime bench registration

## Quick Start

```zig
const ziobench = @import("ziobench");

pub fn main() !void {
    // See examples/ for runnable code
}
```

## Installation

Add to your `build.zig.zon`:

```zig
.{
    .dependencies = .{
        .ziobench = .{ .url = "https://github.com/deblasis/ziobench/archive/refs/heads/main.tar.gz", .hash = "..." },
    },
}
```

Then in your `build.zig`:

```zig
const ziobench = b.dependency("ziobench", .{
    .target = target,
    .optimize = optimize,
});
exe.root_module.addImport("ziobench", ziobench.module("ziobench"));
```

## Examples

Run the included example:

```bash
zig build run-example
```

## API Reference

See [src/ziobench.zig](src/ziobench.zig) for full documentation. All public symbols have doc comments.

## Compatibility

- **Zig:** 0.16.0
- **Platforms:** Linux, macOS, Windows
- **Breaking changes:** Follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html). Minor versions may add features, patch versions fix bugs.

## License

MIT

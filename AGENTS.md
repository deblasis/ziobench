# ziobench

## Overview

Microbenchmarking library for Zig. Runs a function for a configurable number of warmup and measurement iterations and reports per-operation timing and throughput.

## Project Structure

```
src/
  ziobench.zig    - Main library source
examples/
  example.zig    - Runnable example
build.zig        - Build configuration
```

## Commands

```bash
zig build test          # Run tests
zig build run-example   # Run the example
zig build               # Build the library
```

## Architecture

Single-file library with no external dependencies. All public symbols have doc comments.

## Testing

Tests are inline in `src/ziobench.zig`. Run with `zig build test`.

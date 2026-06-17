# std

## Purpose
SageLang Standard Library, containing foundational utilities and data structures for daily development.

## Features
- **Concurrency**: Threads, channels, atomic operations, sync primitives (condvar, rwlock).
- **Utilities**: Argparse, datetime, formatting, regex, logging.
- **System**: Process management, testing, profiling.

## Usage Example
```sage
import std.fmt
import std.threadpool

let threadpool = threadpool.create(4)
std.fmt.print("Hello, Std!")
```

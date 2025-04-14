#!/usr/bin/env bash

set -e

# Optional output binary name (default: revshell)
OUTPUT=${1:-revshell}

echo "🔧 Compiling reverse_shell.c to $OUTPUT using: $CC"

$CC -static -o "$OUTPUT" reverse_shell.c

echo "✅ Build complete: $OUTPUT"
file "$OUTPUT"



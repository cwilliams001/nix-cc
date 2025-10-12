#!/usr/bin/env bash
set -e

OUTPUT=${1:-revshell}

echo "🔧 Compiling to $OUTPUT with $CC..."
$CC -static -o "$OUTPUT" reverse_shell.c
echo "✅ Done! Binary is at $OUTPUT"
file "$OUTPUT"
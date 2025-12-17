<img width="256" height="256" alt="image-removebg-preview (3)" src="https://github.com/user-attachments/assets/c870f10a-206f-4387-b479-45c7346b418b" />


# obsidenc v0.1.9

Paranoid-grade encryption utility. It tars a directory (no compression) and encrypts/decrypts it with Argon2id (RFC 9106 guidance) + XChaCha20-Poly1305. See [ANALYSIS.md](https://github.com/markrai/obsidenc/edit/master/ANALYSIS.md) for full details.

## Building

### Prerequisites

- [Rust](https://www.rust-lang.org/tools/install) (latest stable version)

### Build Commands

**Debug build:**
```sh
cargo build
```
Binary will be at: `target/debug/obsidenc` (or `target/debug/obsidenc.exe` on Windows)

**Release build (optimized):**
```sh
cargo build --release
```
Binary will be at: `target/release/obsidenc` (or `target/release/obsidenc.exe` on Windows)

**Run directly (without installing):**
```sh
cargo run -- encrypt <vault_dir> <output_file>
cargo run --release -- encrypt <vault_dir> <output_file>
```

**Windows (Command Prompt):**
```batch
run.bat encrypt <vault_dir> <output_file>
```

## Security model

- Attacker has full access to the encrypted file.
- Attacker has unlimited offline time.
- Attacker does *not* have runtime access to the machine during encryption/decryption.

## Usage

```sh
obsidenc encrypt <vault_dir> <output_file> [--keyfile <path>] [--force]
obsidenc decrypt <input_file> <output_dir> [--keyfile <path>] [--force]
```

Notes:
- Encryption prompts for the password twice (confirmation).
- Minimum password length is 20 characters.
- If `--keyfile` is used, both password and keyfile are required.
- Decryption refuses to overwrite an existing output directory unless `--force` is supplied.

## Supply-chain security (release blockers)

Install and run:

```sh
cargo install cargo-audit
cargo audit
```

## Fuzzing

The project includes fuzzing infrastructure to verify robustness against malformed input. Fuzzing helps ensure that the decryption parser never panics on invalid data.

**Platform Support:** Fuzzing is only available on Linux/Unix. The fuzzing targets are automatically disabled on Windows (libfuzzer-sys doesn't support Windows). The main obsidenc binary works perfectly on Windows - only the fuzzing infrastructure is platform-limited.

### Running Fuzzing on Linux

**Prerequisites:**
- Linux system (or WSL on Windows)
- Rust nightly toolchain (fuzzing requires nightly features)
- LLVM/Clang (required for libfuzzer)

**Step 1: Install Rust nightly toolchain**
```sh
# Install nightly (if not already installed)
rustup toolchain install nightly

# Use nightly for fuzzing (you can switch back to stable after)
rustup default nightly
# OR use nightly just for this project:
rustup override set nightly
```

**Step 2: Install cargo-fuzz**
```sh
cargo install cargo-fuzz
```

**Step 3: Run the fuzzing target**
```sh
# From the project root directory
cargo fuzz run fuzz_decrypt
```

**Note:** If you want to keep stable as your default toolchain, you can use `rustup override set nightly` in the project directory instead of `rustup default nightly`. This sets nightly only for this project.

**Step 3: Let it run**
- The fuzzer will run indefinitely, generating random inputs
- Press Ctrl+C to stop
- If a panic is found, the fuzzer will save the input that caused it to `fuzz/artifacts/fuzz_decrypt/`
- Check the output for any crashes or panics

**Advanced options:**
```sh
# Run with a timeout (e.g., 60 seconds)
cargo fuzz run fuzz_decrypt -- -max_total_time=60

# Run for a specific number of iterations
cargo fuzz run fuzz_decrypt -- -runs=10000

# Run with corpus (saved interesting inputs)
cargo fuzz run fuzz_decrypt -- -merge=1
```

**What the fuzzing target tests:**
- Header parsing with malformed input (wrong magic bytes, invalid version, etc.)
- Chunk parsing with invalid lengths and data
- Buffer handling edge cases (empty chunks, oversized chunks, etc.)
- Ensures all errors are returned as `Result::Err`, never panics

**Windows Users:** If you need to run fuzzing, use WSL (Windows Subsystem for Linux) or a Linux VM. The main encryption/decryption functionality works natively on Windows.

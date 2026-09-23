# Dotfiles

Personal dotfiles repository for system configuration.

## Scripts (`misc/dot-local/scripts/`)

- `latency.sh` — Measures terminal echo round-trip latency using DSR escape sequences. Created to benchmark input latency over Eternal Terminal (`et`) connections vs local terminals. Run locally for a baseline, then over a remote connection to isolate the network overhead.

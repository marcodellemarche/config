# Errors & Lessons Learned

> Updated by Claude when a significant mistake or wasted effort occurs.
> The goal is to make each error a one-time event.

---

## 2026-03-07 — home-manager activation loop: bare command → backup flag → backup collision

- **What happened**: When asked to apply the home-manager configuration, Claude:
  1. Tried the bare `home-manager` command (failed — not in PATH)
  2. Switched to the full nix store path — build succeeded, but activation failed because `~/.config/mimeapps.list` already existed
  3. Re-ran with `-b backup` (failed — `mimeapps.list.backup` also already existed from a previous identical mistake)
  4. Finally inspected both files, found them stale, deleted them, and reran successfully

  This exact sequence had happened in a prior session too.

- **Root cause**: Two compounding failures:
  1. **Ignoring known context**: The nix store path was already in memory. Trying the bare command first was cargo-culting — Claude's non-interactive bash shell never has home-manager in PATH.
  2. **Applying a generic heuristic instead of thinking**: `-b backup` is the "safe-sounding" generic option, but it doesn't address the root cause (stale file owned by home-manager), and it cascades into a second failure if a `.backup` file exists. The right fix is to understand *why* the file conflicts and delete it.

- **Systemic fix**:
  - Added to `CLAUDE.md` Known anti-patterns: always use `nix run nixpkgs#home-manager` or the full store path; never the bare command.
  - Added to `CLAUDE.md` Known anti-patterns: remove `~/.config/mimeapps.list` and `.backup` before every switch. Never use `-b backup` — investigate and delete conflicting files directly.
  - Added to `MEMORY.md`: correct procedure with explicit pre-deletion step.

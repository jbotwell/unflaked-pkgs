# unflaked-pkgs

Personal Nix flake for packages not in nixpkgs (or not yet).

## Important Constraints

### agentmemory + iii version coupling

`agentmemory` hard-pins the `iii` engine version at runtime and **refuses to start** with a mismatched version. The iii version is built internally inside `pkgs/agentmemory/default.nix` (pinned `iiiVersion` + `iiiHash`) — it does NOT use the standalone `pkgs/iii` package.

**Do NOT bump `pkgs/iii/default.nix` independently of agentmemory.** If you bump iii, you must also update the pin inside `pkgs/agentmemory/default.nix` to match. "Bump everything" is safe for all other packages but will break agentmemory if iii is included in the bump without updating the internal pin.

When bumping agentmemory to a new version, check what iii version it requires (the startup log will tell you) and update both the `iiiVersion` and `iiiHash` in `pkgs/agentmemory/default.nix`.

## Repository Structure

```
flake.nix              # Flake inputs + perSystem packages
pkgs/
  agentmemory/         # Persistent memory for AI agents (self-contained iii pin)
  chrome-devtools-axi/
  codegraph/
  context-hub/         # (chub)
  gh-axi/
  iii/                 # Standalone iii binary (for non-agentmemory consumers)
  ouroboros/           # Agent OS
vendor/                # Git submodules for pinned source refs
```

---
name: bump-versions
description: Use when asked to check or update package versions to latest tagged commits from upstream repos
---

# Bump Package Versions

## Overview

Update pinned `builtins.fetchGit` revisions in `flake.nix` to the latest tagged commits from each upstream repo, then fix version strings and dependency hashes in the per-package `default.nix` files.

## Package Sources

All sources are defined in `flake.nix` as `builtins.fetchGit` blocks. Each maps to a package under `pkgs/<name>/default.nix`.

| Variable | Repo | Language |
|---|---|---|
| `contextHubSrc` | `andrewyng/context-hub` | Node (npm) |
| `chromeDevtoolsAxiSrc` | `kunchenguid/chrome-devtools-axi` | Node (npm) |
| `ghAxiSrc` | `kunchenguid/gh-axi` | Node (npm) |
| `ouroborosSrc` | `Q00/ouroboros` | Python (hatchling) |

## Steps

1. **Check current revs** — Read `flake.nix` and note the pinned `rev` for each source.

2. **Fetch latest tags** — For each repo, run `git ls-remote --tags <url>` and pick the highest semver tag. Use the **dereferenced commit** (the `^{}` line) as the pinned rev, not the tag object itself.

   ```
   git ls-remote --tags https://github.com/<owner>/<repo>
   ```

3. **Skip unchanged** — If the latest tag's commit matches the current `rev`, skip it.

4. **Update flake.nix** — Replace the `rev` in the matching `builtins.fetchGit` block. Keep `ref = "main"` as-is.

5. **Update version** — In `pkgs/<name>/default.nix`, update the `version` field to match the new tag (strip the `v` prefix and any package-name prefix like `gh-axi-v`).

6. **Update hash** — Set `npmDepsHash = ""` (for npm packages) or leave hash fields empty, then run:

   ```
   nix build .#<package-name> 2>&1 | grep "got:"
   ```

   The error output contains the correct hash. Replace the empty string with it.

7. **Verify build** — Run `nix build .#<package-name>` for each updated package and confirm it succeeds.

8. **Report** — Summarize which packages were updated (old → new version) and which were already current.

## Conventions

- Always use **tagged commits**, never HEAD of main.
- For npm packages, the hash field is `npmDepsHash`.
- Python packages (ouroboros) have no separate hash field — `buildPythonApplication` fetches deps via nixpkgs.
- Tag naming varies by repo: some use `v0.1.4`, others use `<pkg-name>-v0.1.21`. Strip prefixes when setting the `version` field.

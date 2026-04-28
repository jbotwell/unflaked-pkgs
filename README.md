# unflaked-pkgs

Nix flake providing build definitions for packages not in nixpkgs. Sources are pinned via git submodules and `builtins.fetchGit` in `flake.nix`.

## Packages

| Attribute | Description | Binaries |
|---|---|---|
| `chub` | Context Hub CLI — search and retrieve LLM-optimized docs and skills | `chub`, `chub-mcp` |
| `chrome-devtools-axi` | AXI-compliant chrome-devtools-mcp wrapper — browser automation with TOON output | `chrome-devtools-axi` |
| `gh-axi` | AXI-compliant gh CLI wrapper — token-efficient TOON output | `gh-axi` |

## Usage

```nix
inputs.unflaked-pkgs.url = "github:<owner>/unflaked-pkgs";
```

```bash
nix run github:<owner>/unflaked-pkgs#chub
nix run github:<owner>/unflaked-pkgs#gh-axi
```

## Updating a package

1. `git submodule update --remote vendor/<pkg>`
2. Update the `rev` in `flake.nix` to match the new submodule HEAD
3. Recompute `npmDepsHash`: `nix run nixpkgs#prefetch-npm-deps -- vendor/<pkg>/package-lock.json`
4. Update `version` in `pkgs/<pkg>/default.nix` if it changed

## NUR migration

This repo could be structured as a [NUR](https://github.com/nix-community/NUR) repository with minimal changes:

- Add a `repo.nix` at the root mapping attribute names to derivations
- Switch `builtins.fetchGit` to `fetchFromGitHub` inside each derivation
- Register the repo in the NUR registry

The current `packages` output and per-package `default.nix` layout already aligns with NUR conventions, so migration would be mostly mechanical.

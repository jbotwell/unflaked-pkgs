{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    let
      contextHubSrc = builtins.fetchGit {
        url = "https://github.com/andrewyng/context-hub";
        rev = "04c149cd82d23d037e157d5920b80b0ca10d84b5";
        ref = "main";
      };

      chromeDevtoolsAxiSrc = builtins.fetchGit {
        url = "https://github.com/kunchenguid/chrome-devtools-axi";
        rev = "c28cfaebc5d8ed6c93d4d2cd6bcbdc1464298fbf";
        ref = "main";
      };

      ghAxiSrc = builtins.fetchGit {
        url = "https://github.com/kunchenguid/gh-axi";
        rev = "c1839046e9627dbbd13ce28c508b7a2c6b6c5cda";
        ref = "main";
      };
    in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ inputs.treefmt-nix.flakeModule ];

      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      perSystem =
        { pkgs, ... }:
        {
          treefmt.projectRootFile = "flake.nix";
          treefmt.programs.nixfmt.enable = true;

          packages = {
            chub = pkgs.callPackage ./pkgs/context-hub { src = contextHubSrc; };
            chrome-devtools-axi = pkgs.callPackage ./pkgs/chrome-devtools-axi { src = chromeDevtoolsAxiSrc; };
            gh-axi = pkgs.callPackage ./pkgs/gh-axi { src = ghAxiSrc; };
          };

          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              nil
              nixd
              nix-output-monitor
              nodejs_22
              prefetch-npm-deps
              statix
              deadnix
            ];
          };
        };
    };
}

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
        rev = "aa393d57ad59552bb29e39d4d12121d6978640fa";
        ref = "main";
      };

      ghAxiSrc = builtins.fetchGit {
        url = "https://github.com/kunchenguid/gh-axi";
        rev = "151d26c914165c4928c9909740d2ed32517f7ef4";
        ref = "main";
      };

      ouroborosSrc = builtins.fetchGit {
        url = "https://github.com/Q00/ouroboros";
        rev = "231026cc1db8220a0b53551b5d312ac8f3cdfc01";
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
            ouroboros = pkgs.callPackage ./pkgs/ouroboros { src = ouroborosSrc; };
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

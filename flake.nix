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
        rev = "5213f460c1c3c52b7dee3314a525fdf933c767a2";
        ref = "main";
      };

      ghAxiSrc = builtins.fetchGit {
        url = "https://github.com/kunchenguid/gh-axi";
        rev = "8b14bcb08d9378e2390872eb6023701af4c8e42d";
        ref = "main";
      };

      ouroborosSrc = builtins.fetchGit {
        url = "https://github.com/Q00/ouroboros";
        rev = "2014af0cbce27d88c290347513dee770c8bf2f44";
        ref = "main";
      };

      codegraphSrc = builtins.fetchGit {
        url = "https://github.com/colbymchenry/codegraph";
        rev = "3cf3f2150cdb2daad3f111440977fcdb2d8bfa74";
        ref = "main";
      };

      agentmemorySrc = builtins.fetchGit {
        url = "https://github.com/rohitg00/agentmemory";
        rev = "1838f4d74c3a0accdd3764e7a8ec155cc140b831";
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
            codegraph = pkgs.callPackage ./pkgs/codegraph { src = codegraphSrc; };
            agentmemory = pkgs.callPackage ./pkgs/agentmemory { src = agentmemorySrc; };
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

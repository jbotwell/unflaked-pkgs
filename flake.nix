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
        rev = "bd57084053e561a5d718db18c80489dcd81d3f2a";
        ref = "main";
      };

      ghAxiSrc = builtins.fetchGit {
        url = "https://github.com/kunchenguid/gh-axi";
        rev = "88610533c3309b7fe67fa2cef08646a5de027aae";
        ref = "main";
      };

      ouroborosSrc = builtins.fetchGit {
        url = "https://github.com/Q00/ouroboros";
        rev = "3e382a3bff28e59bbfd04bbddde64bbf8398b6cd";
        ref = "main";
      };

      codegraphSrc = builtins.fetchGit {
        url = "https://github.com/colbymchenry/codegraph";
        rev = "8629f7ab4cf09c7542a86166a9ca9e22ac52acb7";
        ref = "main";
      };

      agentmemorySrc = builtins.fetchGit {
        url = "https://github.com/rohitg00/agentmemory";
        rev = "fd9e3bd42d6208a33f0ee9de1442fdbb60eab106";
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
            agentmemory = pkgs.callPackage ./pkgs/agentmemory {
              src = agentmemorySrc;
              iii = pkgs.callPackage ./pkgs/iii { };
            };
            agentmemory-hermes-plugin = pkgs.runCommand "agentmemory-hermes-plugin" { } ''
              mkdir -p $out
              cp -r ${agentmemorySrc}/integrations/hermes/* $out/
            '';
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

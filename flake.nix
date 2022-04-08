{
  description = "A command-line tool for tagging music";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    devshell = {
      url = "github:numtide/devshell";
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
    };
  };

  outputs = { self, nixpkgs, flake-utils, devshell, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ devshell.overlay ];
        };
        src = pkgs.lib.cleanSourceWith { filter = name: type: !(builtins.elem name [ ".github" "flake.lock" "flake.nix" ]); src = ./.; name = "source"; };
        gems = pkgs.bundlerEnv rec {
          name = "tagtag-env";
          ruby = pkgs.ruby_3_1;
          gemfile = ./Gemfile;
          lockfile = ./Gemfile.lock;
          gemset = ./gemset.nix;
          groups = [ "default" "development" "test" "production" ];
        };
        script = pkgs.writeShellScriptBin "tagger" ''
          ${gems}/bin/bundle exec ${src}/exe/tagger "$@"
        '';
      in
      {
        devShell = pkgs.devshell.mkShell {
          name = "Tagger";
          packages = [
            gems
            (pkgs.lowPrio gems.wrappedRuby)
            pkgs.bundix
            script
          ];
        };

        defaultPackage = script;
      }
    );
}

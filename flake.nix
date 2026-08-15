{
  description = "homelab dev shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        ansiblePython = pkgs.python3.withPackages (ps: with ps; [
          ansible-core
          requests
          python-dateutil
        ]);
      in
      {
        devShells.default = pkgs.mkShell {
          packages = [
            ansiblePython
            pkgs.ansible-lint
            pkgs.sops
            pkgs.age
            pkgs.teleport
          ];
        };
      });
}

{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/e48882a9bc9b4e17be2ce52579283d2626aa9930.tar.gz") { } }:

pkgs.mkShell {
  buildInputs = [
    pkgs.crystal_1_8
    pkgs.crystalline
    pkgs.ameba
    pkgs.shards
    pkgs.pcre
    pkgs.openssl
    pkgs.pkg-config
    pkgs.dprint
    pkgs.nil
    pkgs.nixpkgs-fmt
    pkgs.just
  ];
}

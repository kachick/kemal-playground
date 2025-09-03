{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    selfup = {
      url = "github:kachick/selfup/v1.1.8";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      selfup,
    }:
    let
      inherit (nixpkgs) lib;
      forAllSystems = lib.genAttrs lib.systems.flakeExposed;
    in
    {
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);
      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {

          default = pkgs.mkShell {
            # See https://github.com/crystal-lang-tools/vscode-crystal-lang/pull/209 for detail
            CRYSTAL_LSP_PATH = lib.getExe pkgs.crystalline;

            buildInputs =
              (with pkgs; [
                bashInteractive
                findutils # xargs
                nixfmt-rfc-style
                nil

                crystal_1_14
                crystalline
                ameba
                shards
                pcre
                openssl
                pkg-config
                dprint
                nil
                just
                postgresql
                rainfrog

                dprint
                typos
              ])
              ++ [ selfup.packages.${system}.default ];
          };
        }
      );
    };
}

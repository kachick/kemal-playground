{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    {
      self,
      nixpkgs,
    }:
    let
      inherit (nixpkgs) lib;
      forAllSystems = lib.genAttrs lib.systems.flakeExposed;
    in
    {
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-tree);
      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {

          default = pkgs.mkShell {
            # See https://github.com/crystal-lang-tools/vscode-crystal-lang/pull/209 for detail
            CRYSTAL_LSP_PATH = lib.getExe pkgs.crystalline;

            buildInputs = with pkgs; [
              bashInteractive
              findutils # xargs
              nixfmt
              nixfmt-tree
              nixd

              crystal
              crystalline
              ameba
              shards
              pcre
              openssl
              pkg-config
              dprint
              just
              postgresql
              rainfrog

              dprint
              typos
            ];
          };
        }
      );
    };
}

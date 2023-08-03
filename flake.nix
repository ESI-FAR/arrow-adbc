{
  description = "arrow development environment";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShells.default = pkgs.mkShell rec {
        packages = with pkgs; [
          # C++
          cmake
          glib
          gtest
          libpqxx
          ninja
          postgresql
          pkg-config
          sqlite

          # Python
          pdm
          zlib
          python310Packages.polars

          # Go
          go

          # Glib
          meson

          # Java
          maven
        ];

      # Environment variables
      # fixes libstdc++ issues, libz.so.1 issues
      LD_LIBRARY_PATH="${pkgs.stdenv.cc.cc.lib}/lib/:${pkgs.lib.makeLibraryPath packages}:/home/ole/code/arrow-adbc/build/driver/sqlite:/home/ole/code/arrow-adbc/build/driver/postgresql";

      # URI for a running PostgreSQL instance for `ctest`
      ADBC_POSTGRESQL_TEST_URI="postgresql://postgres:mysecretpassword@localhost:5432/postgres";
      };
    });
}

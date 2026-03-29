{
  nixConfig = {
    extra-substituters = [
      "https://nix-cache.fossi-foundation.org"
    ];
    extra-trusted-public-keys = [
      "nix-cache.fossi-foundation.org:3+K59iFwXqKsL7BNu6Guy0v+uTlwsxYQxjspXzqLYQs="
    ];
  };

  inputs = {
    librelane.url = "github:librelane/librelane/dev";
  };

  outputs =
    {
      self,
      librelane,
      ...
    }:
    let
      nix-eda = librelane.inputs.nix-eda;
      devshell = librelane.inputs.devshell;
      nixpkgs = nix-eda.inputs.nixpkgs;
    in
    {
      legacyPackages = nix-eda.forAllSystems (
        system:
        import nixpkgs {
          inherit system;
          overlays = [
            nix-eda.overlays.default
            devshell.overlays.default
            librelane.overlays.default
            (final: prev: {
              magic = prev.magic.override {
                version = "8.3.618";
                sha256 = "sha256-B8iZBLuSylTzcFuArhr5KM5j9eCV1+7wm9gsSWBdTmM=";
              };
            })
          ];
        }
      );

      packages = nix-eda.forAllSystems (
        system: {
          inherit (self.legacyPackages.${system}.python3.pkgs);
        }
      );

      devShells = nix-eda.forAllSystems (
        system:
        let
          pkgs = self.legacyPackages.${system};
          baseShell = pkgs.librelane-shell.override {
            extra-packages = with pkgs; [
              # Utilities
              gnumake
              gnugrep
              gawk

              # Simulation
              iverilog
              verilator
              ngspice
              xschem

              # Waveform viewing
              gtkwave
              surfer
            ];

            extra-python-packages = ps: with ps; [
              # Verification
              cocotb

              # For KLayout Python DRC runner
              docopt

              # For logo generation
              pillow
            ];
          };
        in
        {
          default = pkgs.mkShell {
            inputsFrom = [ baseShell ];

            shellHook = ''
              export PDK_ROOT="$HOME/EDA/IHP-Open-PDK"
              export PDK="ihp-sg13cmos5l"

              export KLAYOUT_PATH="$HOME/.klayout:$PDK_ROOT/$PDK/libs.tech/klayout"
              export KLAYOUT_HOME="$HOME/.klayout"

              export PATH="$PDK_ROOT/$PDK/libs.tech/xschem:$PATH"
            '';
          };
        }
      );
    };
}
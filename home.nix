{ ... }:

# The Mac entry point, imported by flake.nix's darwin wiring.
# Linux and WSL use home/common.nix + home/linux.nix instead (see flake.nix).

{
  imports = [
    ./home/common.nix
    ./home/darwin.nix
  ];
}

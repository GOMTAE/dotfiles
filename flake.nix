{
  description = "dotfiles";

  inputs = {
    # Use `github:NixOS/nixpkgs/nixpkgs-26.05-darwin` to use Nixpkgs 26.05.
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    # Use `github:nix-darwin/nix-darwin/nix-darwin-26.05` to use Nixpkgs 26.05.
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nix-homebrew, home-manager, nixpkgs }:
    let
      # The one username line to change if this isn't your machine.
      # bootstrap.sh offers to rewrite this for you if your macOS username differs.
      user = "tae";
    in
    {
      darwinConfigurations."mac" = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit user; };
        modules = [
          ./configuration.nix
          nix-homebrew.darwinModules.nix-homebrew
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "pre-nix";
            home-manager.extraSpecialArgs = { inherit user; };
            # common.nix is the user's direct module and darwin.nix goes through
            # sharedModules: this keeps the Mac's module merge order (package
            # order, .zshrc layout) and so the Mac system unchanged. Wrapping both
            # in an imports list would reorder them.
            home-manager.sharedModules = [ ./home/darwin.nix ];
            home-manager.users.${user} = import ./home/common.nix;
          }
        ];
      };

      # Linux and WSL2 (x86_64): standalone home-manager, sharing home/common.nix
      # with the Mac. Apply with:
      #   nix run home-manager -- switch --flake ~/.dotfiles#<user>@linux
      # This reuses the `nixpkgs` input above (a darwin channel branch that still
      # carries x86_64-linux packages). A separate Linux channel input can come later.
      homeConfigurations."${user}@linux" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = { inherit user; };
        modules = [
          ./home/common.nix
          ./home/linux.nix
        ];
      };
    };
}

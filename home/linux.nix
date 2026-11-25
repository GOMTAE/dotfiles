{ pkgs, user, ... }:

# Linux and WSL2 only (standalone home-manager, see flake.nix).
# On the Mac these tools come from Homebrew in configuration.nix.

{
  home.homeDirectory = "/home/${user}";

  # Makes Nix-installed apps behave on non-NixOS distros (XDG dirs, fonts, etc).
  targets.genericLinux.enable = true;

  # What hq needs (decision 0003).
  # bubblewrap is deliberately NOT here: Ubuntu 24.04's AppArmor only lets the
  # apt-installed /usr/bin/bwrap create user namespaces, a Nix-store bwrap is
  # denied. Install it with `sudo apt install bubblewrap socat`.
  home.packages = with pkgs; [
    python3
    git
    gh
    tmux
    nodejs
    jq
  ];

  # npm global installs go to a user-writable prefix (the Nix store is read-only).
  home.sessionVariables.NPM_CONFIG_PREFIX = "$HOME/.npm-global";
  home.sessionPath = [
    "$HOME/.npm-global/bin"
    "$HOME/.local/bin"
  ];
}

{ config, user, ... }:

# macOS-only parts of the home-manager config.

let
  dotfiles = "${config.home.homeDirectory}/.dotfiles";
in

{
  home.homeDirectory = "/Users/${user}";

  # WezTerm runs natively on the Mac. On WSL it runs on the Windows side
  # (with its own config there), and Ubuntu laptops are not set up with it.
  home.file.".config/wezterm".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/wezterm";
}

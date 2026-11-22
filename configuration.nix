{ pkgs, user, ... }:

{
  # Determinate already manages the Nix daemon, so nix-darwin shouldn't.
  nix.enable = false;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "aarch64-darwin"; # use x86_64-darwin for Intel CPU

  system.primaryUser = user;
  users.users.${user} = {
    home = "/Users/${user}";
  };
  system.stateVersion = 6;
  system.defaults = {
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      KeyRepeat = 2;          # fast key repeat
      InitialKeyRepeat = 15;  # short delay before repeat
      _HIHideMenuBar = true;  # auto-hide the menu bar
      AppleShowAllExtensions = true;
    };
    dock.autohide = true;
    finder.FXPreferredViewStyle = "Nlsv";  # list view by default
    finder.CreateDesktop = false;          # clean desktop
    trackpad.Clicking = true;              # tap to click
  };
  nix-homebrew = {
    enable = true;
    inherit user;
    autoMigrate = true;
  };
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";  # remove anything not listed here
    onActivation.autoUpdate = true;
    onActivation.extraFlags = [ "--force" ];
    brews = [
      "gcc"
      "gh"
      "git-lfs"
      "gnu-sed"
      "herdr"
      "jpeg-turbo"
      "libomp"
      "node"
      "portaudio"
      "pre-commit"
      "rustup"
      "tmux"
      "tree"
    ];
    casks = [
      "claude-code"
      "codexbar"
      "copilot-cli"
      "devtoys"
      "maccy"
      "visual-studio-code"
      "wezterm"
    ];
  };
  # Claude Code baseline (decision 0003): managed settings, not the user file.
  system.activationScripts.postActivation.text = let
    claudeManaged = pkgs.writeText "claude-managed.json" (builtins.toJSON {
      env = {
        IMPECCABLE_NO_TELEMETRY = "1";
        PLANNOTATOR_SHARE = "disabled";
      };
      extraKnownMarketplaces = {
        plannotator.source = { source = "github"; repo = "backnotprop/plannotator"; };
        anthropic-agent-skills.source = { source = "github"; repo = "anthropics/skills"; };
      };
    });
  in ''
    install -d -m 755 "/Library/Application Support/ClaudeCode/managed-settings.d"
    install -m 644 ${claudeManaged} \
      "/Library/Application Support/ClaudeCode/managed-settings.d/10-dotfiles.json"
  '';
}

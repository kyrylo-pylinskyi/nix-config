{
  description = "Enpapilotte Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew }:
  let
  configuration = { pkgs, config, ... }: {

      nixpkgs.config = {
      allowUnfree = true;
      allowBroken = true;
    };
    # List packages installed in system profile. To search by name, run:
    # $ nix-env -qaP | grep wget
    environment.systemPackages = [ 
      pkgs.neovim
      pkgs.mkalias
      pkgs.tmux
      pkgs.brotli
      pkgs.c-ares
      pkgs.cacert
      pkgs.gettext
      pkgs.icu
      pkgs.openssl
      pkgs.krb5
      pkgs.libunistring
      pkgs.libidn2
      pkgs.libnghttp2
      pkgs.libuv
      pkgs.lz4
      pkgs.mpdecimal
      pkgs.ncurses
      pkgs.nodejs
      pkgs.pcre
      pkgs.readline
      pkgs.postgresql
      pkgs.sqlite
      pkgs.xz
      pkgs.python3
      pkgs.wget
      pkgs.zsh
      pkgs.oh-my-posh
      pkgs.cling
      pkgs.git
      pkgs.gcc
    ];

    homebrew = {
      enable = true;
			brews = [
				"mas"
			];
      casks = [
        "hammerspoon"
        "firefox"
        "thunderbird"
        "iina"
        "the-unarchiver"
        "zed"
        "tunnelblick"
        "sourcetree"
        "postman"
        "visual-studio-code"
        "alacritty"
        "obsidian"
				"telegram-desktop"
      ];
      # Ensure to specify the cleanup correctly or remove it if not needed
      onActivation.cleanup = "zap";
			onActivation.autoUpdate = true;
			onActivation.upgrade = true;
    };

    fonts.packages = [
      (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];

    system.activationScripts.applications.text = let
    env = pkgs.buildEnv {
      name = "system-applications";
      paths = config.environment.systemPackages;
      pathsToLink = "/Applications";
    };
    in
    pkgs.lib.mkForce ''
      # Set up applications.
      echo "setting up /Applications..." >&2
      rm -rf /Applications/Nix\ Apps
      mkdir -p /Applications/Nix\ Apps
      find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
      while read src; do
        app_name=$(basename "$src")
        echo "copying $src" >&2
        ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
      done
    '';

		system.defaults = {
			dock.autohide = true;
			dock.persistent-apps = [
				"System/Applications/Calendar.app"
				"System/Applications/Mail.app"
				"Applications/Firefox.app"
				"Applications/Docker.app"
				"Applications/Visual Studio Code.app"
				"Applications/Zed.app"
				"Applications/Alacritty.app"
			];
			finder.FXPreferredViewStyle = "clmv";
			loginwindow.GuestEnabled = false;
			NSGlobalDomain.AppleICUForce24HourTime = true;
			NSGlobalDomain.AppleInterfaceStyle = "Dark";
			NSGlobalDomain.KeyRepeat = 2;
		};

    # Auto upgrade nix package and the daemon service.
    services.nix-daemon.enable = true;
    # nix.package = pkgs.nix;

    # Necessary for using flakes on this system.
    nix.settings.experimental-features = "nix-command flakes";

    # Create /etc/zshrc that loads the nix-darwin environment.
    programs.zsh.enable = true;  # default shell on catalina
    # programs.fish.enable = true;

    # Set Git commit hash for darwin-version.
    system.configurationRevision = self.rev or self.dirtyRev or null;

    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    system.stateVersion = 5;

    # The platform the configuration will be used on.
    nixpkgs.hostPlatform = "x86_64-darwin";
  };

  in {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#enpapilotte
    darwinConfigurations."enpapilotte" = nix-darwin.lib.darwinSystem {
      modules = [ 
        configuration
        nix-homebrew.darwinModules.nix-homebrew {
          nix-homebrew = {
            # Install Homebrew under the default prefix
            enable = true;

            # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
            # enableRosetta = true;

            # User owning the Homebrew prefix
            user = "mac";

            # Automatically migrate existing Homebrew installations
            autoMigrate = true;
          };
        }
			];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."enpapilotte".pkgs;
  };
}

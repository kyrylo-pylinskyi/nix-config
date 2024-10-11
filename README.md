### README for `nix.flake`

This repository contains the flake configuration for managing the Darwin (macOS) system setup using Nix and nix-darwin. It includes system-level packages, homebrew packages, font configurations, system defaults, and a nix-darwin setup for automated package management and configuration. Below is a description of all packages, configurations, and services defined in this `flake.nix`.

---

#### Flake Overview

- **Description**: `Enpapilotte Darwin system flake`
- **Platform**: `x86_64-darwin`
- **Main Tools**: `nix-darwin`, `nix-homebrew`
- **Packages**: System packages, Homebrew packages (casks, brews), and MAS apps
- **Fonts**: `nerdfonts` (JetBrainsMono)
- **System Services**: Nix daemon auto-upgrade, Zsh shell configuration, System defaults setup

---

### Input Dependencies

1. **nixpkgs** (`nixpkgs-unstable`):
   - Provides access to the unstable package set of Nixpkgs.
   
2. **nix-darwin**:
   - Framework to manage macOS system configurations using Nix.

3. **nix-homebrew**:
   - Allows the usage of Homebrew packages within the Nix ecosystem, integrating both Homebrew and Nix seamlessly.

---

### System Configuration

The core system configuration includes several elements like environment variables, system-level packages, Homebrew integration, system defaults, and more.

#### 1. **System Packages**

The following packages are installed in the system profile through `environment.systemPackages`:

- **Development Tools**: `neovim`, `tmux`, `gcc`, `git`, `nodejs`, `python3`
- **Libraries**: `brotli`, `c-ares`, `gettext`, `icu`, `openssl`, `krb5`, `libunistring`, `libidn2`, `libnghttp2`, `libuv`, `lz4`, `mpdecimal`, `ncurses`, `pcre`, `readline`, `postgresql`, `sqlite`, `xz`
- **Utilities**: `wget`, `zsh`, `cling`, `oh-my-posh`
- **Security**: `cacert`
  
These packages are a mix of essential libraries, programming tools, and utilities that cover development, networking, and system management.

#### 2. **Homebrew Packages**

The `homebrew` section enables the use of both standard Homebrew formulas and casks (applications) along with Mac App Store (MAS) apps:

- **Brews**:
  - `mas` (Mac App Store CLI)
  
- **Casks** (GUI applications):
  - `hammerspoon`, `firefox`, `thunderbird`, `iina`, `the-unarchiver`, `zed`, `tunnelblick`, `sourcetree`, `postman`, `visual-studio-code`, `alacritty`, `obsidian`

- **MAS Apps**:
  - `Telegram` (ID: 747648890)

#### Homebrew Settings:
- **Auto-update and upgrade** are enabled upon activation.
- **Cleanup** is set to `zap` to remove old versions and free up space.

#### 3. **Font Configuration**

- **Nerd Fonts**:
  - JetBrainsMono is installed using `nerdfonts` from the Nixpkgs repository.

#### 4. **System Defaults**

The configuration sets up system defaults through the `system.defaults` section:

- **Dock**:
  - `dock.autohide = true`
  - `dock.persistent-apps`: Applications such as Calendar, Mail, Firefox, Docker, Visual Studio Code, Zed, and Alacritty are pinned in the dock.

- **Finder**:
  - `FXPreferredViewStyle = clmv`: Finder is set to Column view mode by default.

- **Login Window**:
  - Guest login is disabled: `loginwindow.GuestEnabled = false`

- **Global Preferences**:
  - Time format is forced to 24-hour: `NSGlobalDomain.AplleICUForce24HourTime = true`
  - System theme is set to Dark Mode: `NSGlobalDomain.AppleInterfaceStyle = Dark`
  - Key repeat rate is set to fast: `NSGlobalDomain.KeyRepeat = 2`

#### 5. **System Activation Scripts**

A custom activation script is included to set up macOS applications in `/Applications/Nix Apps`. This script uses `mkalias` to create aliases of Nix-installed applications, ensuring they are available in the standard macOS Applications folder.

#### 6. **Nix Settings**

- **Auto-upgrade Nix Daemon**:
  - The `nix-daemon` service is enabled and set to automatically upgrade itself.
  
- **Enable Flakes**:
  - The Nix configuration enables experimental features like `nix-command` and `flakes`.

#### 7. **Shell Configuration**

- **Zsh** is enabled as the default shell.
  
---

### How to Build and Use the Flake

To build and apply this configuration to your macOS system using `nix-darwin`:

```bash
darwin-rebuild build --flake .#enpapilotte
```

---

### Conclusion

This `nix.flake` provides a flexible macOS system configuration that integrates the power of Nix with Homebrew, system defaults, and modern package management techniques. The setup is particularly suited for developers and power users who want a reproducible environment with automated updates, Homebrew compatibility, and pre-configured development tools.
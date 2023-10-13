{ config, pkgs, lib, ... }:

let
  desktopPkgs = with pkgs; [
    spotify
    lxrandr
    i3lock-fancy
    flameshot
    syncthing
    nitrogen
    thunderbird
    vlc
    discord
    dotnet-sdk_7
    arandr
    autorandr
    networkmanagerapplet
    kicad-small
    libreoffice
    evince
    freecad
    cups
  ];

  environment.systemPackages = with [
    fish
    kitty
  ];

  shellPkgs = with pkgs; [
    # Shell
    any-nix-shell
    gcc
    grc
    curl
    wget
    delta

    # Utility
    htop
    cheat
    neofetch
    lsd
    bat
    netcat
    feh
    pulsemixer
    ranger
    rnix-lsp
    clang-tools
    zip
    unzip

    # Man
    clang-manpages
    man-pages
    man-pages-posix

    # Python
    # python39Packages.poetry
    (python39.withPackages (ps: with ps; [ pip pandas ]))
  ];

  npmPkgs = with pkgs.nodePackages; [
    typescript-language-server
    typescript
    js-beautify
    node2nix
  ];

in {
  programs.home-manager.enable = true;

  nixpkgs.config = { allowUnfree = true; };

  home = {
    username = "victor.flament";
    homeDirectory = "/home/victor.flament";

    packages = desktopPkgs ++ shellPkgs ++ npmPkgs ++ systemPackages;
    stateVersion = "22.05";
  };

  home.keyboard = { layout = "gb"; };

  imports = [
    ./services/syncthing/default.nix
    ./services/polybar/default.nix
  ];

  systemd.user.services.mpris-proxy = {
    Unit.Description = "Mpris proxy";
    Unit.After = [ "network.target" "sound.target" ];
    Service.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
    Install.WantedBy = [ "default.target" ];
  };

  xsession.windowManager.i3 =
    import ./services/i3/default.nix { inherit pkgs lib; };
}

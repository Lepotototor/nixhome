{ config, pkgs, lib, ... }:

let
  desktopPkgs = with pkgs; [
    spotify
    i3lock-fancy
    syncthing
    nitrogen
    vlc
    discord
    arandr
    autorandr
    networkmanagerapplet
    libreoffice
  ];

  environment.systemPackages = with pkgs; [
    fish
    starship
    kitty
    vim
    pfetch
  ];

  shellPkgs = with pkgs; [
    # Shell
    gcc
    grc
    curl
    wget

    # Utility
    htop
    neofetch
    lsd
    bat
    netcat
    pulsemixer
    ranger
    rnix-lsp
    zip
    unzip

    # Man
    clang-manpages
    man-pages
    man-pages-posix

  ];


in {
  programs.home-manager.enable = true;

  nixpkgs.config = { allowUnfree = true; };

  home = {
    username = "victor.flament";
    homeDirectory = "/home/victor.flament";

    packages = desktopPkgs ++ shellPkgs ++ environment.systemPackages;
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

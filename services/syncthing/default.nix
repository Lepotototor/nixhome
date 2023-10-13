{ lib, pkgs, config, ... }:

let home_path = "/home/victor.flament";
in { services.syncthing = { enable = true; }; }

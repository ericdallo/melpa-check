{ pkgs ? import <nixpkgs> {},
  emacs ? import ./emacs.nix
}:
let
  check-package = import ../.;
in check-package {
  inherit emacs pkgs;
  name = "emacs-package-checker-hello";
  sourceDir = ./.;
  sourceFiles = ["hello.el"];
  dependencies = epkgs: (with epkgs.melpaStablePackages; [
    dash
  ]);
}

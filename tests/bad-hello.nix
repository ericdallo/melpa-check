{ pkgs ? import <nixpkgs> {}, emacs ? import ./emacs.nix }:
let
  check-package = import ../.;
in check-package {
  inherit emacs pkgs;
  name = "emacs-package-checker-bad-hello";
  sourceDir = ./.;
  sourceFiles = ["bad-hello.el"];
  dependencies = epkgs: [];
}

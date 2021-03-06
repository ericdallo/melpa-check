# Since package-lint requires the internet connection to test
# if dependencies are installable, you can only run this command
# in nix-shell, and not in nix-build.
{ pkgs, emacsDerivation }:
package:
with (import ../lib);
let
  emacsWithPackagesDrv = (emacsWithPackages emacsDerivation (epkgs:
    (package.dependencies epkgs) ++ [ epkgs.melpaPackages.package-lint ]));

  drv = pkgs.stdenv.mkDerivation {
    name = package.pname + "-package-lint";
    buildInputs = [ emacsWithPackagesDrv ];
    shellHook = let
      # Assume the items of files never contain space
      localDeps = pkgs.lib.concatMapStringsSep " " (pkg: pkg.pname)
        (package.localDependencies or [ ]);
      mainFile =
        # package.mainFile can be null if the package is converted
        # from Dhall, so the null check is necessary.
        if package ? mainFile && !(isNull package.mainFile) then
          package.mainFile
        else
          "";
    in ''
      echo
      echo ==========================================================
      echo package-lint on ${package.pname} package
      echo ==========================================================
      cd ${package.src}
      emacs --no-site-file --batch \
         --eval "(setq explicitly-installed-packages '(${localDeps}))" \
         --eval "(setq package-lint-main-file \"${mainFile}\")" \
         -l ${./package-lint-runner.el} ${concatShArgs package.files}
      result=$?
      echo ----------------------------------------------------------
      if [[ $result -eq 0 ]]; then
        echo "No package-lint errors found."
      else
        echo "Errors found by package-lint."
      fi
      # Prevent from actually entering the shell
      exit $result
    '';
  };
in drv // { inherit emacsWithPackagesDrv; }


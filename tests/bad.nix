{ emacs ? import ./emacs.nix,
# In typical situation, this should be ./.
srcDir ? ../., packageFile ? "tests/bad-packages.dhall" }:
import ../. { inherit emacs packageFile srcDir; }

/* It is assumed that propagated dependencies are included in the poetryPackages.
  The "certifi" is direct dependency of "requests" library.

  Note: this test assumes that "certifi" lib is going to be a dep of "requests" in the future.
*/
{ lib, poetry2nix, python3 }:
let
  inherit (builtins) elem map;
  drvPythonCurrent = poetry2nix.mkPoetryPackages {
    projectDir = ./.;
    python = python3;
  };

  # Test backward compatibility
  drvPython37 = poetry2nix.mkPoetryPackages {
    projectDir = ./.;
    python = python3;
  };

  packageNamesCurrent = map (package: package.pname) drvPythonCurrent.poetryPackages;
  packageNamesPython37 = map (package: package.pname) drvPython37.poetryPackages;
in
assert builtins.elem "certifi" packageNamesCurrent;
assert builtins.elem "certifi" packageNamesPython37;
drvPythonCurrent

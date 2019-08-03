let
  nixpkgs = import ./nixpkgs.nix;
in
  nixpkgs.haskellPackages.callCabal2nix "how-does-servants-type-dsl-work" ./. {}

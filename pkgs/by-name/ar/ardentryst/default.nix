{ pkgs ? import <nixpkgs> {} }:
{
 ardentryst = pkgs.callPackage ./package.nix { };
}

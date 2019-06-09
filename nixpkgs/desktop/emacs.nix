{ pkgs ? import <nixpkgs> {} }:

let
  emacsWithPackages = (pkgs.emacsPackagesNgGen pkgs.emacs).emacsWithPackages;
in
  emacsWithPackages (epkgs: (with epkgs.melpaStablePackages; [
    magit          # ; Integrate git <C-x g>
  ]) ++ (with epkgs.melpaPackages; [
    epkgs.undo-tree      # ; <C-x u> to show the undo tree
  ]) ++ (with epkgs.elpaPackages; [
    beacon         # ; highlight my cursor when scrolling
  ]) ++ [
    # pkgs.notmuch   # From main packages set
    epkgs.tuareg
    #epkgs.haskell-mode
    #epkgs.ghc-mod
  ])

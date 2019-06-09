let maxBipartiteMatching = { mkDerivation, base, containers, fgl, fgl-arbitrary, QuickCheck, stdenv }:
mkDerivation {
  pname = "maxBipartiteMatching";
  version = "0.1.0.0";
  src = /home/rotsor/haskell/codejam/maxBipartiteMatching-0.1.0.0;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [ base containers fgl-arbitrary  ];
  executableHaskellDepends = [ base containers fgl-arbitrary  ];
  testHaskellDepends = [ base containers fgl fgl-arbitrary QuickCheck ];
  homepage = "http://stefan-klinger.de/";
  description = "Maximum cardinality bipartite matching";
  license = "unknown";
  doCheck = false; # tests are broken
}; in

{
  allowUnfree = true;
  chromium = { enableWideVine = false; };
  packageOverrides = super: let pkgs = super.pkgs; in
  let
    pkgs_for_agda = import <nixpkgs> { overlays = [
        (self: super:
let pkgs = super; in
let hp = pkgs.haskellPackages.override {
        overrides = new: old: rec {
	  async = old.async;
	  Agda = old.Agda;
	};
      };
in
let agda = pkgs.callPackage <nixpkgs/pkgs/build-support/agda> {
    glibcLocales = if pkgs.stdenv.isLinux then pkgs.glibcLocales else null;
    extension = self : super : { };
    inherit (hp) Agda;
  };
in
{
  haskellPackages = hp;
  agda = agda;
})
      ]; }; in
  
  rec {
    haskellEnv2 =
      pkgs.buildEnv {
        name = "haskell-env2";
        paths = [
           (pkgs_for_agda.haskellPackages.ghcWithPackages (p: with p; [
           xmonad-contrib xmonad-extras xmonad parsec MemoTrie vector-space
           hmatrix matrix parallel eigen # 2017-10-05: [eigen] doesn't work: missing dependencies: [vector]
           aeson # 2017-10-05: [haskoin-wallet] doesn't work: something wrong with dependencies
           # (callPackage maxBipartiteMatching {})
           Agda vulkan
        ]))
        pkgs_for_agda.AgdaStdlib      
        ];
        };

    haskellEnv3 =
      pkgs.haskell.packages;


#    wheeledVehicle =

    # big optional packages
    rotsorExtras_2017_10 = pkgs.buildEnv {
      name = "rotsor-extras-2017-10";
      paths = with pkgs; [
        mono
	octave
	fsharp
	bitcoin
	vagrant
	wine
	steam
	skype
	gnome3.gnome_terminal
      ];
    };

    rotsorEnv_2017_10 = pkgs.buildEnv {
      name = "rotsor-env-2017-10";
      paths = with pkgs; [
        alg
	bc
	cabal2nix
	chromium

	dmenu # should really only be accessible to xmonad
	electrum
	evince
	file
	geeqie
	gimp
	glxinfo
	htop
	inkscape
	ag
	keepass
	libreoffice
	lynx
	mplayer
	nix-prefetch-svn
	opam
	openjdk
	openssh
	openssl
	patchelf
	pavucontrol
	pciutils
	rlwrap
	# rotsor-agda
	rxvt
	sqlite
	sshfs-fuse
	st
	subversion
	traceroute
	unrar
	w3m
	wget
	xclip
	youtube-dl
	xfce.terminal

	# agda
      ];
    };

    my_own_ocaml = pkgs.callPackage <nixpkgs/development/compilers/ocaml/4.07.nix> { };
    rotsorEnv = pkgs.buildEnv {
      name = "rotsor-env";
      paths = [
        pkgs.haskellEnv2
        pkgs.AgdaStdlib	
	my_own_ocaml
	# pkgs.ocaml-ng.ocamlPackages_4_04.ocaml
      ];
    };

    fooemacs = import ./emacs.nix { pkgs = pkgs; };

    openttd-reddit = import ./openttd.nix pkgs;
    alg = import ./alg.nix pkgs;

    rotsor-agda = pkgs.buildEnv {
      name = "rotsor-agda";
      paths = [
        # pkgs.haskellPackages.
	# pkgs.haskellPackages.
        # agdaBase
        # agdaIowaStdlib
	# agdaPrelude
   	pkgs.AgdaStdlib
  	# AgdaSheaves
	# bitvector
	# categories
	# pretty
	# TotalParserCombinators
      ];
    };

    factorio = super.factorio.override {
      username = "rotsor";
      token = "4c13a0b64dc3575ada2813ddb339ff";
    };
  };
}


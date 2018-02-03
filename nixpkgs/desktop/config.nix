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
  rec {
    haskellEnv2 = pkgs.haskellPackages.ghcWithPackages (p: with p; [
      xmonad-contrib xmonad-extras xmonad parsec MemoTrie vector-space
      hmatrix matrix parallel eigen # 2017-10-05: [eigen] doesn't work: missing dependencies: [vector]
      aeson # 2017-10-05: [haskoin-wallet] doesn't work: something wrong with dependencies
      # (callPackage maxBipartiteMatching {})
      Agda
    ]);


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
	myEmacs
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

    rotsorEnv = pkgs.buildEnv {
      name = "rotsor-env";
      paths = [
        pkgs.haskellEnv2
        pkgs.emacsPackages.ocamlMode
	pkgs.ocaml-ng.ocamlPackages_4_04.ocaml
      ];
    };

    myEmacs = pkgs.emacsWithPackages (with
      pkgs.emacsPackagesNg; [
        # 2017-10-05: structured-haskell-mode doesn't seem to work
        ghc-mod haskell-mode
	]);

    openttd-reddit = import ./openttd.nix pkgs;
    alg = import ./alg.nix pkgs;

    rotsor-agda = pkgs.buildEnv {
      name = "rotsor-agda";
      paths = [
        pkgs.haskellPackages.Agda
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

    factorio = pkgs.callPackage ./factorio.nix { releaseType = "alpha"; username = "rotsor+factorio@gmail.com"; password = "w6qQmCBYbHmemUchKieP"; };
    factorio_0_15 = pkgs.callPackage ./factorio-0.15.nix { releaseType = "alpha"; username = "rotsor+factorio@gmail.com"; password = "rotsor+factorio"; };
    factorio_0_16 = pkgs.callPackage ./factorio-0.16.nix { releaseType = "alpha"; username = "rotsor+factorio@gmail.com"; password = "rotsor+factorio"; };
  };
}

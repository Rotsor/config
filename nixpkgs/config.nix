{
  chromium = {
  #  enableGoogleTalkPlugin = true;
  #  jre = true;
  #  enableMPlayer = true;
    enableDjvu = true;
    enableQuakeLive = true;
  };
  allowUnfree = true;
  firefox = {
    enableQuakeLive = true;
    enableGnash = false;
    enableAdobeFlash = true;
  };
  cabal.libraryProfiling = true;
  packageOverrides = pkgs : 
    let 
      haskellPkgs = self : with self; rec {
        standardPkgs = [ MemoTrie xmonad xmonadContrib xmonadExtras stm mtl void scientific Agda HsOpenSSL linear MemoTrie dataBinaryIeee754 diagrams  ];  # [ xmonad xmonadContrib xmonadExtras QuickCheck text OpenAL OpenGLRaw xml HaXml filepath csv pandoc gtk2hsC2hs cairo pango gio gtk glade Crypto tagsoup ansiTerminal regexTdfa deepseq X11 SHA curl httpConduit GLFW json shake lens cabalInstall criterion diagrams MaybeT MissingH HFuse vacuum vacuumGraphviz geniplate hashtables strict yesod yesodDefault dataHash haskellSrcExts JuicyPixels freetype2 gloss ]; # diagramsGtk criterion diagrams  STMonadTrans 
# regexPCRE   boxes equivalence darcs  diagramsCairo
        customPkgs = [ fingertree ]; #suave ];
	# yesod yesodDefault 
        allPkgs = standardPkgs; #[ xmonad xmonadContrib xmonadExtras
	# QuickCheck
	# ]; # customPkgs ++ standardPkgs;
      };
    in
    with pkgs;
    let myEnv = envName : envPaths : buildEnv {
      name = envName;
      paths = envPaths;
    }; in
    rec {
    
#    perl = pkgs.stdenv.lib.overrideDerivation pkgs.perl (oldAttrs : {
#         dontStrip = true;
#       });

    hsMain = pkgs.haskellPackages_ghc783.ghcWithPackagesOld (self : (haskellPkgs self).allPkgs /*standardPkgs*/);
    hsCodeforces = pkgs.haskellPackages_ghc763.ghcWithPackages (self : with self; []);
    hsEnv = hsMain; # hsMain;
    devEnv = myEnv "rotsor-dev" [
#        gcc
        hsEnv
	gdb
	mono
	jdk
	php
	scala
	rust
#	texLive
      ];
    tryingOut = myEnv "rotsor-trying-out" [
        retroshare st
      ];
    myCoreTools = myEnv "rotsor-core" [
        curl
        emacs
	emacs24Packages.haskellMode
	subversion
	(myEnv "git-annex" [ (git.override { guiSupport = true; }) lsof ])
	gitAndTools.gitAnnex
	irssi
	jwhois
	mc
	meld
	rlwrap
	sshfsFuse
	tmux
	ts
	wget
	which
	wine
	zip
	zsh
	nix
	keepass
	file
	gnupg
      ];
    myFun = myEnv "rotsor-fun" [
      	stellarium
	xboard
	kde4.kdegames
	gnuchess
    ];
    mySystemTools = myEnv "rotsor-system-tools" [
	telnet
	iotop
	lm_sensors
	patchelf
	pmutils # power management
	tor
	unetbootin
	unrar
	unzip
	vde2
      ];

    allFonts = buildEnv { name = "all-fonts"; paths = [
    wqy_zenhei vistafonts unifont ubuntu_font_family ttf_bitstream_vera tipa terminus_font tempora_lgc theano oldstandard mph_2b_damase lmodern lmmath libertine junicode inconsolata gentium freefont_ttf dosemu_fonts dejavu_fonts cm_unicode corefonts cantarell_fonts bakoma_ttf anonymousPro andagii clearlyU # ucsFonts # ucsFonts excluded because they are raster fonts chosen by fontconfig instead of vector fonts # arkpandora_ttf 
    ]; ignoreCollisions = true; };
    myFonts = myEnv "rotsor-fonts" [
/*        unifont
	ubuntu_font_family
	corefonts
	terminus_font */
	allFonts
      ];
    myDesktopTools = myEnv "rotsor-desktop" [
        aspell
        aspellDicts.ru
        aspellDicts.en
	dmenu
	scrot
#	skype
        evince
	firefoxWrapper
	geeqie
	mcomix
	ghostscriptX
	gimp_2_8
	gimpPlugins.lqrPlugin
	glxinfo
	graphicsmagick
	graphviz
	inkscape
	kde4.kdiff3
	kde4.ktorrent
	libreoffice
	lyx
	mplayer2
	vlc
	trayer
	xdg_utils
	xfce.terminal
	gnome3_12.gnome_terminal
	xvidcap
	chromiumBeta
	youtubeDL
	xfig
	thunderbird
    ];
    rotsorEnv = myEnv "rotsor-env" [
        myFonts
	myDesktopTools
	mySystemTools
	myFun
	myCoreTools
	devEnv
	tryingOut
#	feh
#	
#	freetalk
#	gensgs
#	gftp
#	glib
#	glpk
#	gnumake
#	gnunet
#	gnuplot
#	gravit
#	gtk3
#	gtkdialog
#	guile
#	kde4.gwenview
#	hplip
#	inotifyTools
#	quake3game
#	libpng
#	librsvg
#	xlibs.libICE
#	xlibs.libSM
#	xlibs.libX11
#	xlibs.libXtst
#	gnome.libsoup
#	libtorrent
#	libx86
#	mesa
#	mpd
#	nbd
#	ncurses
#	ntop
#	octave
#	openal
#	openssl
#	openvpn
#	p7zip
#	gnome.pango
#	pidgin
#	pkgconfig
#	pptp
#	pulseaudio
#	pv
#	pyqt4
#	python27Full
#	python27Packages.numpy
#	kvm
#	kde4.qt4
#	quake3demo
#	rLang # statistical software
#	rpPPPoE
#	samba
#	SDL
#	SDL_image
#	SDL_mixer
#	smartmontools
#	tesseract
# texLiveFull
#	tftp_hpa
#	timidity
#	transmission
#	(callPackage ../.nix-defexpr/channels/nixpkgs/pkgs/applications/networking/p2p/transmission 
#	{ enableGtk = true; gtk = gtk3; }
#	)
#	vde2
#	vs90wrapper
#	w3m
#	webkit
#	wxGTK29
#	x264
#	xlibs.xf86inputsynaptics


#	x11
#	xlibs.xproto
#	xlibs.xrandr
#	xsane
#	zlib
      ];
  };
}

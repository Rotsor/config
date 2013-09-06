{
  chromium = {
    enableGoogleTalkPlugin = true;
    jre = true;
  #  enableMPlayer = true;
    enableDjvu = true;
    enableQuakeLive = true;
  };
  firefox = {
    enableQuakeLive = true;
    enableGnash = true;
    enableAdobeFlash = false;
  };
#  cabal.libraryProfiling = false;
  packageOverrides = pkgs : 
    let 
      haskellPkgs = self : with self; rec {
        standardPkgs = [ haskellPlatform xmonad xmonadContrib xmonadExtras QuickCheck text darcs OpenAL OpenGLRaw xml HaXml filepath csv pandoc gtk2hsC2hs cairo pango gio gtk glade Crypto MemoTrie tagsoup ansiTerminal yesod regexTdfa deepseq X11 yesodDefault SHA curl httpConduit GLFW json regexPCRE shake lens Agda criterion diagrams diagramsCairo diagramsGtk MaybeT MissingH ]; # criterion diagrams Agda
        customPkgs = [ suave ];
        allPkgs = customPkgs ++ standardPkgs;
      };
    in
    with pkgs;
    let myEnv = envName : envPaths : buildEnv {
      name = envName;
      paths = envPaths;
    }; in
    rec {
    hsEnv = pkgs.haskellPackages.ghcWithPackages (self : (haskellPkgs self).allPkgs /*standardPkgs*/);
    devEnv = myEnv "rotsor-dev" [
        hsEnv
	gdb
	mono
	jdk
	php
	scala
	texLive
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
	patchelfUnstable
	pmutils # power management
	tor
	unetbootin
	unrar
	unzip
	vde2
      ];

    allFonts = buildEnv { name = "all-fonts"; paths = [
    wqy_zenhei vistafonts unifont ucsFonts ubuntu_font_family ttf_bitstream_vera tipa terminus_font tempora_lgc theano oldstandard mph_2b_damase lmodern lmmath libertine junicode inconsolata gentium freefont_ttf dosemu_fonts dejavu_fonts cm_unicode corefonts cantarell_fonts bakoma_ttf arkpandora_ttf anonymousPro andagii clearlyU
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
	skype
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
	mplayer
	vlc
	trayer
	xdg_utils
	xfce.terminal
	xvidcap
	chromiumDevWrapper
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

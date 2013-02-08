{
  cabal.libraryProfiling = true;
  packageOverrides = pkgs : 
    let 
      haskellPkgs = self : with self; rec {
        standardPkgs = [ haskellPlatform xmonad xmonadContrib xmonadExtras criterion QuickCheck text darcs OpenAL OpenGLRaw xml HaXml unorderedContainers filepath csv pandoc gtk2hsC2hs cairo pango gio gtk glade Crypto MemoTrie tagsoup ansiTerminal yesod regexTdfa deepseq X11 yesodDefault SHA curl httpConduit GLFW Agda json diagrams regexPCRE ];
        customPkgs = [ GLFWb bencode primes pqueue hmm ];
        allPkgs = customPkgs ++ standardPkgs;
      };
    in
    {
    hsEnv = pkgs.haskellPackages.ghcWithPackages (self : (haskellPkgs self).standardPkgs);
 #   myHsEnv = pkgs.haskellPackages.ghcWithPackages (self : (haskellPkgs self).allPkgs);
/*    qhaskell = pkgs.buildEnv {
      name = "qhaskell-7.4.1";
      paths = with pkgs.haskellPackages; [ghc xmonad xmonadContrib xmonadExtras criterion QuickCheck text Agda AgdaExecutable darcs OpenAL OpenGLRaw GLFWb xml HaXml unorderedContainers filepath csv pandoc gtk2hsC2hs cairo pango gio gtk bencode glade Crypto pqueue MemoTrie hmm tagsoup ansiTerminal yesod acidState];
    };*/
# {-   haskell7_4_1 = pkgs.buildEnv {
#      name = "qhaskell-7.4.1";
#      paths = with pkgs.haskellPackages_ghc741; [ghc random QuickCheck text criterion];
#    }; -}
  };
}

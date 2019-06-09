pkgs:
with pkgs;
let
  src = /home/rotsor/repos/alg; /* pkgs.fetchgit {
        url = /home/rotsor/repos/alg;
        rev = "c78ab340096bce5d324ba76a9b30763c7534703c";
        sha256 = "1rqlpn7hw8xvsn4hhwqlqjdarwpw6p77nccgjf4xgcaxkf07ng3a";
      }; */
in
pkgs.stdenv.mkDerivation {
  name = "alg";

  src = src;

  nativeBuildInputs = [ makeWrapper ocaml git ocamlPackages.ocamlbuild ocamlPackages.menhir ];

  preConfigure = ''
    mkdir -p "$out"/bin
    sed "s_/bin/cp_cp_g; s#INSTALL_DIR=/usr/local/bin#INSTALL_DIR=$out/bin#" -i Makefile distro/Makefile src/Makefile
  '';

  buildInputs = [  ];

  meta = with stdenv.lib; {
    description = "Alg";
    longDescription = ''
      Alg
    '';
    homepage = https://github.com/andrejbauer/alg;
    license = licenses.bsd2;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ ];
    hydraPlatforms = [];
  };
}

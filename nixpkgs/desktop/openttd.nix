pkgs:
with pkgs;
let
  reddit_client = rec {
    version = "27534";
    src = pkgs.fetchsvn {
        url = "svn://svn.openttd.org/trunk";
        rev = version;
#	ignoreKeywords = true;
        sha256 = "0nbn2m8il74jwiymq15z6z68q1mrqmafvzr2id4ajphcdhcvhyw7";
      };
    patch = pkgs.fetchurl {
        url = "https://goo.gl/Ev9eK6";
	sha256 = "1206sqlpdr7g18vc1m6ygaf49fvnfsg39v854a21b20midl352l6";
      };
  };
  mySrc = pkgs.fetchgit {
        url = /home/rotsor/repos/openttd;
        rev = "76fc2426669d3a52d392ab6838ebf30326294589";
        sha256 = "0nbn2m8il74jwiymq15z6z68q1mrqmafvzr2id4ajphcdhcvhyw7";
      };

  withSrc = src :
   openttd.overrideAttrs (original_attrs : rec {
    name = "openttd-reddit-${version}";
    version = reddit_client.version;
    preConfigure = ''
      patch -p0 < ${reddit_client.patch}
      echo "reddit-v5.0	27534	2	r27534M" > ./.ottdrev
    '';
    src = reddit_client.src;
    configureFlags = original_attrs.configureFlags ++ [
      "--disable-assert"
    ];
  });
in
{
  reddit = withSrc redit_client.src;
  my = withSrc mySrc;
 diffs = pkgs.stdenv.mkDerivation {
   name = "tmp";
   src1 = mySrc;
   src2 = reddit_client.src;
   buildCommand = "${pkgs.git}/bin/git diff --color=always --no-index ${mySrc} ${reddit_client.src} > $out || true";
 };
 grf2html = pkgs.stdenv.mkDerivation {
   name = "grf2html";
   src = pkgs.fetchsvn {
     url = "svn://grfmaker.zernebok.net/projects/grf2html";
     revision = "1000";
     sha256 = "0nbn2m8il74jwiymq15z6z68q1mrqmafvzr2id4ajphcdhcvhyw6";
   };
 };
}

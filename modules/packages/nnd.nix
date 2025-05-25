{lib, fetchurl, stdenv}: stdenv.mkDerivation rec {
  pname = "nnd";
  version = "0.27";

  src = fetchurl {
    url = "https://github.com/al13n321/nnd/releases/download/v${version}/nnd";
    sha256 = "1z8lq5728qg142pwiaig8qmb5fqqqdjaxvgy65jqm214zznyd85z";
    curlOptsList = ["-L"];
  };

  phases = ["installPhase"];

  sourceRoot = ".";
  installPhase = ''
    runHook preInstall
    install -m755 -D $src $out/bin/nnd
    runHook postInstall
  '';

  meta = {
    description = "A debugger for Linux";
    homepage = "https://github.com/al13n321/nnd";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
  };
}

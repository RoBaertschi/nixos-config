{lib, fetchurl, stdenv}: stdenv.mkDerivation rec {
  pname = "nnd";
  version = "0.20";

  src = fetchurl {
    url = "https://github.com/al13n321/nnd/releases/download/v${version}/nnd";
    sha256 = "03301axm4vrdlmj6y2svhg139hq6axpdwbsf4k7m4i49wyq6xslr";
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

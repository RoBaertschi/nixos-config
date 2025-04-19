final: prev: {
  odin = prev.odin.overrideAttrs {
    version = "dev-2025-04";
    src = prev.fetchFromGitHub {
      owner = "odin-lang";
      repo = "Odin";
      rev = "dev-2025-04";
      hash = "sha256-dVC7MgaNdgKy3X9OE5ZcNCPnuDwqXszX9iAoUglfz2k=";
    };
    buildInputs = [prev.sdl3];
  };
}

{lib, fetchFromGithub, rustPlatform}: rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nnd";
  version = "0.20";

  src = fetchFromGithub {
    owner = "al13n321";
    repo = "nnd";
    tag = "v"+finalAttrs.version;
    hash = "";
  };

  cargoHash = "";
  meta = {
    description = "A debugger for Linux";
    homepage = "https://github.com/al13n321/nnd";
    license = lib.license.apache;
  };
})

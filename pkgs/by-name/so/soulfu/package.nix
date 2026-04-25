{
  stdenv,
  lib,
  fetchFromGitHub,
  pkg-config,
  makeWrapper,
  libGL,
  libjpeg,
  libvorbis,
  libogg,
  SDL2
}:

stdenv.mkDerivation {
  pname = "soulfu";
  version = "latest-14-gcc06bff";

  src = fetchFromGitHub {
    owner = "soulfu-dev";
    repo = "soulfu";
    rev = "cc06bffac24036574bc94d867ada41ffaac6282c";
    hash = "sha256-6ct2wFO/YUtjYQmXKqiSlJNZ9f0/I//vGRMhr4se4AI=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    SDL2
    libGL
    libjpeg
    libogg
    libvorbis
  ];

  installPhase = ''
    mkdir $out/
    cp soulfu $out/
    chmod +x $out/
    cp datafile.sdf $out/
    cp Manual.htm $out/
    cp packaging/license.txt $out/
  '';

  meta = {
    description = "A 3D action role-playing hack and slash dungeon crawler made by Aaron Bishop, the creator of Egoboo";
    homepage = "https://aaronbishopgames.com";
    platforms = lib.platforms.linux ++ lib.platforms.windows;
    maintainers = [ ];
  };
}

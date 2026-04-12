{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  cmake,
  unzip,
  libGL,
  libice,
  libsm,
  libx11,
  libxrandr,
  ois,
  pkg-config,
  zlib,
  alsa-lib,
  ogre_11,
  mygui,
  fmt,
  rapidjson,
  angelscript,
  openal
}:

stdenv.mkDerivation rec {
  pname = "rigsofrods-bin";
  version = "2026.01";

  src = fetchurl {
    url = "https://github.com/RigsOfRods/rigs-of-rods/archive/refs/tags/${version}.tar.gz";
    hash = "sha256-4ZGsh42QXYmMgrw2EO6BGpvGPbdviDor8pS3TqN2fIE=";
  };

  # Fix OIS include dir not being found.
  patchPhase = ''
     sed -i 's/PATH_SUFFIXES OIS/PATH_SUFFIXES ois/' cmake/find-modules/FindOIS.cmake
  '';

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    unzip
    cmake
  ];

  buildInputs = [
    libGL
    ogre_11
    ois
    openal
    # Override mygui to enable Ogre support and link it to our ogre_11
    (mygui.override {
      withOgre = true;
      ogre = ogre_11;
    })
    fmt
    libice
    libsm
    libx11
    libxrandr
    stdenv.cc.cc
    zlib
    rapidjson
    (angelscript.overrideAttrs (oldAttrs: {
      NIX_CFLAGS_COMPILE = (oldAttrs.NIX_CFLAGS_COMPILE or "") + " -DAS_DEPRECATED";
    }))
  ];

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_CXX_FLAGS" "-DAS_DEPRECATED")
    (lib.cmakeFeature "CMAKE_CXX_STANDARD" "17")
  ];

  runtimeDependencies = [
    alsa-lib
  ];

  noDumpEnvVars = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/rigsofrods
    cp -a . $out/share/rigsofrods
    for f in RoR RunRoR; do
      makeWrapper $out/share/rigsofrods/$f $out/bin/$f \
        --chdir $out/share/rigsofrods
    done

    runHook postInstall
  '';

  meta = {
    description = "Free/libre soft-body physics simulator mainly targeted at simulating vehicle physics";
    homepage = "https://www.rigsofrods.org";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      raskin
      wegank
    ];
    platforms = [ "x86_64-linux" ];
  };
}

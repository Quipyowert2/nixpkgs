{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  makeWrapper,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "socketw";
  version = "3.10.26-19-g35cd91e18dfa14419879b737b7d01dacdf39e610";

  src = fetchFromGitHub {
    owner = "RigsOfRods";
    repo = "socketw";
    rev = version;
    #url = "https://github.com/RigsOfRods/socketw/archive/refs/tags/${version}.tar.gz";
    hash = "sha256-wtDq60eYslroTVVwulDSIr4irY6cg1p3ZZ3oeMGx5Fg=";
  };

  joinpaths = fetchurl {
    url = "https://AnotherFoxGuy.com/CMakeCM/modules/JoinPaths.cmake";
    hash = "sha256-eUsNj6YqO3mMffEtUBFFgNGkeiNL+2tNgwkutkam7MQ=";
  };

  patches = [./pkgconfig.patch];

  patchPhase = ''
    sed 's/.{0}//' CMakeLists.txt
    sed 's/CMAKE_INSTALL_LIBDIR/CMAKE_INSTALL_FULL_LIBDIR/' CMakeLists.txt
    sed 's/CMAKE_INSTALL_LIBDIR/CMAKE_INSTALL_FULL_INCLUDEDIR/' CMakeLists.txt
    #sed 's/\\''\${exec_prefix/''\${exec_prefix/' CMakeLists.txt
  '';

  preConfigure = ''
    mkdir -p build/_cmcm-modules/resolved
    cp ${joinpaths} build/_cmcm-modules/resolved/JoinPaths.cmake
    echo -n 'https://AnotherFoxGuy.com/CMakeCM::modules/JoinPaths.cmake.1' > build/_cmcm-modules/resolved/JoinPaths.cmake.whence
  '';

  nativeBuildInputs = [
    makeWrapper
    cmake
  ];

  buildInputs = [
  ];

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.5")
    #(lib.cmakeFeature "CMAKE_CXX_FLAGS" "-DAS_DEPRECATED")
    #(lib.cmakeFeature "CMAKE_CXX_STANDARD" "17")
  ];

  runtimeDependencies = [
    #alsa-lib
  ];

  noDumpEnvVars = true;

  meta = {
    description = "SocketW is a library which provides cross-platform socket abstraction";
    homepage = "https://rigsofrods.github.io/socketw/";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [];
    platforms = [ "x86_64-linux" ];
  };
}


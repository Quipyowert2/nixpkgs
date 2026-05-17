{ stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  perl,
  zlib,
# ... other dependencies like libunwind, etc.
}:

stdenv.mkDerivation rec {
  pname = "dynamorio";
  version = "cronbuild-11.91.20587";

  src = fetchFromGitHub {
    owner = "DynamoRIO";
    repo = "dynamorio";
    rev = version;
    hash = "sha256-9Be7qu1xhOwmPgX13fUEe174OHUb5GfxXbbVqxcw2Ck=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    perl
    zlib
  ];

  # DynamoRIO requires specific CMake flags to export its headers/libs correctly
  cmakeFlags = [
    "-DBUILD_DOCS=OFF"
    "-DRUN_IN_BACKGROUND=OFF"
  ];

  meta = {
    description = "Dynamic Instrumentation Tool Platform";
    homepage = "https://drmemory.org";
    platforms = lib.platforms.linux;
    license = [ lib.licenses.bsd3 lib.licenses.lgpl21 ];
  };
  # ...
}

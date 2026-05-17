{ stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  dynamorio,
}:

stdenv.mkDerivation rec {
  pname = "drmemory";
  version = "cronbuild-2.6.20434";

  src = fetchFromGitHub {
    owner = "DynamoRIO";
    repo = "drmemory";
    rev = version;
    hash = "sha256-9gnW9Di7L/5Y9pntmQGp6K+pQ+DN8cm1CjPkLZgqakA=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    dynamorio
  ];

  postPatch = ''
    substituteInPlace tests/clone.c --replace 'typedef int bool;' ""
    sed -i '49,52d' tests/fuzz/fuzz_buffer.c
  '';

  cmakeFlags = [
    "-DBUILD_DOCS=OFF"
    "-DRUN_IN_BACKGROUND=OFF"
    "-DDynamoRIO_DIR=${dynamorio}/cmake"
#    "-DCMAKE_CXX_STANDARD=20" # Using C++23 gives errors about typedefing bool and using false as a enum value
  ];

  meta = {
    description = "Memory Debugger for Windows, Linux, Mac, and Android";
    homepage = "https://drmemory.org";
    platforms = lib.platforms.linux;
    license = [ lib.licenses.bsd3 lib.licenses.lgpl21 ];
  };
}

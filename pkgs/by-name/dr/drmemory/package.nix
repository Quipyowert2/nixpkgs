{ stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  dynamorio,
  buildDocs ? false,
  doxygen ? null,
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

  outputs = [ "out" ] ++ lib.optional buildDocs "doc";

  nativeBuildInputs = [
    cmake
  ]
  ++ lib.optionals buildDocs [ doxygen ];

  buildInputs = [
    dynamorio
  ];

  cmakeFlags = [
    "-DBUILD_DOCS=${if buildDocs then "ON" else "OFF"}"
    "-DDynamoRIO_DIR=${dynamorio}/cmake"
    "-DCMAKE_C_STANDARD=17" # Using C23 gives errors about defining bool
  ];

  postInstall = lib.optionalString buildDocs ''
    mkdir -p $doc/share/doc
    mkdir -p $doc/share/doc_embed
    mv $out/drmemory/docs/* $doc/share/drmemory/doc/
    mv $out/drmemory/docs_embed/* $doc/share/drmemory/doc_embed/
    rmdir $out/drmemory/docs
    rmdir $out/drmemory/docs_embed
  '';

  meta = {
    description = "Memory Debugger for Windows, Linux, Mac, and Android";
    homepage = "https://drmemory.org";
    platforms = lib.platforms.linux;
    license = [ lib.licenses.bsd3 lib.licenses.lgpl21 ];
  };
}

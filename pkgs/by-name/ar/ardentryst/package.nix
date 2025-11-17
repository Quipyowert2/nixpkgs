{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "ardentryst";
  version = "1.71-48-g7b66716";
  src = fetchFromGitHub {
    owner = "ardentryst";
    repo = "ardentryst";
    rev = version;
    hash = "sha256-+7L4eWxTCKdWSBdb70kVd2M6uTL6CVmcnZ0MluLiYyQ=";
  };

  format = "other";

  propagatedBuildInputs = with python3Packages; [
    pygame
  ];

  patchPhase = ''
    sed -i 's!/usr/bin/python!/usr/bin/env python!' ardentryst
    sed -i 's!/usr/share/games!${placeholder "out"}/share/games!' ardentryst
  '';

  installPhase = ''
    mkdir -p ${placeholder "out"}/share/pixmaps
    cp icon.png ${placeholder "out"}/share/pixmaps/ardentryst.png
    mkdir ${placeholder "out"}/bin
    cp ardentryst ${placeholder "out"}/bin/
    mkdir -p ${placeholder "out"}/share/games/ardentryst
    cp -R * ${placeholder "out"}/share/games/ardentryst/
    chmod 0755 ${placeholder "out"}/bin/ardentryst
    makeWrapper ${python3Packages.python.interpreter} $out/bin/ardentryst \
      --set PYTHONPATH "$PYTHONPATH:$out/share/games/ardentryst" \
      --add-flags "$out/share/games/ardentryst/ardentryst.py"
  '';

  meta = with lib; {
    description = "A free RPG platformer";
    mainProgram = "ardentryst";
    homepage = "https://github.com/ardentryst/ardentryst";
    license = licenses.gpl3;
    maintainers = [hhirsch elle-trudgett Quipyowert2];
  };
}

{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "ardentryst";
  version = "1.71";
  src = fetchFromGitHub {
    owner = "ardentryst";
    repo = "ardentryst";
    rev = version;
    hash = "sha256-hr8CKMAOyIi5ICwDYwoGOZMBHygbbvLOmmPZ5sFx2I4=";
  };

  format = "other";

  propagatedBuildInputs = with python3Packages; [
    pygame
  ];

  installPhase = ''
    mkdir -p ${placeholder "out"}/share/pixmaps
    cp icon.png ${placeholder "out"}/share/pixmaps/ardentryst.png
    mkdir ${placeholder "out"}/bin
    cp ardentryst ${placeholder "out"}/bin/
    mkdir -p ${placeholder "out"}/games/ardentryst
    cp -R * ${placeholder "out"}/games/ardentryst/
    chmod 0755 ${placeholder "out"}/bin/ardentryst
  '';

  meta = with lib; {
    description = "A free RPG platformer";
    mainProgram = "ardentryst";
    homepage = "https://github.com/ardentryst/ardentryst";
    license = licenses.gpl3;
    maintainers = [hhirsch elle-trudgett Quipyowert2];
  };
}

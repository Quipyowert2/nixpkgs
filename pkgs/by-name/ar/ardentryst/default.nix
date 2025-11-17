{
  lib,
  pythonPackages
}:

pythonPackages.buildPythonModule {
  pname = "ardentryst";
  version = "1.71";
  src = fetchurl {
     url = "https://github.com/ardentryst/ardentryst/archive/refs/tags/1.71.tar.gz";
     hash = "";
  };
}

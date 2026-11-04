{
  lib,
  stdenv,
  fetchFromCodeberg,
  rustPlatform,
  meson,
  ninja,
  pkg-config,
  cargo,
  rustc,
  blueprint-compiler,
  wrapGAppsHook4,
  desktop-file-utils,
  libadwaita,
  libshumate,
  libsoup_3,
  alsa-lib,
  espeak,
  sqlite,
  glib-networking,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jogger";
  version = "2.2.0";

  src = fetchFromCodeberg {
    owner = "baarkerlounger";
    repo = "jogger";
    tag = finalAttrs.version;
    hash = "sha256-75gwp8jyfQfL1cJLfD6SZmZPBIaXkIQKrPt4UIvRDf4=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-8PuhJ8fM0BowMg5VceXzIqMsS6WYPY0HtM0NY3QaUqI=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    rustPlatform.bindgenHook
    cargo
    rustc
    blueprint-compiler
    wrapGAppsHook4
    desktop-file-utils
  ];

  buildInputs = [
    libadwaita
    libshumate
    libsoup_3
    alsa-lib
    espeak
    sqlite
    glib-networking
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "App for Gnome Mobile to Track running and other workouts";
    homepage = "https://codeberg.org/baarkerlounger/jogger";
    license = with lib.licenses; [
      gpl3Plus
      cc0
    ];
    mainProgram = "jogger";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.linux;
  };
})

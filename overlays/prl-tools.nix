# Parallels Tools overlay
final: prev: {
  linuxKernelPackages = prev.linuxKernelPackages.extend (lpself: lpsuper: {
    prl-tools = lpsuper.prl-tools.overrideAttrs (finalAttrs: previousAttrs: {
      version = "20.2.0-55871";
      src = prev.fetchurl {
        url = "https://download.parallels.com/desktop/v${prev.lib.versions.major finalAttrs.version}/${finalAttrs.version}/ParallelsDesktop-${finalAttrs.version}.dmg";
        hash = "sha256-qyRSX3FrnVxB6NU8N2CsOhsnuhK6+82oe6ftcfs9a14=";
      };
      patches = [
        (prev.writeText "linux-6.12.patch" (builtins.readFile ../reference/linux-6.12.patch))
      ];
    });
  });
}

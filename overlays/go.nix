{ lib, fetchurl }:
final: prev: {
  go = prev.go.overrideAttrs (old: {
    version = "1.21.6";  # Latest stable Go version as of 2025-01-05

    src = fetchurl {
      url = "https://go.dev/dl/go${old.version}.src.tar.gz";
      sha256 = "sha256-4w6V5y1l5y5y5y5y5y5y5y5y5y5y5y5y5y5y5y5y5y5y5=";  # Update with actual SHA256
    };

    # Keep existing build flags
    buildFlagsArray = old.buildFlagsArray or [];
  });
}

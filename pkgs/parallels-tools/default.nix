{ pkgs
, lib
, stdenv
, fetchurl
, bbe
, makeWrapper
, p7zip
, perl
, undmg
, dbus-glib
, fuse
, glib
, xorg
, zlib
, kernel
, bash
, cups
, gawk
, netcat
, timetrap
, util-linux
}:

let
  kernelVersion = kernel.modDirVersion;
  kernelDir = "${kernel.dev}/lib/modules/${kernelVersion}";

  libPath = lib.concatStringsSep ":" [
    "${glib.out}/lib"
    "${xorg.libXrandr}/lib"
  ];
  scriptPath = lib.concatStringsSep ":" [
    "${bash}/bin"
    "${cups}/sbin"
    "${gawk}/bin"
    "${netcat}/bin"
    "${timetrap}/bin"
    "${util-linux}/bin"
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "prl-tools";
  version = "20.2.0-55871";

  # We download the full distribution to extract prl-tools-lin.iso from
  # => ${dmg}/Parallels\ Desktop.app/Contents/Resources/Tools/prl-tools-lin.iso
  src = fetchurl {
    url = "https://download.parallels.com/desktop/v${lib.versions.major finalAttrs.version}/${finalAttrs.version}/ParallelsDesktop-${finalAttrs.version}.dmg";
    hash = "sha256-qyRSX3FrnVxB6NU8N2CsOhsnuhK6+82oe6ftcfs9a14=";
  };

  hardeningDisable = [
    "pic"
    "format"
  ];

  nativeBuildInputs = [
    stdenv.cc.cc.lib
    pkgs.patchutils
    bbe
    makeWrapper
    p7zip
    perl
    undmg
  ] ++ kernel.moduleBuildDependencies;

  buildInputs = [
    dbus-glib
    fuse
    glib
    xorg.libX11
    xorg.libXcomposite
    xorg.libXext
    xorg.libXrandr
    xorg.libXi
    xorg.libXinerama
    zlib
  ];

  runtimeDependencies = [
    glib
    xorg.libXrandr
  ];

  unpackPhase = ''
    runHook preUnpack

    # First extract the DMG
    undmg "$src"
    
    # Then extract the ISO
    7z x "Parallels Desktop.app/Contents/Resources/Tools/prl-tools-lin${lib.optionalString stdenv.hostPlatform.isAarch64 "-arm"}.iso"
    
    # Create source directory and move files
    mkdir -p prl-tools-build
    mv kmods tools installer version prl-tools-build/
    cd prl-tools-build

    # Extract kernel modules
    cd kmods
    tar xf prl_mod.tar.gz
    cd ..

    # Apply patches
    patch -p1 < ${./linux-6.12.patch}

    runHook postUnpack
  '';

  patches = [
    ./linux-6.12.patch
  ];

  buildPhase = ''
    runHook preBuild

    cd kmods
    make -f Makefile.kmods \
      KERNEL_DIR=${kernelDir}/build \
      HEADERS_CHECK_DIR=${kernelDir}/source \
      KVER=${kernelVersion} \
      SRC=$PWD \
      KBUILD_EXTRA_SYMBOLS=$PWD/Module.symvers \
      PRL_FREEZE_SKIP=1 \
      KMOD_PATHS="Toolgate/Guest/Linux/prl_tg SharedFolders/Guest/Linux/prl_fs" \
      V=1
    cd ..

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    # Install kernel modules
    mkdir -p $out/lib/modules/${kernelVersion}/extra
    find kmods -name "*.ko" -exec cp {} $out/lib/modules/${kernelVersion}/extra/ \;
    echo "Found kernel modules:"
    ls -la $out/lib/modules/${kernelVersion}/extra/

    # Install tools
    cd tools/tools${
      if stdenv.hostPlatform.isAarch64 then
        "-arm64"
      else if stdenv.hostPlatform.isx86_64 then
        "64"
      else
        "32"
    }

    # Install binaries
    for i in bin/* sbin/prl_nettool sbin/prl_snapshot; do
      install -Dm755 $i $out/$i
    done

    install -Dm755 ../../prlfsmountd.sh $out/sbin/prlfsmountd
    install -Dm755 ../../prlbinfmtconfig.sh $out/sbin/prlbinfmtconfig

    # Install libraries
    for i in lib/libPrl*.0.0; do
      install -Dm755 $i $out/lib/$(basename $i)
      ln -s $out/lib/$(basename $i) $out/lib/$(basename $i .0.0)
    done

    # Install man pages
    install -Dm644 ../../mount.prl_fs.8 $out/share/man/man8/mount.prl_fs.8

    # Install PM scripts
    install -Dm644 ../../99prltoolsd-hibernate $out/etc/pm/sleep.d/99prltoolsd-hibernate

    runHook postInstall
  '';

  meta = with lib; {
    description = "Parallels Tools for Linux guests";
    homepage = "https://parallels.com";
    license = licenses.unfree;
    maintainers = with maintainers; [
      wegank
      codgician
    ];
    platforms = platforms.linux;
  };
})

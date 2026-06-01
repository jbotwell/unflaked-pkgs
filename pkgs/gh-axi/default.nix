{
  lib,
  buildNpmPackage,
  nodejs_22,
  runCommand,
  src,
}:

let
  srcWithLockfile = runCommand "gh-axi-src" { } ''
    cp -r ${src} $out
    chmod -R u+w $out
    cp ${./package-lock.json} $out/package-lock.json
  '';
in
buildNpmPackage {
  pname = "gh-axi";
  version = "0.1.19";

  src = srcWithLockfile;

  npmDepsHash = "sha256-Bkktn/iaazpno/ZUCO+M3pmvURtHZXM7P9r6FEd9rnQ=";

  nativeBuildInputs = [ nodejs_22 ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/gh-axi
    cp -r dist package.json node_modules $out/lib/gh-axi/
    mkdir -p $out/bin
    cat > $out/bin/gh-axi <<EOF
    #!${nodejs_22}/bin/node
    import("$out/lib/gh-axi/dist/bin/gh-axi.js");
    EOF
    chmod +x $out/bin/gh-axi
    runHook postInstall
  '';

  meta = {
    description = "AXI-compliant gh CLI wrapper — token-efficient TOON output";
    homepage = "https://github.com/kunchenguid/gh-axi";
    license = lib.licenses.mit;
    mainProgram = "gh-axi";
  };
}

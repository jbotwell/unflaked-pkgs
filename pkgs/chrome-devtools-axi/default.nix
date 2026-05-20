{
  lib,
  buildNpmPackage,
  nodejs_22,
  runCommand,
  src,
}:

let
  srcWithLockfile = runCommand "chrome-devtools-axi-src" { } ''
    cp -r ${src} $out
    chmod -R u+w $out
    cp ${./package-lock.json} $out/package-lock.json
  '';
in
buildNpmPackage {
  pname = "chrome-devtools-axi";
  version = "0.1.22";

  src = srcWithLockfile;

  npmDepsHash = "sha256-cQr6p49XhbaLyVlqGWlHzUhLDbR1JHeWrzBfnKXJkvw=";

  nativeBuildInputs = [ nodejs_22 ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/chrome-devtools-axi
    cp -r dist package.json node_modules $out/lib/chrome-devtools-axi/
    mkdir -p $out/bin
    cat > $out/bin/chrome-devtools-axi <<EOF
    #!${nodejs_22}/bin/node
    import("$out/lib/chrome-devtools-axi/dist/bin/chrome-devtools-axi.js");
    EOF
    chmod +x $out/bin/chrome-devtools-axi
    runHook postInstall
  '';

  meta = {
    description = "AXI-compliant chrome-devtools-mcp wrapper — combined operations, TOON output";
    homepage = "https://github.com/kunchenguid/chrome-devtools-axi";
    license = lib.licenses.mit;
    mainProgram = "chrome-devtools-axi";
  };
}

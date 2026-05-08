{
  lib,
  buildNpmPackage,
  nodejs_22,
  src,
}:

buildNpmPackage {
  pname = "chrome-devtools-axi";
  version = "0.1.21";

  inherit src;

  npmDepsHash = "sha256-cSHllVEl08mqENOHBo2bmisTYwD9owBLEuUT+ceUZrw=";

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

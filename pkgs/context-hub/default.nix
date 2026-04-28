{
  lib,
  buildNpmPackage,
  nodejs_22,
  src,
}:

buildNpmPackage {
  pname = "chub";
  version = "0.1.4";

  inherit src;

  npmDepsHash = "sha256-AIjQTnfeXt8ROhHcS2vuYQ2HbXdI/MFa4/wnuQknjKA=";

  nativeBuildInputs = [ nodejs_22 ];

  sourceRoot = "source";

  dontNpmBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/lib/chub
    cp -r cli/{bin,src,skills,package.json} $out/lib/chub/
    cp -r node_modules $out/lib/chub/
    rm -f $out/lib/chub/node_modules/@aisuite/chub
    rm -f $out/lib/chub/node_modules/.bin/chub
    rm -f $out/lib/chub/node_modules/.bin/chub-mcp
    ln -s $out/lib/chub/bin/chub $out/bin/chub
    ln -s $out/lib/chub/bin/chub-mcp $out/bin/chub-mcp
    runHook postInstall
  '';

  meta = {
    description = "CLI for Context Hub - search and retrieve LLM-optimized docs and skills";
    homepage = "https://github.com/andrewyng/context-hub";
    license = lib.licenses.mit;
    mainProgram = "chub";
  };
}

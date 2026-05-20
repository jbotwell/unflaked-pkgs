{
  lib,
  buildNpmPackage,
  nodejs_22,
  src,
}:

buildNpmPackage {
  pname = "codegraph";
  version = "0.7.12";

  inherit src;

  npmDepsHash = "sha256-TmrRrU26sKtnOqU3+6tJem2VKuQlbrvIux1tPUxjo0s=";

  nativeBuildInputs = [ nodejs_22 ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/codegraph
    cp -r dist package.json node_modules $out/lib/codegraph/
    mkdir -p $out/bin
    ln -s $out/lib/codegraph/dist/bin/codegraph.js $out/bin/codegraph
    runHook postInstall
  '';

  meta = {
    description = "Pre-indexed code knowledge graph for AI coding assistants";
    homepage = "https://github.com/colbymchenry/codegraph";
    license = lib.licenses.mit;
    mainProgram = "codegraph";
  };
}

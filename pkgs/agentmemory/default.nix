{
  lib,
  buildNpmPackage,
  makeWrapper,
  nodejs_22,
  runCommand,
  iii,
  src,
}:

let
  srcWithLockfile = runCommand "agentmemory-src" { } ''
    cp -r ${src} $out
    chmod -R u+w $out
    cp ${./package-lock.json} $out/package-lock.json
  '';
in
buildNpmPackage {
  pname = "agentmemory";
  version = "0.9.24";

  src = srcWithLockfile;

  npmDepsHash = "sha256-yG+9azr0YgwzUsjX3gk7vMV+7ROqP3wNkuk0F/NFJt4=";

  makeCacheWritable = true;
  npmFlags = [
    "--legacy-peer-deps"
    "--ignore-scripts"
  ];
  dontNpmRebuild = true;

  nativeBuildInputs = [
    nodejs_22
    makeWrapper
  ];

  buildPhase = ''
    runHook preBuild
    npm run build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/agentmemory
    cp -r dist package.json node_modules $out/lib/agentmemory/
    mkdir -p $out/bin
    cat > $out/bin/agentmemory <<EOF
    #!${nodejs_22}/bin/node
    import("$out/lib/agentmemory/dist/cli.mjs");
    EOF
    chmod +x $out/bin/agentmemory
    wrapProgram $out/bin/agentmemory --prefix PATH : ${lib.makeBinPath [ iii ]}
    runHook postInstall
  '';

  meta = {
    description = "Persistent memory for AI coding agents, powered by iii-engine";
    homepage = "https://github.com/rohitg00/agentmemory";
    license = lib.licenses.asl20;
    mainProgram = "agentmemory";
  };
}

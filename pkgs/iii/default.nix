{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:

stdenv.mkDerivation rec {
  pname = "iii";
  version = "0.16.1";

  src = fetchurl {
    url = "https://github.com/iii-hq/iii/releases/download/iii%2Fv${version}/iii-x86_64-unknown-linux-gnu.tar.gz";
    hash = "sha256-5QmcmsnKUapZfsOpk2z3o2SQJvmwB4HXeod4Q5AiQWs=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [ stdenv.cc.cc.lib ];

  installPhase = ''
    runHook preInstall
    install -Dm755 iii $out/bin/iii
    runHook postInstall
  '';

  meta = {
    description = "iii-engine — local-first vector engine for agent memory";
    homepage = "https://github.com/iii-hq/iii";
    license = lib.licenses.asl20;
    platforms = [ "x86_64-linux" ];
    mainProgram = "iii";
  };
}

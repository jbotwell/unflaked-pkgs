{
  lib,
  python312,
  src,
}:

let
  python = python312;
in
python.pkgs.buildPythonApplication rec {
  pname = "ouroboros-ai";
  version = "0.39.0";
  pyproject = true;

  inherit src;

  build-system = with python.pkgs; [ hatchling ];

  dependencies = with python.pkgs; [
    aiosqlite
    anyio
    jsonschema
    mcp
    pydantic
    questionary
    prompt-toolkit
    pyyaml
    rich
    sqlalchemy
    structlog
    textual
    typer
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'dynamic = ["version"]' 'version = "${version}"' \
      --replace-fail 'requires = ["hatchling", "hatch-vcs"]' 'requires = ["hatchling"]'
    sed -i '/^\[tool\.hatch\.version\]$/,/^\[/{ /^\[/!d }' pyproject.toml
    sed -i '/^\[tool\.hatch\.version\]$/d' pyproject.toml
    sed -i '/^\[tool\.hatch\.build\.hooks\.vcs\]$/,/^\[/{ /^\[/!d }' pyproject.toml
    sed -i '/^\[tool\.hatch\.build\.hooks\.vcs\]$/d' pyproject.toml
  '';

  pythonRelaxDeps = true;

  meta = {
    description = "Agent OS: Stop prompting. Start specifying";
    homepage = "https://github.com/Q00/ouroboros";
    license = lib.licenses.mit;
    mainProgram = "ouroboros";
  };
}

{ lib, poetry2nix, python3, runCommand }:
let
  env = poetry2nix.mkPoetryEnv {
    python = python3;
    pyproject = ./pyproject.toml;
    poetrylock = ./poetry.lock;
    preferWheels = false;
    overrides = poetry2nix.overrides.withDefaults (
      self: super: {
        grpcio = super.grpcio.override {
          preferWheel = true;
        };
      }
    );
  };

  isWheelGrpcIO = env.python.pkgs.grpcio.src.isWheel;

in
assert isWheelGrpcIO; runCommand "grpcio-wheel" { } ''
  ${env}/bin/python -c 'import grpc; print(grpc.__version__)' > $out
''

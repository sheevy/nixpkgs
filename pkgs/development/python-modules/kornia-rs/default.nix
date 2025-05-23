{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPythonPackage,
  rustPlatform,
  cmake,
  nasm,
  libiconv,
}:

buildPythonPackage rec {
  pname = "kornia-rs";
  version = "0.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kornia";
    repo = "kornia-rs";
    tag = "v${version}";
    hash = "sha256-7toCMaHzFAzm6gThVLBxKLgQVgFJatdJseDlfdeS8RE=";
  };

  nativeBuildInputs = [
    rustPlatform.maturinBuildHook
    rustPlatform.cargoSetupHook
    cmake # Only for dependencies.
    nasm # Only for dependencies.
  ];

  buildInputs = lib.optional stdenv.hostPlatform.isDarwin libiconv;

  cargoRoot = "py-kornia";
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit
      pname
      version
      src
      cargoRoot
      ;
    hash = "sha256-VQtPfTmT9UGM0fIMeZF/1lUqQeyP63naoYZ7UuL6hFg=";
  };

  maturinBuildFlags = [
    "-m"
    "py-kornia/Cargo.toml"
  ];

  dontUseCmakeConfigure = true; # We only want to use CMake to build some Rust dependencies.

  meta = with lib; {
    homepage = "https://github.com/kornia/kornia-rs";
    description = "Python bindings to Low-level Computer Vision library in Rust";
    license = licenses.asl20;
    maintainers = with maintainers; [ chpatrick ];
  };
}

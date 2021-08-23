with import <nixpkgs> { };

let
  pythonPackages = python3Packages;
in pkgs.mkShell rec {
  name = "impurePythonEnv";
  venvDir = "./.venv";
  buildInputs = [
    # A Python interpreter including the 'venv' module is required to bootstrap
    # the environment.
    pythonPackages.python

    # This execute some shell code to initialize a venv in $venvDir before
    # dropping into the shell
    pythonPackages.venvShellHook

    # Those are dependencies that we would like to use from nixpkgs, which will
    # add them to PYTHONPATH and thus make them accessible from within the venv.
    pythonPackages.numpy
    pythonPackages.requests

    # In this particular example, in order to compile any binary extensions they may
    # require, the Python modules listed in the hypothetical requirements.txt need
    # the following packages to be installed locally:
    taglib
    openssl
    git
    libxml2
    libxslt
    libzip
    zlib
  ];

  # Run this command, only after creating the virtual environment
  postVenvCreation = ''
    unset SOURCE_DATE_EPOCH
    pip install -r requirements.txt
    pip install openapi2jsonschema
  '';

  # Now we can execute any commands within the virtual environment.
  # This is optional and can be left out to run pip manually.
  postShellHook = ''
    # allow pip to install wheels
    unset SOURCE_DATE_EPOCH
  '';

}


  
# { pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-21.05.tar.gz") {} }:

# let
#   mach-nix = import (builtins.fetchGit {
#     url = "https://github.com/DavHau/mach-nix";
#     ref = "refs/tags/3.3.0";
#   }) {};
# in
# mach-nix.mkPython {
#   requirements = ''
#     pillow
#     numpy
#     requests
#     openapi2jsonschema
#   '';
# }
  

#with import <nixpkgs> {};
#( pkgs.python39.buildEnv.override  {
#extraLibs = with pkgs.python39Packages; [ pip openapi2jsonschema ];
#}).env
  
# pkgs.mkShell {
#   buildInputs = [
#     pkgs.which
#     pkgs.htop
#     pkgs.zlib
#     pkgs.python39Packages.pip
#   ];

#   shellHook = ''
#     echo hello
#   '';
# }

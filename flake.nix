{
  description = "Universal cross-compilation environment using Nix flakes";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }: {
    # Root dev shell not needed yet; sub-flakes in ./targets handle their own environments
  };
}


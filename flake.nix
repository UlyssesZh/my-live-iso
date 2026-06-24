{
  description = "My live OS";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  outputs = { self, nixpkgs }: {
    packages.x86_64-linux.default = self.nixosConfigurations.default.config.system.build.isoImage;

    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        (import ./configurations.nix)
      ];
    };

    formatter.x86_64-linux = nixpkgs.nixfmt-tree;
  };
}

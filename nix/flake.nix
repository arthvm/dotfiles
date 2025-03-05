{
  description = "Top level NixOS Flake";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    #nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

    nixos-hardware.url = "github:NixOs/nixos-hardware/master";

    # Unstable Packages
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Disko
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    # Home Manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Alacritty theme
    alacritty-theme.url = "github:alexghr/alacritty-theme.nix";
    alacritty-theme.inputs.nixpkgs.follows = "nixpkgs";

    # Templ
    templ.url = "github:a-h/templ";
    templ.inputs.nixpkgs.follows = "nixpkgs";

    # Ags
    ags.url = "github:Aylur/ags";
    ags.inputs.nixpkgs.follows = "nixpkgs";

    # Matugen
    matugen.url = "github:InioX/matugen?ref=v2.2.0";
    matugen.inputs.nixpkgs.follows = "nixpkgs";

    # NixVim
    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    disko,
    home-manager,
    alacritty-theme,
    templ,
    nixpkgs-unstable,
    nixos-hardware,
    ags,
    ...
  } @ inputs: let
    inherit (self) outputs;

    systems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];

    hosts = [
      {
        name = "nixos";
        gaps = true;
        hardware = null;
        monitors = [
          {
            name = "DP-1";
            dimensions = "1920x1080";
            position = "0x0";
            scale = 1.0;
            framerate = 60;
            internal = false;
            transform = 0;
          }
        ];
        cursor = 64;
      }
    ];

    forAllSystems = fn: nixpkgs.lib.genAttrs systems (system: fn {pkgs = import nixpkgs {inherit system;};});
  in {
    overlays = import ./overlays {inherit inputs;};

    formatter = forAllSystems ({pkgs}: pkgs.alejandra);

    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});

    nixosConfigurations = builtins.listToAttrs (map (host: {
        name = host.name;
        value = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
            meta = {
              hostname = host.name;
            };
          };
          system = "x86_64-linux";
          modules =
            [
              # Modules
              disko.nixosModules.disko
              # System Specific
              ./machines/${host.name}/hardware-configuration.nix
              ./machines/${host.name}/disko-config.nix
              # General
              ./configuration.nix
              # Home Manager
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.arthvm = import ./home/home.nix;
                home-manager.extraSpecialArgs = {
                  inherit inputs;
                  meta = host;
                };
              }
            ]
            ++ (
              if host.hardware != null
              then [host.hardware]
              else []
            );
        };
      })
      hosts);
  };
}

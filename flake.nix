{
      description = "Python 3.10 development environment";
      outputs = { self, nixpkgs }:
      let
        system = "x86_64-linux";
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          config.cudaSupport = true;
          config.cudaVersion = "12";
        };
      in {
        devShells.${system}.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            cudatoolkit linuxPackages.nvidia_x11
            cudaPackages.cudnn
            libGLU libGL
            xorg.libXi xorg.libXmu freeglut
            xorg.libXext xorg.libX11 xorg.libXv xorg.libXrandr zlib 
            ncurses5 stdenv.cc binutils
            (pkgs.python310.withPackages(ps: with ps; [
              pip
              pandas
              requests
              numpy
              pytorch
              jaxlibWithCuda
              jax
            ]))
          ];

          shellHook = ''
              export LD_LIBRARY_PATH="${pkgs.linuxPackages.nvidia_x11}/lib"
          '';          
        };
      };
    }

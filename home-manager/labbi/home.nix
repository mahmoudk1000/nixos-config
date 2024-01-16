{ config
, pkgs
, lib
, ...
}:

let
  obsidian = lib.throwIf (lib.versionOlder "1.5.3" pkgs.obsidian.version) "Obsidian no longer requires EOL Electron" (
    pkgs.obsidian.override {
      electron = pkgs.electron_25.overrideAttrs (_: {
        preFixup = "patchelf --add-needed ${pkgs.libglvnd}/lib/libEGL.so.1 $out/bin/electron"; # NixOS/nixpkgs#272912
        meta.knownVulnerabilities = [ ]; # NixOS/nixpkgs#273611
      });
    }
  );
in
{
    imports = [
        ../../modules/programs
        ../../modules/services
        ../../modules/x
    ];

    home = {
        username = "mahmoud";
        homeDirectory = "/home/mahmoud";
        stateVersion = "22.05";
        extraOutputsToInstall = [ "man" ];
        packages = with pkgs; [

            vim
            unzip
            curl
            wget
            jq
            playerctl
            pamixer
            isync
            bitwarden-cli
            pass
            libnotify

            psmisc
            mpc-cli
            ncmpcpp
            xclip
            pfetch
            spotdl
            ventoy-bin
            yt-dlp
            
            ffmpeg
            arandr
            imagemagick
            rtorrent
            nsxiv

            st
            zoom-us
            inkscape
            freetube
            libreoffice
            discord
            anki-bin
            spotify
            tdesktop
            element-desktop
            foliate
            obsidian
            evince
            mpv
            krita
            popcorntime

            libsForQt5.breeze-icons
            xorg.xmodmap

            # work
            opentofu
            ansible
            kubernetes-helm
            kubernetes
            minikube
            kubectl
            docker-compose
            gnumake
            kustomize
            terraform

        ] ++ (import ../../modules/scripts { inherit pkgs; });
    };

    xdg = {
        userDirs = {
            enable = true;
            desktop  = "\$HOME/";
            documents = "\$HOME/docs";
            download = "\$HOME/download";
            music = "\$HOME/musik";
            pictures = "\$HOME/pics";
            videos = "\$HOME/videos";
        };
    };

    programs = {
        home-manager.enable = true;
        nix-index ={
            enable = true;
            enableZshIntegration = true;
        };
    };

    xsession = {
        enable = true;
        windowManager = {
            # command = "2bwm";
            bspwm.enable = false;
            herbstluftwm.enable = false;
            awesome.enable = true;
        };
    };

    systemd.user.startServices = "sd-switch";
}


{ config, pkgs, ... }:

{
  # --- SISTEMA E BOOT ---
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "elysium"; 
  networking.networkmanager.enable = true;
  networking.nameservers = [
    "9.9.9.9"
    "149.112.112.112"
  ];
  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "pt_BR.UTF-8/UTF-8"
    "ja_JP.UTF-8/UTF-8"
  ];

  # Hardware AMD + Intel Microcode
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.cpu.amd.updateMicrocode = true;
  services.xserver.videoDrivers = [ "amdgpu" ];

  # --- SERVIÇOS DO SISTEMA ---
  services.blueman.enable = true;
  hardware.bluetooth.enable = true;
  services.printing.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  programs.dconf.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.flatpak.enable = true;
  services.displayManager.defaultSession = "hyprland";
  services.upower.enable = true;
  services.mpd.enable = true;
  services.ollama = {
      enable = true;
    };
  services.syncthing = {
    enable = true;
    user = "ely";
    dataDir = "/home/ely/Syncthing";
    configDir = "/home/ely/.config/syncthing";
    openDefaultPorts = true;
  };
  services.auto-cpufreq.enable = true;
  services.auto-cpufreq.settings = {
    battery = {
      governor = "powersave";
      turbo = "never";
    };
    charger = {
      governor = "performance";
      turbo = "auto";
    };
  };
  # Docker e ADB
  virtualisation = {
    containers.enable = true;
    docker = {
      enable = true;
    };
    podman = {
      enable = false;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };
  virtualisation.libvirtd.enable = true;

  # --- USUÁRIO E SHELL ---
  users.users.ely = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" "docker" "adbusers" "lp" "video" "podman" "kvm" "libvirtd" ];
  };
  programs.zsh.enable = true;
  programs.zsh.promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";

  # Home Manager Integrado (Configuração 2026)
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.ely = { pkgs, config, ... }: {
    home.packages = with pkgs; [
      zsh-powerlevel10k
    ];

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      history.size = 10000;
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" ];
      };
      initContent = ''
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
      '';
    };

    home.pointerCursor = {
      name = "Hackneyed";
      package = pkgs.hackneyed;
      size = 24;
      gtk.enable = true;
      x11.enable = true;
    };

    gtk = {
      enable = true;

      theme = {
        name = "Colloid-Dark";
        package = pkgs.colloid-gtk-theme;
      };

      iconTheme = {
        name = "Colloid-Dark";
        package = pkgs.colloid-icon-theme;
      };

      cursorTheme = {
        name = "Hackneyed";
        package = pkgs.hackneyed;
        size = 24;
      };

      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };

      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
      gtk4.theme = config.gtk.theme;
    };
    
    qt = {
      enable = true;
      platformTheme.name = "qtct";
      style.name = "kvantum";
    };

    programs.librewolf = {
      enable = true;
      profiles = {
        Elysium = {
          id = 0;
          extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
            ublock-origin
            bitwarden
            darkreader
            violentmonkey
          ]; 
        };
        Justo   = {
          id = 1;
          extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
            ublock-origin
            bitwarden
            darkreader
          ];
        };
      };
      settings = {
        "privacy.sanitize.sanitizeOnShutdown" = false;
        "privacy.clearOnShutdown_v2.cookiesAndStorage" = false;
        "privacy.clearOnShutdown_v2.historyFormDataAndDownloads" = false;
        "privacy.clearOnShutdown_v2.siteSettings" = false;
        "privacy.clearOnShutdown.history" = false;
        "privacy.clearOnShutdown.cookies" = false;
        "network.cookie.lifetimePolicy" = 0;
        "webgl.disabled" = false;
        "privacy.resistFingerprinting" = false;
      };
    };

    services.easyeffects.enable = true;

    dconf.settings = {
      "org/gnome/desktop/default-applications/terminal" = {
        exec = "kitty";
        exec-arg = "-e";
      };
    };

    home.stateVersion = "25.11"; 
  };

  # --- PACOTES ---
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # Essenciais e Sistema
    neovim vim git git-lfs wget curl unzip _7zz p7zip p7zip-rar fastfetch btop htop ncdu tree
    pavucontrol brightnessctl inxi lshw dmidecode smartmontools e2fsprogs dosfstools glib
    usbutils pciutils radeontop appimage-run ffmpegthumbnailer poppler-utils libreoffice
    
    # Wayland / Hyprland Ecosystem / Look and Feel stuff too
    kitty waybar mako wlogout hyprpaper hyprlock hypridle hyprsunset hyprpolkitagent
    wl-clipboard cliphist grim slurp nwg-look quickshell rofi awww
    
    # Interface / Arquivos e Utilidades
    nemo-with-extensions nemo-fileroller file-roller gparted pcmanfm-qt
    zathura imv krita gimp vlc mpv-unwrapped mpc cava obsidian
    
    # Comunicação e Internet
    firefox bitwarden-desktop discord vesktop telegram-desktop
    qbittorrent proton-vpn
    
    # Dev e SDKs e TALS
    gcc gnumake cmake clang llvm asdf-vm
    python3 python3Packages.pip
    nodejs_24 # Versão LTS/Estável comum em 2026
    openjdk21
    dotnet-sdk_10 # Versão de 2026
    postman
    android-tools
    codex
    ollama
    claude-code
    podman
    podman-desktop
    qemu_kvm
    libvirt
    virt-manager

    # Editores
    vscode zed-editor unityhub android-studio jetbrains.clion jetbrains.idea
    
    # Games e Entretenimento
    steam prismlauncher
    tetrio-desktop mangohud goverlay gamescope
    #lutris
    wineWow64Packages.stable
    winetricks
    protonup-qt
    pear-desktop
    vulkan-tools

    # Gravação e Áudio
    gpu-screen-recorder
    gpu-screen-recorder-gtk
    easyeffects
    lsp-plugins
    calf
    
    # Temas e Estética
    colloid-gtk-theme colloid-icon-theme adw-gtk3
    libsForQt5.qtstyleplugin-kvantum kdePackages.qtstyleplugin-kvantum 
    libsForQt5.qt5ct kdePackages.qt6ct hackneyed
  ];

  xdg.mime.defaultApplications = {
    "inode/directory" = "nemo.desktop";
    "x-scheme-handler/http" = "helium-appimage.desktop";
    "x-scheme-handler/https" = "helium-appimage.desktop";
    "x-scheme-handler/about" = "helium-appimage.desktop";
    "x-scheme-handler/unknown" = "helium-appimage.desktop";
    "video/mp4" = "vlc.desktop";
    "video/x-matroska" = "vlc.desktop";
    "image/png" = "imv-dir.desktop";
    "image/jpeg" = "imv-dir.desktop";
    "application/json" = [ "code.desktop" ];
    "text/plain" = [ "code.desktop" ];
    "text/x-csrc" = [ "code.desktop" ];
    "text/x-c++src" = [ "code.desktop" ];
    "text/x-csharp" = [ "code.desktop" ];
    "text/x-java" = [ "code.desktop" ];
    "application/javascript" = [ "code.desktop" ];
    "text/javascript" = [ "code.desktop" ];
    "text/x-python" = [ "code.desktop" ];
    "text/markdown" = [ "code.desktop" ];
    "application/xml" = [ "code.desktop" ];
    "text/html" = [ "code.desktop" ];
    "text/css" = [ "code.desktop" ];
  };

  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  programs.gamemode.enable = true;

  # Variáveis de Ambiente
  environment.sessionVariables = {
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    #XDG_SESSION_DESKTOP = "Hyprland";
    TERMINAL = "kitty";
    NIXOS_OZONE_WL = "1";
    EDITOR = "nvim";
    SUDO_EDITOR="nvim";
    QT_QPA_PLATFORM = "wayland";
    QT_STYLE_OVERRIDE = "kvantum";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    XCURSOR_THEME = "Hackneyed";
    XCURSOR_SIZE = "24";
    # Fix GPU Unreal
    VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json:/run/opengl-driver-32/share/vulkan/icd.d/radeon_icd.i686.json";
  };

  # --- SOM E MULTIMÍDIA ---
  security.rtkit.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;
  security.pam.services.sddm.enableGnomeKeyring = true;
  security.pam.services.sshd.enableGnomeKeyring = true;
  
  services.pipewire = {
  enable = true;
  alsa.enable = true;
  pulse.enable = true;
  jack.enable = true;
  wireplumber.enable = true;

  extraConfig.pipewire."92-low-latency" = {
    "context.properties" = {
      "default.clock.rate" = 48000;
      "default.clock.quantum" = 1024;
      "default.clock.min-quantum" = 1024;
      "default.clock.max-quantum" = 1024;
    };
  };
};

  # --- DISPLAY MANAGER ---
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;

    settings = {
      Theme = {
        CursorTheme = "Hackneyed";
        CursorSize = 24;
      };
    };
  };

  programs.silentSDDM = {
    enable = true;
    theme = "rei";
  };

  programs.hyprland = {
    enable = true;
    withUWSM = false;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
  
  # Nix LD para rodar AppImages (Zen/Helium)
  programs.nix-ld = {
  enable = true;
  libraries = with pkgs; [
      stdenv.cc.cc
      zlib
      openssl
      curl
      expat
      glib
      gtk3
      atk
      at-spi2-atk
      at-spi2-core
      pango
      cairo
      nss
      nspr
      dbus
      alsa-lib
      libdrm
      mesa
      libglvnd
      libgbm
      wayland
      libxkbcommon
      libx11
      libxcomposite
      libxdamage
      libxext
      libxfixes
      libxrandr
      libxcb
      cups
    ];
  };

  # Fontes
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    font-awesome
    ipafont
    unifont
  ];

  # --- DISCOS ---
  fileSystems."/mnt/HDD" = {
    device = "/dev/disk/by-uuid/5c180f20-d517-42b0-a400-d15ca0f9ca96";
    fsType = "ext4";
    options = [ "defaults" "nofail" "x-gvfs-show" ];
  };

  fileSystems."/mnt/SSD" = {
    device = "/dev/disk/by-uuid/e39f2392-a208-4374-8eb4-cb982b618d00";
    fsType = "ext4";
    options = [ "defaults" "nofail" "x-gvfs-show" ];
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.11"; 
}

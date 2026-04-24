{ config, pkgs, ... }:

{
  # --- SISTEMA E BOOT ---
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  # Usando Kernel ZEN (igual ao seu Arch em 2026)
  boot.kernelPackages = pkgs.linuxPackages_zen;

  networking.hostName = "elysium"; 
  networking.networkmanager.enable = true;
  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "en_US.UTF-8";

  # Hardware AMD + Intel Microcode
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.cpu.intel.updateMicrocode = true;
  services.xserver.videoDrivers = [ "amdgpu" ];

  # --- SERVIÇOS DO SISTEMA ---
  services.blueman.enable = true;
  hardware.bluetooth.enable = true;
  services.printing.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  programs.dconf.enable = true;
  
  # Docker e ADB
  virtualisation.docker.enable = true;
  programs.adb.enable = true;

  # --- USUÁRIO E SHELL ---
  users.users.ely = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" "docker" "adbusers" "lp" "video" ];
  };
  programs.zsh.enable = true;

  # Home Manager Integrado (Configuração 2026)
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.ely = { pkgs, ... }: {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      history.size = 10000;
      oh-my-zsh = {
        enable = true;
        theme = "lambda";
        plugins = [ "git" ];
      };
    };

    home.pointerCursor = {
      name = "Hackneyed";
      package = pkgs.hackneyed;
      size = 24;
      gtk.enable = true;
      x11.enable = true;
    };

    services.easyeffects.enable = true;

    home.stateVersion = "25.11"; 
  };

  # --- PACOTES ---
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # Essenciais e Sistema (Baseado no seu Arch em 2026)
    neovim vim git git-lfs wget curl unzip 7zz p7zip fastfetch btop htop ncdu tree
    pavucontrol brightnessctl inxi lshw dmidecode smartmontools e2fsprogs dosfstools
    usbutils pciutils radeontop
    
    # Wayland / Hyprland Ecosystem
    kitty waybar mako wlogout hyprpaper hyprlock hypridle hyprsunset hyprpolkitagent
    wl-clipboard cliphist grim slurp uwsm nwg-look quickshell
    rofi-wayland 
    
    # Interface e Arquivos
    nemo-with-extensions nemo-fileroller gparted partitionmanager pcmanfm-qt
    ark zathura imv krita gimp vlc mpv mpc cava
    
    # Comunicação e Internet
    firefox bitwarden-desktop discord vesktop telegram-desktop
    qbittorrent protonvpn-gui
    
    # Dev e SDKs
    gcc gnumake cmake clang llvm asdf-vm
    python3 python3Packages.pip
    nodejs_24 # Versão LTS/Estável comum em 2026
    openjdk21
    dotnet-sdk_10 # Versão de 2026
    postman
    
    # Editores
    vscode jetbrains.idea-community jetbrains-toolbox zed-editor
    
    # Games e Entretenimento
    steam lutris prismlauncher rustdesk
    tetrio-desktop unityhub mangohud goverlay gamescope
    
    # Gravação e Áudio
    gpu-screen-recorder
    gpu-screen-recorder-gtk
    easyeffects
    lsp-plugins
    calf
    noise-suppression-for-voice
    
    # Temas e Estética
    papirus-icon-theme materia-theme adw-gtk3
    libsForQt5.qtstyleplugin-kvantum kdePackages.qtstyleplugin-kvantum
    qt5ct qt6ct hackneyed
  ];

  # Variáveis de Ambiente
  environment.sessionVariables = {
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";
    TERMINAL = "kitty";
    NIXOS_OZONE_WL = "1";
    EDITOR = "nvim";
  };

  # --- SOM E MULTIMÍDIA ---
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  # --- DISPLAY MANAGER ---
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  programs.hyprland.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
  
  # Nix LD para rodar AppImages (Zen/Helium)
  programs.nix-ld.enable = true;

  # Fontes
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    font-awesome
  ];

  # --- DISCOS (Verifique os UUIDs no seu hardware real) ---
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

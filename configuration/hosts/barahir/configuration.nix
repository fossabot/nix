{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./wireguard.nix
    ./links.nix

    #    ./mysql.nix
    ./postgresql.nix

    ../../default.nix

    ../../common
    ../../common/pbb.nix
    ../../desktop
    ../../desktop/sway.nix
    #    ../../desktop/plasma.nix
  ];

  hardware.cpu.intel.updateMicrocode = true;
  boot.loader.grub.device = "/dev/disk/by-id/wwn-0x5002538d00000000";
  boot.kernelModules = [
    #"vfio-pci"
    "amdgpu"
  ];

  # FIXME: needed?
  #services.openssh.passwordAuthentication = true;

  boot.binfmt.emulatedSystems = [
    "aarch64-linux" # "x86_64-windows"
    "mipsel-linux"
  ];

  boot.initrd.luks.devices."cryptLVM".device =
    "/dev/disk/by-id/wwn-0x5002538d00000000-part2";
  boot.initrd.luks.devices."cryptLVM".allowDiscards = true;

  boot.kernelParams = [
    #  "intel_iommu=on"
    #  "vfio-pci.ids=1002:699f,1002:aae0"
    "radeon.cik_support=0"
    "amdgpu.cik_support=1"
    "radeon.si_support=0"
    "amdgpu.si_support=1"
  ];

  networking.useDHCP = false;
  networking.hostName = "barahir";
  networking.domain = "kloenk.de";
  networking.hosts = {
    "192.168.178.1" = [ "fritz.box" ];
    "192.168.178.248" = [ "thrain" "thrain.fritz.box" ];
  };
  networking.nameservers = [ "1.1.1.1" "192.168.178.1" ];
  networking.search = [ "fritz.box" ];

  # transient root volume
  boot.initrd.postMountCommands = ''
    cd /mnt-root
    chattr -i var/lib/empty
    rm -rf $(ls -A /mnt-root | grep -v 'nix' |  grep -v 'persist' | grep -v 'var')

    cd /mnt-root/persist
    rm -rf $(ls -A /mnt-root/persist | grep -v 'data' )

    cd /mnt-root/var
    rm -rf $(ls -A /mnt-root/var | grep -v 'src' | grep -v 'log' | grep -v 'lib' )

    cd /mnt-root/var/lib
    rm -rf $(ls -A /mnt-root/var/lib | grep -v 'bluetooth' )

    cd /mnt-root/var/src
    rm -rf $(ls -A /mnt-root/var/src | grep -v 'secrets')

    mkdir /mnt-root/mnt

    cd /
  '';
  # save password changings FIXME: replace with environment.etc.".."
  #systemd.tmpfiles.rules = [
  #  "L /etc/shadow - - - - /persist/secrets/shadow"
  #];

  nixpkgs.config.allowUnfree = true;
  nix.gc.automatic = false;

  services.printing.browsing = true;
  services.printing.enable = true;
  services.avahi.enable = true;

  environment.systemPackages = with pkgs; [
    lm_sensors
    #wine
    docker
    virtmanager
    gnumake
    postgresql_12
  ];

  users.users.kloenk.packages = with pkgs; [
    spotifywm
    steam
    steamcontroller
    minecraft
    multimc
    elementary-planner
  ];

  # docker foo
  virtualisation.docker.enable = true;

  # virtmanager
  virtualisation.libvirtd = {
    enable = true;
    onShutdown = "shutdown";
    qemuVerbatimConfig = ''
      cgroup_device_acl = [
        "/dev/kvm",
        "/dev/input/by-id/usb-STMicroelectronics_obins_anne_keyboard_STM32-if01-event-kbd",
        "/dev/input/by-id/usb-G-Tech_Wireless_Dongle-event-mouse",
        "/dev/null", "/dev/full", "/dev/zero",
        "/dev/random", "/dev/urandom",
        "/dev/ptmx", "/dev/kvm", "/dev/kqemu",
        "/dev/rtc","/dev/hpet", "/dev/sev"
      ]
    '';
  };

  users.users.kloenk.extraGroups = [
    "dialout" # allow serial connections
    #"plugdev" # allow st connections
    "docker" # docker controll group
    "libvirtd" # libvirt conncetions
  ];

  services.pcscd.enable = true;

  hardware.bluetooth.enable = true;
  # add bluetooth sink
  #hardware.bluetooth.extraConfig = ''
  #  [General]
  #  Enable=Source,Sink,Media,Socket
  #'';
  hardware.bluetooth.config.General.Enable = "Source,Sink,Media,Socket";
  hardware.pulseaudio.zeroconf.discovery.enable = true;
  hardware.pulseaudio.extraModules = [ pkgs.pulseaudio-modules-bt ];
  hardware.pulseaudio.package = pkgs.pulseaudioFull;
  hardware.pulseaudio.support32Bit = true;
  hardware.pulseaudio.tcp.anonymousClients.allowedIpRanges =
    [ "192.168.178.0/24" ];

  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;

  # fix home-manager
  systemd.services.home-manager-kloenk.after = [ "home-kloenk.mount" ];

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "20.09";
}

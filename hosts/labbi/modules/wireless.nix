{ config, pkgs, ... }:

{
    # Networking
    networking  = {
        hostName = "labbi";
        wireless = {
            iwd.enable = true;
            interfaces = [ "wlan0" ];
        };
        useDHCP = false;
        interfaces.wlan0.useDHCP = true;
        interfaces.enp2s0.useDHCP = true;
    };

    # NextDNS
    services = {
        nextdns = {
            enable = false;
            arguments = [
                "-config set"
                "-profile wlan0=b28d16"
                "-report-client-info"
                "-auto-activate"
            ];
        };
        resolved = {
            enable = true;
            extraConfig = ''
                [Resolve]
                DNS=45.90.28.0#b28d16.dns.nextdns.io
                DNS=2a07:a8c0::#b28d16.dns.nextdns.io
                DNS=45.90.30.0#b28d16.dns.nextdns.io
                DNS=2a07:a8c1::#b28d16.dns.nextdns.io
                DNSOverTLS=yes
            '';
        };
    };

    # Bluetooth
    hardware.bluetooth = {
        enable = true;
        package = pkgs.bluez;
        powerOnBoot = false;
        settings = {
            General = {
                Enable = "Source,Sink,Media,Socket";
            };
        };
    };
}

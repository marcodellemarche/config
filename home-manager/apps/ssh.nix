{ lib, ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    # Coder writes its sections to ~/.ssh/config.d/coder (included below).
    # To (re)generate coder's section after updates:
    #   coder config-ssh --ssh-config-file ~/.ssh/config.d/coder
    includes = [ "~/.ssh/config.d/*" ];
    settings = {
      "*" = {
        ServerAliveInterval = 60;
        ServerAliveCountMax = 3;
        IdentityFile = "~/.ssh/id_ed25519";
      };
      "giulio-1" = {
        HostName = "51.159.173.20";
        User = "root";
      };
      "pacco-1" = { HostName = "3.71.175.216"; User = "ubuntu"; };
      "pacco-2" = { HostName = "18.159.206.105"; User = "ubuntu"; };
      "pacco-3" = { HostName = "3.72.50.250"; User = "ubuntu"; };
      "pacco-4" = { HostName = "18.184.200.106"; User = "ubuntu"; };
      "pacco-5" = { HostName = "3.67.197.230"; User = "ubuntu"; };
      "pacco-6" = { HostName = "18.193.84.10"; User = "ubuntu"; };
      "pacco-7" = { HostName = "3.127.108.204"; User = "ubuntu"; };
      "pacco-8" = { HostName = "54.93.105.225"; User = "ubuntu"; };
      "pacco-9" = { HostName = "51.15.59.68"; User = "root"; };
      "pacco-10" = { HostName = "51.158.190.168"; User = "root"; };
      "pacco-11" = { HostName = "51.15.101.220"; User = "root"; };
      "pacco-12" = { HostName = "51.158.166.151"; User = "root"; };
      "celeste-test" = { HostName = "10.158.142.1"; User = "celeste"; };
      "celeste-nuc" = { HostName = "10.35.10.51"; User = "celeste"; };
      "celeste-jetson" = { HostName = "10.35.10.43"; User = "celeste"; };
      "orbital" = { HostName = "10.35.10.109"; User = "orbital"; };
    };
  };
}

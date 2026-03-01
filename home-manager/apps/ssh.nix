{ lib, ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    # Coder writes its sections to ~/.ssh/config.d/coder (included below).
    # To (re)generate coder's section after updates:
    #   coder config-ssh --ssh-config-file ~/.ssh/config.d/coder
    extraConfig = ''
      Include ~/.ssh/config.d/*
    '';
    matchBlocks = {
      "*" = {
        serverAliveInterval = 60;
        serverAliveCountMax = 3;
        identityFile = "~/.ssh/id_ed25519";
      };
      "giulio-1" = {
        hostname = "51.159.173.20";
        user = "root";
      };
      "pacco-1" = { hostname = "3.71.175.216"; user = "ubuntu"; };
      "pacco-2" = { hostname = "18.159.206.105"; user = "ubuntu"; };
      "pacco-3" = { hostname = "3.72.50.250"; user = "ubuntu"; };
      "pacco-4" = { hostname = "18.184.200.106"; user = "ubuntu"; };
      "pacco-5" = { hostname = "3.67.197.230"; user = "ubuntu"; };
      "pacco-6" = { hostname = "18.193.84.10"; user = "ubuntu"; };
      "pacco-7" = { hostname = "3.127.108.204"; user = "ubuntu"; };
      "pacco-8" = { hostname = "54.93.105.225"; user = "ubuntu"; };
      "pacco-9" = { hostname = "51.15.59.68"; user = "root"; };
      "pacco-10" = { hostname = "51.158.190.168"; user = "root"; };
      "pacco-11" = { hostname = "51.15.101.220"; user = "root"; };
      "pacco-12" = { hostname = "51.158.166.151"; user = "root"; };
    };
  };
}

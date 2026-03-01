{ ... }:
{
  # programs.ssh is disabled to avoid overwriting the existing ~/.ssh/config,
  # which contains coder-managed sections and real server hosts.
  # When ready to migrate, enable it and move entries here:
  # programs.ssh = {
  #   enable = true;
  #   matchBlocks = {
  #     "*" = {
  #       serverAliveInterval = 60;
  #       serverAliveCountMax = 3;
  #     };
  #     "giulio-1" = {
  #       hostname = "51.159.173.20";
  #       user = "root";
  #     };
  #     "pacco-1" = {
  #       hostname = "3.71.175.216";
  #       user = "ubuntu";
  #     };
  #   };
  # };
}

{pkgs, lib, config, ... }: {
  
  # options = {
  #     ssh.enable = lib.mkEnableOption "enables ssh";
  #   };


programs.ssh = {
   enable = true;	
};
}

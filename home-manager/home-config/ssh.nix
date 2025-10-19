{pkgs, lib, config, ... }: {
  
  options = {
      ssh.enable = lib.mkEnableOption "enables ssh";
    };


programs.ssh = lib.mkIf config.ssh.enable {
   enable = true;	
   startAgent = true;
   addKeysToAgent = "yes";
};
}

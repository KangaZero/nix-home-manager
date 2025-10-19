  {pkgs, lib, config, ... }: {
  
  # options = {
  #     git.enable = lib.mkEnableOption "enables git";
  #   };
  #
  programs.git = {
   enable = true;
   userName = "KangaZero";
   userEmail = "samuelyongw@gmail.com";
   extraConfig = {
    credential.helper = "store";
     };
   };
  }

{pkgs, lib, config, ... }: {
 programs.hyprlock.enable = true;
  services.hypridle.enable = true;

   wayland.windowManager.hyprland.settings = {
    "$mod" = "super";
    bind =
      [
        "$mod, f, exec, firefox"
        ", print, exec, grimblast copy area"
      ]
      ++ (
        # workspaces
        # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
        builtins.concatLists (builtins.genList (i:
            let ws = i + 1;
            in [
              "$mod, code:1${toString i}, workspace, ${toString ws}"
              "$mod shift, code:1${toString i}, movetoworkspace, ${toString ws}"
            ]
          )
          9)
      );
  };
}

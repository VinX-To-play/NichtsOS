{ config, pkgs, home-manager, ... }:

{
  # TODO please change the username & home directory to your own
  home.username = "vincentl";
  home.homeDirectory = "/home/vincentl";

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';


  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # here is some command line tools I use frequently
    # feel free to add your own or remove some of them

    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor

  ];

  home-manager.users.${globals.user} = {
      home.file."config/ssh/id_rsa".source = ./id_rsa;
      home.file."config/ssh/id_rsa".source = ./id_rsa.pub;

      home.sessionVariables = {
         GIT_SSH_COMMAND = "ssh -o IdentitiesOnly=yes -i /users/${globals.user}/config/ssh/id_rsa";
      };
  };

  programs.git = {
     enable=true;
     extraConfig= {
       pull.rebase = false;
     };
     userEmail="v@lundborgs.de";
     userName="VinX-To-play";
  };

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      droidcam-obs
      waveform
    ];
  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}

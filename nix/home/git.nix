{
  config,
  pkgs,
  ...
}: {
  enable = true;
  lfs.enable = true;
  userName = "Arthur Mariano";
  userEmail = "arthvm@proton.me";
  signing.key = null;
  signing.signByDefault = true;

  extraConfig = {
    pull = {
      rebase = true;
    };
    init = {
      defaultBranch = "main";
    };

    url = {
      "git@github.com:" = {
        insteadOf = "https://github.com/";
      };
    };
  };
}

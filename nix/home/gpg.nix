{pkgs, ...}: {
  enable = true;

  publicKeys = [
    {source = ../../keys/gpg-0xD56D8DEB63E4A091-2025-03-05.asc;}
  ];
}

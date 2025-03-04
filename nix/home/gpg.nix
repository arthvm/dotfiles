{pkgs, ...}: {
  enable = true;

  publicKeys = [
    {source = ../../keys/gpg-66CEA89A6D73F03C-2025-03-04.asc;}
  ];
}

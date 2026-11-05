{ pkgs, ... }:
{
  languages.rust.enable = true;

  packages = [
    pkgs.typst
    pkgs.glibcLocales
  ];
  env.LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";

  scripts.docs.exec = ''
    mkdir -p docs/build
    typst compile docs/main.typ docs/build/main.pdf
  '';

  scripts.docs-watch.exec = ''
    mkdir -p docs/build
    typst watch docs/main.typ docs/build/main.pdf
  '';
}

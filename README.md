# SOE PhD thesis

Primusz Péter doktori értekezésének LyX-forrása.

## Fordítás

Szükséges környezet:

- LyX 2.5
- MiKTeX, benne `pdflatex` és `biber`
- PowerShell

A repó gyökerében futtatandó:

```powershell
.\build.ps1
```

A kész dokumentum helye: `build/phdthesis.pdf`.

A build először a LyX parancssori exportját használja, majd a bibliográfiát
`pdflatex -> biber -> pdflatex -> pdflatex` sorrendben állítja elő. Az első
LaTeX-menet draft módban fut, hogy a Biber csak teljesen elkészült `.bcf`
fájlt kapjon.

Az eredeti LyX 2.0 dokumentum változatlan másolata:
`versions/phdthesis-lyx20-original.lyx`.

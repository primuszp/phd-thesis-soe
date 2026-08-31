# SOE doktori értekezés

## Az értekezésről

**Cím:** *Pályaszerkezet-gazdálkodás az erdészeti feltáróhálózatokon*  
**Szerző:** Primusz Péter  
**Intézmény:** Nyugat-magyarországi Egyetem, Roth Gyula Erdészeti és Vadgazdálkodási Tudományok Doktori Iskola, Erdészeti Tudomány Program  
**Helyszín:** Sopron

Az értekezés az erdészeti feltáróutak állapotfelvételével, értékelésével és fenntartásának megalapozásával foglalkozik. Bemutatja a digitális szubjektív állapotfelvétel és -értékelés eszközrendszerét, az ABBA kézi behajlásmérő fejlesztését, valamint az FWD/ABBA deformációs vonalak elemzésére és a pályaszerkezeti rétegek modulusának becslésére kidolgozott módszereket.

## Forrás és fordítás

A fő LyX-fájl: `phdthesis.lyx`.

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

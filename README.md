# Access Point map database support tools 

## $B5!G=35MW(B
`apmap-eduroamJP.pl` $B$O!"(BCityroam$B;EMM$N4pCO6I4IM}%7!<%H$r85$K!"(B
eduroam JP$B?=@A%7%9%F%`8~$1$K4pCO6I%^%C%W%G!<%?$r:n@.$9$k$?$a$N!"(B
$B;Y1g%D!<%k$G$9!#(B

`apmap-kml.pl` $B$O!"(BCityroam$B;EMM$N4pCO6I4IM}%7!<%H$r85$K!"(B
Google maps$B$N(BKML$B%U%!%$%k$r:n@.$9$k$?$a$N!";Y1g%D!<%k$G$9!#(B
KML$B%U%!%$%k$N(BPlacemark$B%V%m%C%/$N$_=PNO$7$^$9!#(B

## Cityroam$B;EMM$N4pCO6I4IM}%7!<%H$K$D$$$F(B
$B4pCO6I>pJs$N4IM}$H!"AH?%4V$G$N%G!<%?8r49$rMF0W$K$9$k$?$a$K!"(B
$BL5@~G'>ZO"7H6(2q(B (Cityroam$B6(2q(B) $B$G(B
$B:vDj$5$l$?!"I8=`7A<0$N%9%W%l%C%I%7!<%H$G$9!#(B

## apmap-eduroamJP.pl$B$N;H$$J}(B
$B=`Hw$H$7$F0J2<$r<B9T$7$F!"B-$j$J$$%b%8%e!<%k$,$"$l$P%$%s%9%H!<%k$7$F$*$/!#(B
```
$ perl -c apmap-eduroamJP.pl
```

1. $B4pCO6I%^%C%W%G!<%?$N%F%s%W%l!<%H(B `APmap-tmpl-vXXX.xlsx` $B$K=>$C$F!"(B
$B4pCO6I4IM}%7!<%H$r:n@.$9$k!#(B
2. CSV UTF-8$B7A<0$G%(%/%9%]!<%H$9$k!#(B($BI,$:(BUTF-8$B%(%s%3!<%I$K$9$k(B)
3. $B>e5-(BCSV$B%U%!%$%k$r(B `apmap-eduroamJP.pl` $B$KFI$_9~$^$;$F!"(B
$B%j%@%$%l%/%H$K$h$C$F=PNO%U%!%$%k$r:n@.$9$k!#(B
($B=PNO%U%!%$%k$O(BBOM$BIU$-$J$3$H$KN10U(B)
```
$ ./apmap-eduroamJP.pl infile.csv > outfile.csv
```
4. eduroam JP$B?=@A%7%9%F%`$+$i%@%&%s%m!<%I$7$?%9%W%l%C%I%7!<%H(B
($B%F%s%W%l!<%H(B)$B$r;H$$!"(B
$B$^$:(B**institution$B%7!<%H(B**$B$rKd$a$F$*$/!#(B
5. $B%3%^%s%I$G@8@.$5$l$?(BCSV$B%U%!%$%k(B (outfile.csv) 
$B$rJL%&%#%s%I%&$N(BExcel$B$J$I$GFI$_9~$_!"(B
$B%F%s%W%l!<%H$N(B**location$B%7!<%H(B**$B$K%3%T!<!&%Z!<%9%H$9$k!#(B
$B85$+$iF~$C$F$$$?I=$O>e=q$-:o=|$9$k!#(B
6. $B$G$->e$C$?%9%W%l%C%I%7!<%H$N%U%!%$%k(B (.xlsx) $B$r(B
eduroam JP$B?=@A%7%9%F%`$K%"%C%W%m!<%I$9$k!#(B

## apmap-kml.pl$B$N;H$$J}(B
$B%9%/%j%W%H$r%F%-%9%H%(%G%#%?$GJT=8$7$F!"(Bicon$B$N@_Dj$J$I$r%+%9%?%^%$%:$9$k!#(B
$B0J2<$r<B9T$7$F!"B-$j$J$$%b%8%e!<%k$,$"$l$P%$%s%9%H!<%k$7$F$*$/!#(B
```
$ perl -c apmap-kml.pl
```
1. $B4pCO6I%^%C%W%G!<%?$N%F%s%W%l!<%H(B `APmap-tmpl-vXXX.xlsx` $B$K=>$C$F!"(B
$B4pCO6I4IM}%7!<%H$r:n@.$9$k!#(B
2. CSV UTF-8$B7A<0$G%(%/%9%]!<%H$9$k!#(B($BI,$:(BUTF-8$B%(%s%3!<%I$K$9$k(B)
3. $B>e5-(BCSV$B%U%!%$%k$r(B `apmap-kml.pl` $B$KFI$_9~$^$;$F!"(B
$B%j%@%$%l%/%H$K$h$C$F=PNO%U%!%$%k$r:n@.$9$k!#(B
```
$ ./apmap-kml.pl infile.csv > outfile.kml
```
4. $B=PNO%U%!%$%k$K$O(BPlacemark$B%V%m%C%/$7$+4^$^$l$J$$$N$G!"(B
$B@hF,$HKvHx$KB-$j$J$$MWAG$rJd$&!#(B  
(KML/KMZ$B%U%!%$%k$NFbMF$O(BGoogle maps$B$N%I%-%e%a%s%H$r;2>H(B)
5. KML$B%U%!%$%k$HIU?o$9$k%"%$%3%s$N%$%a!<%8%U%!%$%k$r!"(Bzip$B$G$^$H$a$F!"(B
KMZ$B%U%!%$%k$r:n@.$9$k!#(B  

## $BCm0U;v9`(B
- **No Pull Requests.**  
$B4pK\E*$K(BPR$B$O<u$1IU$1$F$$$J$$$N$G!"=$@5$dMWK>$,$"$k>l9g$O$^$:(B
Issue$B$GO"Mm$7$F$/$@$5$$!#(B
- $B%9%W%l%C%I%7!<%H$rD>@\FI$_9~$`5!G=$O:#8e$N2]Bj$G$9!#(B


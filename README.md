# Information

#
### testing images using old Firefox

-   get [Firefox
    1.5.0.9](https://ftp.mozilla.org/pub/firefox/releases/1.5.0.9/win32/en-GB/)
    and install it in Wine
-   copy NPLS32.DLL into plugins folder
-   run Firefox and open [test
    image](https://entropymine.com/samples/cod/fox.cod)

## Coordinate format

-   an older [usenet discussion on how to decode the geo
    coordinates](https://groups.google.com/g/de.org.ccc/c/xlaNafyxmrM/m/hXZj7J5ksc8J)
    -   did we consider
        [SK-42](https://en.wikipedia.org/wiki/SK-42_reference_system)
        and derivatives?

# Next Steps

-   [ ] Visualise the structure of dsatnord.mp, that is, where are city
    names and coordinates, where are the tiles, etc. Maybe that helps to
    find the index for the tiles.
-   [ ] testing the Netscape plugin:
    -   [ ] install it in a VM together with an older version of Firefox
    -   [ ] test it with a [sample
        image](http://justsolve.archiveteam.org/wiki/Lightning_Strike)
    -   [ ] write one tile into a file and try to open it
-   [ ] test
    [SK-42](https://en.wikipedia.org/wiki/SK-42_reference_system) and
    derivatives

# Files

-   `dsatnord.mp` - data for D-Sat 1 CD 1
-   `NPLS32.DLL` - browser plugin for Netscape/Firefox

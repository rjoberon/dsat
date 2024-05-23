---
title: Viewing tiles with Firefox
image: /img/screenshot_firefox_plugin.png
---

Knowing the offsets of (potential) tiles, we can pick one (56057877)
and extract the tile into a file:

```sh
./src/mp.py -c extract -o img/tile_56057877.cod --offset 56057877 dsatnord.mp
```

Then we get [Firefox
1.5.0.9](https://ftp.mozilla.org/pub/firefox/releases/1.5.0.9/win32/en-GB/)
and install it using (the 32 Bit version of) Wine. From
[sunset.se](ftp://ftp.sunet.se/mirror/archive/ftp.sunet.se/pub/pc/windows/winsock-indstate/Windows95/WWW-Browsers/Plug-In/)
we can download
[ls26.txt](ftp://ftp.sunet.se/mirror/archive/ftp.sunet.se/pub/pc/windows/winsock-indstate/Windows95/WWW-Browsers/Plug-In/ls26.txt)
and the installer for the Netscape plugin
[ls26.exe](ftp://ftp.sunet.se/mirror/archive/ftp.sunet.se/pub/pc/windows/winsock-indstate/Windows95/WWW-Browsers/Plug-In/ls26.txt)
and run the latter with Wine. This results in a couple of files of
which only `NPLS32.DLL` (the actual plugin) is relevant for us. As
described in `ls26.txt`, we "Simply place this file in the plug-ins
directory of [our] 32-bit Netscape." For Firefox running in Wine this
is `~/.wine/drive_c/Program Files/Mozilla Firefox/plugins/`.

Now we can run Firefox using Wine and open a [test
image](https://entropymine.com/samples/cod/fox.cod). It should show
two white foxes. Opening the extracted tile should show a proper D-Sat
satellite image as follows:

![](/img/screenshot_firefox_plugin.png)

It works! :-)

#!/bin/bash

JAI=jai-1_1_3-lib-linux-amd64-jdk.bin
JAI_IMAGEIO=jai_imageio-1_1-lib-linux-amd64-jdk.bin

cd /usr/lib/jvm/java-7-oracle

wget --quiet -c http://data.opengeo.org/suite/jai/${JAI}
sh ${JAI} >/dev/null < <(echo y) >/dev/null < <(echo y)
rm ${JAI}

wget --quiet -c http://data.opengeo.org/suite/jai/${JAI_IMAGEIO}
sed s/+215/-n+215/ ${JAI_IMAGEIO} > fixed.bin #fixes some strange file corruption
sh fixed.bin >/dev/null < <(echo y) >/dev/null < <(echo y)
rm ${JAI_IMAGEIO} fixed.bin

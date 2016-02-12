#!/bin/bash

JAI=jai-1_1_3-lib-linux-amd64-jdk.bin
JAI_IMAGEIO=jai_imageio-1_1-lib-linux-amd64-jdk.bin

cd /usr/lib/jvm/java-7-oracle

wget -c http://data.opengeo.org/suite/jai/${JAI}
sh ${JAI} >/dev/null < <(echo y) >/dev/null < <(echo y)
rm ${JAI}

wget -c http://data.opengeo.org/suite/jai/${JAI_IMAGEIO}
sh ${JAI_IMAGEIO} >/dev/null < <(echo y) >/dev/null < <(echo y)
rm ${JAI_IMAGEIO}

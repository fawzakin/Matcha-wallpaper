#!/bin/bash

# Check if you have Inkscape installed.
ink=$(which inkscape) || { echo "Inkscape is not installed" && exit 1; }

# Create directories
mkdir -p SVG Matcha

# ---| Aliz |---
for svg in Template/*.svg; do
    exp="$(echo ${svg} | sed 's/Template/SVG/;s/\.svg/-dark-aliz.svg/')"
    trg="$(echo ${svg} | sed 's/Template/Matcha/;s/\.svg/-dark-aliz.png/')"
    echo "Exporting ${exp}"
    cp -f ${svg} ${exp}
    sed -i 's/000000/1a1a1a/g;
            s/101010/222222/g;
            s/202020/262626/g;
            s/303030/2b2b2b/g;
            s/404040/323232/g;
            s/ffffff/d7d7d7/g;
            s/aa0000/bc3f39/g;
            s/ff0000/f0554c/g' ${exp}
    ${ink} --export-filename=${trg} ${exp} > /dev/null 2>&1
done

#!/bin/bash


# Listing all variants
ico_all=('arch' 'debian' 'fedora' 'gear' 'kubuntu' 'mint' 'pop' 'solus' 'ubuntu')
bgr_all=('spot' 'stripe')
col_all=('aliz' 'azul' 'sea' 'pueril' 'alice' 'azure' 'tea' 'amethyst')

# Color list
declare -A col_list
col_list[aliz]="1a1a1a 222222 262626 2b2b2b 323232 d7d7d7 bc3f39 f0554c" 
col_list[azul]="14161b 1b1d24 22252c 292b32 303238 d7d7d7 217dbb 3498db"
col_list[sea]="141a1b 1b2224 222b2e 293032 303739 d7d7d7 00906f 2eb398"
col_list[pueril]="1a1a1a 222222 262626 2b2b2b 323232 d7d7d7 6e8e4e 97bb72"
col_list[alice]="1a1a1a 222222 262626 2b2b2b 323232 d7d7d7 a21b1b ef2929"
col_list[azure]="14161b 1b1d24 22252c 292b32 303238 d7d7d7 23446e 3465a4"
col_list[tea]="141a1b 1b2224 222b2e 293032 303739 d7d7d7 4e8e00 73d216"
col_list[amethyst]="1a1a1a 222222 262626 2b2b2b 323232 d7d7d7 5a3a6a 75507b"

# Print out help
print_help() {
printf "Available Options:\\n%s\\n%s\\n%s\\n%s\\n%s\\n%s\\n" \
       "  -i: Icon variant (def: all icons)" \
       "  -b: Background variant (def: all backgrounds)" \
       "  -c: Color variant (def: all colors)" \
       "  -n: Don't export all svg to pngs (def: export to png)" \
       "  -o: Optimize exported pngs (def: not optimize)" \
       "  -h: Show this message and exit"
exit 0
}

# Main function: Generating our wallpapers
export_color() {
for i in ${ico_sel[@]:-${ico_all[@]}}; do for b in ${bgr_sel[@]:-${bgr_all[@]}}; do for c in ${col_sel[@]:-${col_all[@]}}; do

    local name="Template/${i}-${b}.svg"
    local col_val="${col_list[${c}]}"
    local esvg="SVG/${i}-${b}-${c}.svg"
    local epng="Matcha/${i}-${b}-${c}.png"

    [ ! -f "${name}" ] && echo "${name} doesn't exist" && echo "" && break 
    [ -z "${col_val}" ] && echo "${c} isn't defined for ${esvg}" && echo "" && continue

    echo "Generating ${esvg}"
    sed "s/000000/$(cut -d" " -f1 <<< ${col_val})/g;
         s/101010/$(cut -d" " -f2 <<< ${col_val})/g;
         s/202020/$(cut -d" " -f3 <<< ${col_val})/g;
         s/303030/$(cut -d" " -f4 <<< ${col_val})/g;
         s/404040/$(cut -d" " -f5 <<< ${col_val})/g;
         s/ffffff/$(cut -d" " -f6 <<< ${col_val})/g;
         s/aa0000/$(cut -d" " -f7 <<< ${col_val})/g;
         s/ff0000/$(cut -d" " -f8 <<< ${col_val})/g" ${name} > ${esvg}

    [ -z "${no_png}" ] && echo "Exporting ${epng}" && inkscape --export-filename=${epng} ${esvg} > /dev/null 2>&1
    echo ""

done; done; done
}

# Taking inputs
while [ "$#" -gt 0 ]; do
    case "${1}" in
        -i) shift 1
            for ico_in in "${@}"; do
                [[ ${ico_in} = -* ]] && break
                ico_sel+=("${ico_in}")
                shift 1
            done ;;
        -b) shift 1
            for bgr_in in "${@}"; do
                [[ ${bgr_in} = -* ]] && break
                bgr_sel+=("${bgr_in}")
                shift 1
            done ;;
        -c) shift 1
            for col_in in "${@}"; do
                [[ ${col_in} = -* ]] && break
                col_sel+=("${col_in}")
                shift 1
            done ;;
        -n) no_png=1
            shift 1;;
        -o) if [ -x "$(command -v optipng)" ]; then opti=1; else echo "optipng is not installed"; exit 1; fi
            shift 1;;
        -h) print_help ;;
    esac
done

# Create directories
mkdir -p SVG Matcha

# Check if inkscape is installed
[ -z "${no_png}" ] && [ ! -x $(command -v inkscape) ] && echo "Inkscape is not installed" && exit 1

# Exporting our wallpaper
export_color

echo "Wallpapers have been exported!"
if [ -n "${opti}" ]; then echo "Optimizing exported pngs. Please wait..."; optipng Matcha/* > /dev/null 2>&1; else echo "Will not optimize pngs"; fi

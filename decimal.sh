#!/bin/bash

#12:
#The 'decimalyo' function use 'awk' to convert degree, minute, second coordinates from input stream to decimal degrees, considering directional indicators. It splits input lines to arrays, determines the direction, and calculates the decimal value, providing a convenient conversion for geographic coordinates.
function decimalyo(){
    while read -r deg; do
        awk '
            {
                split($0, arr, /°|′|″/)
                dir = (arr[4] ~ /[NE]/) ? 1 : -1
                dec = dir * (arr[1] + arr[2]/60 + arr[3]/3600)
                printf("%f", dec)
            }
        ' <<< "$deg"
    done
}




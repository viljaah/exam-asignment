#!/bin/bash

#Converts degree type coordinates to decimal coordinates
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




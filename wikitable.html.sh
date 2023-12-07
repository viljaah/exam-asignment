#!/bin/bash

#
source "./decimal.sh"


#Downloads Wikipedia page and saves it to a temporary file.
#Uses curl to download the Wikipedia page on municipalities of Norway and saves it to table.temp.txt.
curl -s https://en.wikipedia.org/wiki/List_of_municipalities_of_Norway > table.temp.txt

#Clean up the downloaded file: remove new lines and tabs
#Uses 'tr' to remove new lines and tabs, creating a cleaner version in table.only.txt.
tr -d '\n\t' < table.temp.txt > table.only.txt

#Extract the target table from the cleaned file and save it to another file
#Utilizes 'sed' and 'grep' to isolate the relevant table content, then saves it to table.use.txt.
sed -E 's/.*<table class="sortable wikitable">(.*)<\/table>.*/\1/g' table.only.txt | sed 's/<\/table>/\n/g' | 
sed -n '1p' | 
grep -o '<tbody[ >].*<\/tbody>' | 
sed -E 's/<tbody[^>]*>(.*)<\/tbody>/\1/g' | 
sed -E 's/<tr[^>]*>//g' | sed 's/<\/tr>/\n/g' | 
sed -E 's/<td[^>]*>//g' | sed 's/<\/td>/\t/g' | sed '1d' > table.use.txt

#Creates an HTML template and inserts the table content from table.use.txt, generating a new HTML file named index.html.
template='
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    '"$(cat "table.use.txt")"'
</body>
</html>
'
echo "$template" > "index.html"



#Uses 'cut' to extract the second column (names) from table.use.txt and saves it to info.txt.
cut -f 2 table.use.txt > info.txt

#Applies 'awk' to extract URLs and names, creating link.txt.
awk 'match($0, /href="[^"]*"/){url=substr($0, RSTART+6, RLENGTH-7)} match($0, />[^<]*<\/a>/){printf("%s%s\t%s\n", "https://en.wikipedia.org", url, substr($0, RSTART+1, RLENGTH-5))} ' info.txt  > link.txt

#Uses a 'while' loop to fetch web pages, extracts latitude and longitude, converts them to decimals, and saves the results to coords.txt.
while read url place; do
	pageHtml="$(curl -s "$url")"
	lat=$(echo $pageHtml | grep -o '<span class="latitude">[^<]*' | head -n 1 | sed 's/<span class="latitude">//' | decimalyo)
	lon=$(echo $pageHtml | grep -o '<span class="longitude">[^<]*' | head -n 1 | sed 's/<span class="longitude">//' | decimalyo)
	printf "%s\t%s\t%s\t%s\n" $url $place $lat $lon >> coords.txt
done < link.txt

#Applies 'awk' to extract population information from the original table and saves it to population.txt.
awk -v RS='</tr>' -F '</td><td>|</td></tr>' '{
    gsub(/<[^>]*>/, "", $5);  # Remove HTML tags from the fifth column (Population)
    if (NF >= 4) {
        printf "%s\n", $5;
    }
}' table.only.txt > population.txt

#Merges the contents of coords.txt and population.txt side by side, saving the result to combined.txt.
paste coords.txt population.txt > combined.txt

#Utilizes 'awk' to create HTML content with the extracted links, names, coordinates, and populations, and saves it to all.combined.html.
awk -F'\t' '{printf "<p><a href=\"%s\">%s</a> is here: <span>%s&#9;%s.</span> Population: %s</p>\n", $1, $2, $3, $4, $5 }' "combined.txt" > "all.combined.html"

#Creates a new HTML template embedding the combined information and saves it to the final index.html.
template2='
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    '"$(cat "all.combined.html")"'
</body>
</html>
'
echo "$template2" > "index.html"



#Readme:
#The script downloads a Wikipedia page, extracts a specific table, and organizes the data into an HTML file.

#It extracts information about municipalities, including URLs, names, coordinates, and population.

#The coordinates are converted from degrees to decimals.

#The final HTML file combines all the extracted information for easy viewing.
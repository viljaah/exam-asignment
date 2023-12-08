#!/bin/bash

#how detailed comments do you want? In this document you will find basic comments.
#but if you want detailed comments: read README.md. comments are matched with numbers.


#importing essential funktions from the decimal.sh
source "./decimal.sh"


#1:
#this command fetches the content of the Wikipedia page
curl -s https://en.wikipedia.org/wiki/List_of_municipalities_of_Norway > table.temp.txt

#2:
#this reads the content from the table.temp.txt, removes newline and tab characters, and writes the modified content to a new file: table.only.txt.
tr -d '\n\t' < table.temp.txt > table.only.txt

#3:
#the entire command processes the content of table.only.txt, extracting and formatting a specific table, found in the HTML content. It separates the content into lines, rows, and cells, and saves it in table.use.txt.
sed -E 's/.*<table class="sortable wikitable">(.*)<\/table>.*/\1/g' table.only.txt | sed 's/<\/table>/\n/g' | 
sed -n '1p' | 
grep -o '<tbody[ >].*<\/tbody>' | 
sed -E 's/<tbody[^>]*>(.*)<\/tbody>/\1/g' | 
sed -E 's/<tr[^>]*>//g' | sed 's/<\/tr>/\n/g' | 
sed -E 's/<td[^>]*>//g' | sed 's/<\/td>/\t/g' | sed '1d' > table.use.txt

#4:
#this creates an HTML document by combining a template with the content of table.use.txt.
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



#5: 
#extracts the second column from the content in table.use.txt, using 'cut' and saves it to a new file: info.txt.
cut -f 2 table.use.txt > info.txt

#6:
#this awk command processes the content of info.txt, extracts URLs and link text from HTML anchor tags, and prints the formatted output with URLs. The result is saved in link.txt.
awk 'match($0, /href="[^"]*"/){url=substr($0, RSTART+6, RLENGTH-7)} match($0, />[^<]*<\/a>/){printf("%s%s\t%s\n", "https://en.wikipedia.org", url, substr($0, RSTART+1, RLENGTH-5))} ' info.txt  > link.txt

#7:
#reads lines from link.txt, fetches HTML content from each URL, extracts latitude and longitude, and appends the formatted output to a file: coords.txt.
while read url place; do
	pageHtml="$(curl -s "$url")"
	lat=$(echo $pageHtml | grep -o '<span class="latitude">[^<]*' | head -n 1 | sed 's/<span class="latitude">//' | decimalyo)
	lon=$(echo $pageHtml | grep -o '<span class="longitude">[^<]*' | head -n 1 | sed 's/<span class="longitude">//' | decimalyo)
	printf "%s\t%s\t%s\t%s\n" $url $place $lat $lon >> coords.txt
done < link.txt

#8:
#'awk' command processes the content of table.only.txt, treating each table row as a record. removes HTML tags from the Population column and prints the population values to a file: population.txt.
awk -v RS='</tr>' -F '</td><td>|</td></tr>' '{
    gsub(/<[^>]*>/, "", $5);
    if (NF >= 4) {
        printf "%s\n", $5;
    }
}' table.only.txt > population.txt

#9:
#paste: to merge/combine the content of coords.txt and population.txt into a single file: combined.txt.
paste coords.txt population.txt > combined.txt

#10:
#this 'awk' command reads the content from combined.txt, formats it into HTML code using the specified placeholders, and writes the formatted HTML to a file: all.combined.html.
awk -F'\t' '{printf "<p><a href=\"%s\">%s</a> is here: <span>%s&#9;%s.</span> Population: %s</p>\n", $1, $2, $3, $4, $5 }' "combined.txt" > "all.combined.html"

#11: 
#this does the same as the first template.
#creates an HTML document by combining a template with the content of all.combined.html. the resulting HTML is saved in: index.html, giving the ending result.
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



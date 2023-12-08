# exam-asignment

1:
#curl: for making HTTP request. 
#-s: for preventing curl from showing progress information or error messages. 
#> table.temp.txt: redirects the output from the curl command to a file. 
#the > is used for output redirection, and it creates or overwrites the file with the specified name. 
 

2:
#tr: command for deleting characters. 
#-d '\n\t': the -d  specifies the set of characters to be deleted. 
#'\n\t' represents newline and tab characters. 
#instructs 'tr' to delete all newline and tab characters from the input. 
#< table.temp.txt: input redirection. Reads the content of the file table.temp.txt. 
#the < symbol is used to specify the input source. 

 
3:
#sed to extract the content between the specified <table> tags with a given class. captures the content between the opening and closing <table> tags 
#using another sed command in a pipeline to replace closing </table> tags with newline characters. 
#grep to extract lines containing the opening and closing <tbody> tags along with their content. 
#the '-o' prints only the matched parts of the lines. 
#using sed again to capture the content between the opening and closing <tbody> tags and writes it to the standard output. 
#uses two sed commands to remove <tr> tags and replace closing </tr> tags with newline characters. this separates the content into lines, each representing a table row. 
#two sed commands again to remove <td> tags and replace closing </td> tags with tab characters. This separates the content into fields, each corresponding to a cell in the table. 
#using sed to delete the first line of the output and writes the result to table.use.txt. 
 

4: 
#the template includes the basic structure of an HTML document and embeds the content of table.use.txt. 
#the "cat" reads the content of the file and returns it as a string. 
#echo writes the concatenated template to a new HTML file: index.html.  


6: 
#the 'match' in awk to search for the pattern: 'href="[^"]*"'.  
#'RSTART' is the start position of the match, and 'RLENGTH' is the length of the match. 
#'substr' extracts the substring starting from the 6th position after the match and ending 7 characters before the end.
#the print part prints the formatted output. It concatenates the wikipage with the extracted 'url' and the text in the anchor tags. The result is printed with a tab (\t) as a delimiter.


7: 
#initiates a while loop that reads each line from link.txt, splitting it into 'url' and 'place' variables.
#The loop continues until all lines in the file have been processed.  
#curl to fetch the HTML content.
#lat and lon=$(echo $pageHtml: #Extracts the latitude and longitude from the HTML content. 
#echo to pass the HTML content to grep, that extracts the latitude using a regular expression. 
#head -n 1 selects the first occurrence, and sed removes the HTML tags. 
#prints the formatted output to the console, including the URL, place, latitude, and longitude. appends the result to a file: coords.txt. 
#the '%s' are replaced with the corresponding values of 'url', 'place', 'lat', and 'lon'. 


8: 
#sets the record separator (RS) to '</tr>', indicating that each line in the input corresponds to a table row. 
#'</td><td>|</td></tr>', indicates that fields within each record are separated by this pattern.  
#using gsub to remove HTML tags within the fifth column of each record.    
#Prints the fifth field (population) without HTML tags. The '\n' adds a newline after each output. 


10:
#'printf' function in 'awk' to format and print the HTML code for each line. 
#the '%s' are replaced by the values of fields $1, $2, $3, $4, and $5. 
#the HTML code includes a link, location, latitude, longitude, and population information.  

 
12:
#initiates a loop that reads lines from the input stream. 
#awk ' ... ': to perform the conversion of degree, minute, second format to decimal degrees. 
#'split' to break the input line into an 'arr', based on degree (°), minute (′), and second (″) symbols. 
#dec = dir…: calculates the decimal value by converting degrees, minutes, and seconds to decimal degrees. 
#' <<< "$deg": supplies the value stored in 'deg' as input to the 'awk' command. 
#done: close the loop.


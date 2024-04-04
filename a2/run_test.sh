tar czvf assignment2_easy_2020EE10583_2020EE10589.tar.gz -C xv6 .
mkdir check_scripts
tar xzvf check_scripts.tar.gz -C check_scripts
cp assignment2_easy_2020EE10583_2020EE10589.tar.gz check_scripts
cd check_scripts
bash check.sh assignment2_easy_2020EE10583_2020EE10589.tar.gz
 

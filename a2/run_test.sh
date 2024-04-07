tar czvf assignment2_easy_2020EE10583_2020EE10589.tar.gz -C xv6 . > /dev/null 2>&1
mkdir check_scripts
tar xzvf check_scripts.tar.gz -C check_scripts > /dev/null 2>&1
cp assignment2_easy_2020EE10583_2020EE10589.tar.gz check_scripts > /dev/null 2>&1
cd check_scripts
bash check.sh assignment2_easy_2020EE10583_2020EE10589.tar.gz

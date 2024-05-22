#Create a tarball of the final submission
tar czvf assignment3_easy_2020EE10583_2020EE10589.tar.gz -C xv6 .
unzip -o check_script_a3.zip
cp assignment3_easy_2020EE10583_2020EE10589.tar.gz check_script_a3
cd check_script_a3
bash check.sh assignment3_easy_2020EE10583_2020EE10589.tar.gz




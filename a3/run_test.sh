#!/bin/bash

# Number of times to run the test
N=1000
# Counter for passed tests
passed_count=0

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

#Create a tarball of the final submission
tar czvf assignment3_easy_2020EE10583_2020EE10589.tar.gz -C xv6 . > /dev/null 2>&1

# Unzip the check script and copy the assignment tar.gz into the check script directory
unzip -o check_script_a3.zip  >/dev/null 2>&1
cp assignment3_easy_2020EE10583_2020EE10589.tar.gz check_script_a3 >/dev/null 2>&1
cd check_script_a3
echo "RUNNING $N TESTS...."
# Run the test N times
for (( i=1; i<=N; i++ ))
do
    bash check.sh assignment3_easy_2020EE10583_2020EE10589.tar.gz > temp_output.txt 2>&1

    
    # Check for pass condition
    if grep -q "PASS" temp_output.txt; then
        echo -e "Test Iteration $i: ${GREEN}PASS${NC}"
        ((passed_count++))
    else
        echo -e "Test Iteration $i: ${RED}FAIL${NC}"
    fi
done
rm temp_output.txt
echo -e "\e[36m TEST CASES PASSED : $passed_count / $N\e[0m"



which bw > /dev/null 2>&1
if [ $? -eq 0 ]; then
    alias testing-farm-redhat="TESTING_FARM_API_TOKEN=$(bw get password token-testing-farm-red-hat-ranch) testing-farm"
    alias testing-farm-public="TESTING_FARM_API_TOKEN=$(bw get password token-testing-farm-public-ranch) testing-farm"
fi

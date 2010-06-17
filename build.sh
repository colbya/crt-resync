#!/bin/sh

ruby rubyscript2exe.rb metadata.rb example_config.yaml
ruby rubyscript2exe.rb rets_data_fetch.rb example_config.yaml > temp.csv
ruby rubyscript2exe.rb object_fetch.rb example_config.yaml temp.csv

mv metadata_* metadata
mv rets_data_fetch_* rets_data_fetch
mv object_fetch_* object_fetch

rm *.log
rm *.csv
rm *.zip
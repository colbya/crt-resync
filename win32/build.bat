copy ..\progressbar.rb
copy ..\rets_helper.rb
copy ..\metadata.rb
copy ..\rets_data_fetch.rb
copy ..\example_config.yaml
RubyScript2Exe metadata.rb example_config.yaml > temp_metadata.txt
RubyScript2Exe rets_data_fetch.rb example_config.yaml > temp_data.txt
move *.exe build
del progressbar.rb
del rets_helper.rb
del metadata.rb
del rets_data_fetch.rb
del example_config.yaml

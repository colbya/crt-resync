# Copyright (C) 2009 National Association of REALTORS(R)
#
# All rights reserved.
#
# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation
# files (the "Software"), to deal in the Software without
# restriction, including without limitation the rights to use, copy,
# modify, merge, publish, distribute, and/or sell copies of the
# Software, and to permit persons to whom the Software is furnished
# to do so, provided that the above copyright notice(s) and this
# permission notice appear in all copies of the Software and that
# both the above copyright notice(s) and this permission notice
# appear in supporting documentation.

require 'csv'
require 'date'
require 'yaml'
require 'rets_helper'
require 'progressbar'

include RetsHelper

def parse_options(args)
  if args.length < 1
    return nil
  elsif args.member?("--version")
    return {:version => true}
  else 
    #Get the config file   
    config = {:config_file => args.shift}    
    
    #Parse the added -D parameters
    args.each do |arg| 
      if param = arg.match('(.+)=(.+)')
        config[param.captures[0]] = param.captures[1]
      else
        return nil
      end
    end
    return config  
  end
end

def run_fetch(options)

  #Get the config file.
  unless FileTest.exists?(options[:config_file])
    abort("Config File '#{options[:config_file]}' not found.")
  end
  config = YAML.load_file(options[:config_file])

  dmql = config[:dmql]
  options.each {|name, value| dmql = dmql.gsub("<<#{name}>>", value)}

  execute_rets_action(config[:rets_info]) do |session|    
    request = session.create_search_request(config[:resource], config[:class], dmql)
    request.standard_names = false
    limit = -1
    if(config[:limit]) 
      limit = request.limit = config[:limit]    
    end

    mappings = {}
    if(config[:select]) 
      selects = []
      config[:select].each do |field|
        if(field.class==Hash)
          field.each do |field_name, mapping|
            mappings[field_name] = mapping
            selects.push(field_name)
          end
        else
          selects.push(field)
        end
      end
      request.set_select selects.join(",")
    end
    response = session.search(request)

    requested = (limit > -1 and limit < response.count) ? limit : response.count

    #Count the actual rows returned
    count = 0

    #Create a progress bar for sanity on large downloads  
    STDERR.puts "Fetching #{requested} of #{response.count} items"
    pbar = ProgressBar.new("Progress", requested)

    #Write the results out to STDOUT
    columns = response.columns
    mapped_columns = columns.collect{|column| mappings.fetch(column, column)}
    
    #The delimiter for 
    delim = config[:delimiter] ? config[:delimiter] : ","

    CSV::Writer.generate(STDOUT, delim) do |csv|
      csv << mapped_columns
      while(count < requested)
        response.each do |result|    
          csv << columns.collect {|column| result.string(column)}
          pbar.inc
          count = count + 1
        end        
        if(count < requested)
          request.offset=count
          response = session.search(request)
        end
      end
    end
    STDERR.puts ""
    STDERR.puts "Done!"
  end
end

#The script itself
unless options = parse_options(ARGV)
  abort("usage:  rets_data_fetch --version\n" + 
        "        rets_data_fetch config_file [name1=value1 name2=value2 ...]")  
end

version = get_version
libVersion = get_lib_version
STDERR.puts get_product_information("RETS Data Fetcher")

unless options[:version]
  run_fetch(options)
end
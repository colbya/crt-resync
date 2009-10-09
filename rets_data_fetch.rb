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

config = YAML.load_file(ARGV[0])

def insert_dates_into_dmql(dmql, dates)
  if(dates.length > 1)
    sart_month = Date.parse(dates[0])
    first_of_start_month = Date.new(sart_month.year, sart_month.month, 1)
    end_month = Date.parse(dates[1])
    end_month = Date.new(end_month.year, end_month.month,1)
    last_of_end_month = (end_month>>1)-1
    dmql.gsub("<<start>>", first_of_start_month.to_s).gsub("<<end>>", last_of_end_month.to_s)
  else
    date = ARGV.length > 1 ? Date.parse(dates[0]) : Date.today<<1
    first_of_month = Date.new(date.year, date.month, 1)
    last_of_month = (first_of_month>>1)-1
    dmql.gsub("<<start>>", first_of_month.to_s).gsub("<<end>>", last_of_month.to_s)
  end
end

dmql = insert_dates_into_dmql(config[:dmql], ARGV[1..2])

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
  version = get_version
  libVersion = get_lib_version
  STDERR.puts"SimpleRETS RETS Data Fetcher Version #{version} running on libRETS version #{libVersion}"
  STDERR.puts "Fetching #{requested} of #{response.count} items"
  pbar = ProgressBar.new("Progress", requested)
  
  #Write the results out to STDOUT
  columns = response.columns
  mapped_columns = columns.collect{|column| mappings.fetch(column, column)}

  CSV::Writer.generate(STDOUT) do |csv|
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

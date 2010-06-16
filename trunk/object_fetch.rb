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

require 'yaml'
require 'csv'
require 'rets_helper'
require 'zip/zipfilesystem'
require 'rets_helper'
require 'progressbar'

include RetsHelper

config = YAML.load_file(ARGV[0])

content_type_extension = {"application/pdf" => "pdf", "image/bmp" => "bmp", "image/cis" => "cod", "image/gif" => "gif", "image/ief" => "ief", 
"image/jpeg" => "jpg", "image/png" => "png", "text/html" => "html", "text/iuls" => "uls", "text/plain" => "txt", "text/richtext" => "rtf", 
"text/x-vcard" => "vcf", "video/mpeg" => "mp2", "video/mpeg" => "mpa", "video/mpeg" => "mpe", "video/mpeg" => "mpeg", "video/mpeg" => "mpg", 
"video/mpeg" => "mpv2", "video/quicktime" => "mov", "video/quicktime" => "qt", "video/x-la-asf" => "lsf", "video/x-la-asf" => "lsx", 
"video/x-ms-asf" => "asf", "video/x-ms-asf" => "asr", "video/x-ms-asf" => "asx", "video/x-msvideo" => "avi", "video/x-sgi-movie" => "movie"}

STDERR.puts get_product_information("RETS Object Fetcher")

#Get the ids 
data_file = CSV.open(ARGV[1], 'r') 
headers = data_file.shift
id_index = headers.index(config[:item_id])
ids = data_file.collect{|row| row.at(id_index)}

execute_rets_action(config[:rets_info]) do |session|    
  config[:object_types].each do |object_type|        
    STDERR.puts "Zipping #{object_type} to #{object_type}.zip"
    Zip::ZipFile.open("#{object_type}.zip", Zip::ZipFile::CREATE) do |zipfile|    
      pbar = ProgressBar.new("Progress", ids.length)
      ids.each do |id|
        get_object_request = GetObjectRequest.new(config[:resource], object_type)
        get_object_request.add_all_objects(id)
        get_object_response = session.get_object(get_object_request)
        get_object_response.each_object do |object_descriptor|
          object_key =  object_descriptor.object_key
          object_id = object_descriptor.object_id
          content_type = object_descriptor.content_type
          description = object_descriptor.description
          extension = content_type_extension[content_type]
          if(extension != nil) then
            extension = "." + extension
            output_file_name = object_id.to_s + extension
            zipfile.file.open(object_key + "/" + output_file_name, "w") do |f|
              f << object_descriptor.data_as_string
            end
          end
        end
        pbar.inc      
      end  	
      STDERR.puts
    end
    STDERR.puts "Done zipping #{object_type}.zip"
  end
end
STDERR.puts "DONE!"









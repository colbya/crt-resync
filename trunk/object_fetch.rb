require 'yaml'
require 'rets_helper'
require 'zip/zipfilesystem'
require 'rets_helper'

include RetsHelper

config = YAML.load_file(ARGV[0])

execute_rets_action(config[:rets_info]) do |session|    
  get_object_request = GetObjectRequest.new("Property", "Photo")
  get_object_request.add_all_objects("1")
  get_object_response = session.get_object(get_object_request)
  get_object_response.each_object do |object_descriptor|
  	object_key =  object_descriptor.object_key
  	object_id = object_descriptor.object_id
  	content_type = object_descriptor.content_type
  	description = object_descriptor.description
  	print "#{object_key} object \##{object_id}"
  	print ", description: #{description}" if !description.empty?
  	puts
  	  
  	Zip::ZipFile.open("test.zip", Zip::ZipFile::CREATE) do |zipfile|    
      output_file_name = object_id.to_s + ".jpg"
      zipfile.file.open(object_key + "/" + output_file_name, "w") do |f|
        f << object_descriptor.data_as_string
      end
    end  	
  end
end









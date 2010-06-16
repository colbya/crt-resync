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
require 'rets_helper'

include RetsHelper

def RetsHelper::get_product_name
  "MetadataBrowser"
end

def dump_system(metadata)
  system = metadata.system
  puts "System ID: " + system.system_id
  puts "Description: " + system.system_description
  puts "Comment: " + system.comments
end

# standard_name

def dump_all_resources(metadata)
  puts "Resources: "
  metadata.GetAllResources.each do |resource|
    standard_name = resource.standard_name
    visible_name = resource.GetStringAttribute("VisibleName", standard_name)
    puts " - #{resource.resource_id} (#{standard_name}, #{visible_name})"
  end
end

def dump_all_classes(metadata, resource)
  resource_name = resource.resource_id;
  puts "Classes for #{resource_name}:"  
  metadata.GetAllClasses(resource_name).each() do |aClass|
    visible_name = aClass.GetStringAttribute("VisibleName", "")
    puts " - #{aClass.class_name} (#{aClass.standard_name}, #{visible_name})"
  end
end

def dump_all_tables(metadata, resource, aClass)
  puts "Tables for #{resource.resource_id}-#{aClass.class_name}:"
  metadata.all_tables(aClass).each do |table|
    short_name = table.GetStringAttribute("ShortName", "")
    long_name = table.GetStringAttribute("LongName", "")
    required =  table.GetStringAttribute("Required", "")
    data_type = get_display_type_string(table.get_data_type)
    puts "- #{table.system_name} (#{table.standard_name}, #{short_name} (#{long_name})) Type: #{data_type} - Required: #{required}"
  end
end

def dump_all_lookups(metadata, resource)
  resource_name = resource.resource_id();
  lookups = metadata.all_lookups(resource_name).collect(){|lookup| "#{lookup.lookup_name}(#{lookup.visible_name})"}
  lookups = lookups.join("\n - ")
  puts "Lookups for #{resource_name}: \n - #{lookups}"
end

def dump_all_lookup_types(metadata, resource, lookup)
  puts "Lookup Types for #{resource.resource_id}-#{lookup.lookup_name}(#{lookup.visible_name}):"
  puts
  metadata.all_lookup_types(lookup).each do |lookup_type|
    puts "Lookup value: " + lookup_type.value + " (" +
      lookup_type.short_value + ", " +
      lookup_type.long_value + ")"
  end
end


config = YAML.load_file(ARGV[0])
execute_metadata_action(config[:rets_info]) do |metadata|
  puts
  puts get_product_information("RETS Metadata Browser")
  puts
  dump_system(metadata)
  puts
  if(ARGV.length > 2)
    resource = metadata.GetResource(ARGV[1])
    if(ARGV[2].upcase == "LOOKUPS")
      if(ARGV.length == 4)
        dump_all_lookup_types(metadata, resource, metadata.GetLookup(resource.resource_id, ARGV[3]))
      else
        dump_all_lookups(metadata, resource)      
      end
    else
      dump_all_tables(metadata, resource, metadata.getClass(resource.resource_id, ARGV[2]))
    end
  elsif(ARGV.length == 2)
    dump_all_classes(metadata, metadata.GetResource(ARGV[1]))
  else
    dump_all_resources(metadata)
  end
  puts
  
end
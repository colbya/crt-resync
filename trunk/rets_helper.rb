require 'rubygems'
require 'librets'

include Librets

module RetsHelper 
  
  def get_version
    return "1.0.1"
  end
  
  def get_lib_version
    return RetsSession.GetLibraryVersion()
  end
  
  def execute_rets_action(rets_info)
    session = RetsSession.new(rets_info[:url])
    if(rets_info.has_key?(:user_agent))
      session.user_agent = rets_info[:user_agent]
      if(rets_info.has_key?(:user_agent_password))
        session.user_agent_password = rets_info[:user_agent_password]
      end      
    end
    
    if(rets_info.has_key?(:rets_version))
      session.rets_version = create_rets_version(rets_info[:rets_version])
    end
    
    if(rets_info.has_key?(:log_file))
      session.http_log_name = rets_info[:log_file]
    end
    if(session.login(rets_info[:username], rets_info[:password]))
      begin
        yield(session)
      ensure
        session.logout
      end
    else
      raise RetsLoginError.new("Error logging into RETS Server", rets_info[:url])
    end
  end
  
  def execute_metadata_action(rets_info)
    execute_rets_action(rets_info) do |session|
      yield(session.metadata)
    end
  end
  
  def create_rets_version(version) 
    if version.to_s == "1.7.2" then
      return Librets::RETS_1_7_2 
    elsif version.to_s == "1.7" then
      return Librets::RETS_1_7 
    elsif version.to_s == "1.5" then
      return Librets::RETS_1_5
    else
      raise "Unknown RETS version #{version}"
    end
  end
  
  class RetsLoginError < Exception
    attr_reader :session_context
    
    def initialize(message, session_context)
      super(message)
      @session_context = session_context
    end
  end
end
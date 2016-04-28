# main.rb

require 'json'  
require 'sinatra'  
require 'data_mapper'  
require 'dm-migrations'

DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, "sqlite3::memory:?cache=shared")


require './models/init'  
require './api/init'

DataMapper.finalize

DataMapper.auto_upgrade!

require_relative 'app'
require_relative 'models/instance'
require_relative 'models/puppet_class'

env = ENV['RACK_ENV']
config = YAML.load_file('config/database.yml')[env]

DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, config)
DataMapper.finalize

run App
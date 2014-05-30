class Instance
  include DataMapper::Resource
  
  property :id, Serial
  property :name, String
  property :alias, String
  property :created_at, DateTime
 end
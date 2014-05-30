require 'sinatra'
require 'rubygems'
require 'yaml'
require 'pry'
require 'data_mapper'
require 'json'

class App < Sinatra::Base
 
  def format_response obj, status=200
    status 200
    content_type :json
    obj.to_json
  end
 
  not_found do
    redirect '/', 302
  end
  
  get '/' do
    'Inventory API'
  end

  get '/api/instances' do
    instances = Instance.all
    format_response instances
  end
  
  # get instance data
  get '/api/instance/:instance' do
    Instance.first(name: params[:instance]).to_json
  end
  
  # add a new instance
  post '/api/instance/:instance/alias/:alias' do
    begin
      instance = Instance.create!(name: params[:instance], alias: params[:alias])
      format_response {message: "instance created", instance: instance}, 201
    rescue DataObjects::IntegrityError
      format_response {message: "instance already existed", instance: Instance.first(name: params[:instance])}, 202
    end
 end

  # remove instance from inventory
  delete '/api/instance/:instance' do
    instance ||= Instance.first(params[:instance]) || halt(404)
    halt 500 unless instance.destroy
  end

  # add a new class
  post '/api/class/:class' do
    begin
      puppet_class = Puppet_Class.create!(name: params[:class])
      format_response {message: "class created", class: puppet_class}, 201
    rescue DataObjects::IntegrityError
      format_response  {message: "class already existed", puppet_class: Puppet_Class.first(name: params[:class])}, 202
    end
  end
  
  # associate instance with class
  post '/api/instance/:instance/class/:class' do
    instance = Instance.first(name: params[:instance])
    puppet_class = Puppet_Class.first_or_create(name: params[:class])
    instance_puppet_class = Instance_Puppet_Class.update!(instance_id: instance.id, puppet_class_id: puppet_class.id) 
    format_response {message: "associate #{params[:instance]} instance with #{params[:class]} class"}
  end
  
  # TODO: get puppet classes for instance
  get '/api/instance/class/:instance' do
    instance = Instance.first(name: params[:instance])
    Instance_Puppet_Class.all(instance_id: instance.id)
    
  end
  
  
  # TODO: need to add the data mapper
  post '/api/instance/:instance/class/:class/key/:key/value/:value' do

  end
   
   
end


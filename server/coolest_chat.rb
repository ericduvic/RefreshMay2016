require 'sinatra'
require 'oj'

message_queue = [{
    'type' => 'message',
    'id' => 1,
    'attributes' => {
      'timestamp' => '20160512 12:30:00',
      'author' => 'Eric Duvic',
      'message' => 'Hello refreshers!'
  }}]

get '/' do
  "Hello world!"
end

get '/messages' do
  content_type "application/vnd.api+json"
  body Oj.dump({
    'data' => message_queue
    })
end

post '/messages' do
  data = Oj.load(request.body)['data']
  new_id = message_queue.length + 1
  data['id'] = new_id
  message_queue << data

  content_type "application/vnd.api+json"
  status 201
  headers "Location" => "#{request.base_url}/messages/#{new_id}"
  body Oj.dump({
    'data' => data
    })
end

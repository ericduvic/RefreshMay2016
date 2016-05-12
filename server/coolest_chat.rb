require 'sinatra'
require 'oj'
require 'pg'

connection = PG.connect(
  host: 'localhost',
  dbname: 'eric',
  user: 'eric',
  password: ''
)

get '/' do
  "Hello world!"
end

get '/messages' do
  message_queue = []
  connection.exec("SELECT * FROM messages") do |result|
    result.each do |row|
      message_queue << {
        'type' => 'message',
        'id' => row['id'],
        'attributes' => {
          'system_create_time' => row['system_create_time'],
          'author' => row['author'],
          'message' => row['message']
        }
      }
    end
  end

  content_type "application/vnd.api+json"
  body Oj.dump({
    'data' => message_queue
    })
end

post '/messages' do
  data = nil
  attributes = Oj.load(request.body)['data']['attributes']
  connection.exec_params("INSERT INTO messages (author, message) VALUES ($1, $2) RETURNING *", [attributes['author'], attributes['message']]) do |result|
    result.each do |row|
      data = {
        'type' => 'message',
        'id' => row['id'],
        'attributes' => {
          'system_create_time' => row['system_create_time'],
          'author' => row['author'],
          'message' => row['message']
        }
      }
    end
  end

  content_type "application/vnd.api+json"
  status 201
  headers "Location" => "#{request.base_url}/messages/#{data['id']}"
  body Oj.dump({
    'data' => data
    })
end

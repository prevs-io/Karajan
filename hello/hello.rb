SECRET_KEY  = 'this is the very secret key!'
REDIS = Redis.new(host: '127.0.0.1', port: '6379')

class Hello < Sinatra::Base
  
  set :public => "public", :static => true

  get "/" do
    @version     = RUBY_VERSION
    @environment = ENV['RACK_ENV']

    erb :welcome
  end

  get "/api/contents"  do
    content_type :json
    { :contents => [
      {:item1 => 'description1'},
      {:item2 => 'description2'},
      {:item3 => 'description3'},
    ]}.to_json
  end

  get "/api/badges"  do
    content_type :json
    { :badges => [
      {:badge1 => 'badge1'},
      {:badge2 => 'badge2'},
      {:badge3 => 'badge3'},
      {:badge4 => 'badge4'},
      {:badge5 => 'badge5'},
      {:badge6 => 'badge6'},
    ]}.to_json
  end

end

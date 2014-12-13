class Takt < Sinatra::Base

  enable :logging
  set :public_folder => "public", :static => true

  get "/" do
    erb :welcome
  end

  post "/write_score" do
    content_type :json
    score = request.body.read
    logger.info score
    REDIS.set('score', score)
    {status: 'success', body: JSON.parse(score)}.to_json
  end
end

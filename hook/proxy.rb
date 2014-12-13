@host  = "0.0.0.0"
@port  = 6379
@redis = Redis.new(@host, @port)

def load_score 
 score = JSON.parse(@redis.get('score'))
 ret = {}
 score.each{|k, v| ret[k] = JWT.base64url_decode(v)}
 return ret
end

r = Nginx::Request.new

score = load_score[r.uri.sub(/^\/orchestrate/,'')]

orchestrate = lambda{eval(score)}

r.content_type = "application/json"

Nginx.rputs orchestrate.call

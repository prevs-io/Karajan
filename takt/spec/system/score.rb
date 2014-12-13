api_endp_1 ||= WebAPI.new "http://0.0.0.0:8080"
api_endp_2 ||= WebAPI.new "http://0.0.0.0:8080"

contents = JSON.parse(api_endp_1.get('/api/contents').body)
badges = JSON.parse(api_endp_2.get('/api/badges').body)

JSON.generate(contents.merge(badges))

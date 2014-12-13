Karajan
========

A Proxy Service As Orchestration Layer

Overview
---------

![overview]

The concept of this service is heavily inspired by [the netflix's architecture][netflix]. Karajan provides orchestration layer through programmable API proxy with using nginx/[ngx_mruby].
In this archietcture, orchestration logics are stored in Redis, then we can change the logics dynamically through management application `Takt`, without rebooting proxy services.

This product is also inspired by [darzana].

Demo
----------

If you'd like to know simple usage, you can try the sample demo  in this project easily with running the Docker container we prepared.

    git clone https://github.com/prevs-io/Karajan.git && cd Karajan
    docker build -t karajan .
    docker run -it --rm -p 49080:80 -p 49081:8080 -p 49082:3000 --name karajan karajan /data/scripts/start.sh

In this demo, it demonstrates use case following:

  - A client app requests data from two REST apis `http://0.0.0.0:8080/api/contents` and `http://0.0.0.0:8080/api/badge`, to rendering a showcase screen.
  - But for saving traffic and improve speed, the client app request data from two apis at once, then we start to try bundle two apis into only one api with using Karajan.

At first, insert orchestration logic into store through management service `Takt`. The orchestration logic is written in mruby, like below.

    api_endp_1 ||= WebAPI.new "http://0.0.0.0:8080"
    api_endp_2 ||= WebAPI.new "http://0.0.0.0:8080"

    contents = JSON.parse(api_endp_1.get('/api/contents').body)
    badges = JSON.parse(api_endp_2.get('/api/badges').body)

    JSON.generate(contents.merge(badges))

The logic is in `./takt/spec/system/score.rb`, and next write the logic to `Takt` on `http://0.0.0.0:3000/write_score` with `POST`. Of cource, these procedure is also prepared in `./takt/spec/write_score.rb`:

    #!/usr/bin/env ruby
    require 'httparty'
    require 'json'
    require 'base64'

    path = File.dirname(__FILE__)
    score=File.open(File.join(path, 'score.rb')).readlines.join('')
    url = 'http://0.0.0.0:49082/write_score'
    #{<context_path> => <client logic base64 encoded>}
    body = {'/' =>  Base64.encode64(score)}.to_json
    # write logic
    puts HTTParty.post(url, :body=>body)

After writing the logic, check it works with `curl`.
Note that orchestrated api endpoint is `http://0.0.0.0:80/orchestrate/`.

    ➜  karajan git:(master) ✗ curl  http://0.0.0.0:49080/api/badges
    {"badges":[{"badge1":"badge1"},{"badge2":"badge2"},{"badge3":"badge3"},{"badge4":"badge4"},{"badge5":"badge5"},{"badge6":"badge6"}]}

    ➜  karajan git:(master) ✗ curl  http://0.0.0.0:49080/api/contents
    {"contents":[{"item1":"description1"},{"item2":"description2"},{"item3":"description3"}]}

    ➜  karajan git:(master) ✗ curl  http://0.0.0.0:49080/orchestrate/
    {"contents":[{"item1":"description1"},{"item2":"description2"},{"item3":"description3"}],"badges":[{"badge1":"badge1"},{"badge2":"badge2"},{"badge3":"badge3"},{"badge4":"badge4"},{"badge5":"badge5"},{"badge6":"badge6"}]}

Finally, you can bind the two apis into one api!

## Contributing

Once you've made your great commits:

1. [Fork][fk]
2. Create your feature branch (``git checkout -b my-new-feature``)
3. Write tests
4. Run tests with ``rake test``
5. Commit your changes (``git commit -am 'Added some feature'``)
6. Push to the branch (``git push origin my-new-feature``)
7. Create new pull request
8. That's it!

Or, you can create an [Issue][is].

## License

### Copyright

* Copyright (c) 2014- Naoki AINOYA
* License
  * Apache License, Version 2.0

[is]: https://github.com/prevs-io/karajan/issues
[darzana]: https://github.com/kawasima/darzana
[ngx_mruby]: https://github.com/matsumoto-r/ngx_mruby/
[overview]: https://dl.dropboxusercontent.com/u/10177896/karajan-overview.png
[netflix]: http://techblog.netflix.com/2012/07/embracing-differences-inside-netflix.html
[fk]: http://help.github.com/forking/

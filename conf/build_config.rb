MRuby::Build.new do |conf|
  toolchain :gcc
  conf.gembox 'default'
  conf.gem :core => 'mruby-eval'
  conf.gem :core => 'mruby-sprintf'
  conf.gem :core => 'mruby-string-ext'
  conf.gem :core => 'mruby-enum-ext'
  conf.gem :core => 'mruby-enumerator'
  conf.gem :github => 'iij/mruby-io'
  conf.gem :github => 'iij/mruby-pack'
  conf.gem :github => 'iij/mruby-digest'
  conf.gem :github => 'iij/mruby-iijson'
  conf.gem :github => 'iij/mruby-socket'
  conf.gem :github => 'iij/mruby-webapi'
  conf.gem :github => 'iij/mruby-tls-openssl'
  conf.gem :github => 'mattn/mruby-onig-regexp'
  #conf.gem :github => 'mattn/mruby-v8'
  conf.gem :github => 'matsumoto-r/mruby-sleep'
  conf.gem :github => 'matsumoto-r/mruby-redis'
  conf.gem :github => 'matsumoto-r/mruby-mod-mruby-ext'
  conf.gem :github => 'ainoya/mruby-jwt'

  conf.cc do |cc|
    if ENV['BUILD_TYPE'] == "debug"
      cc.flags << '-fPIC -g3 -Wall -Werror-implicit-function-declaration'
    else
      cc.flags << '-fPIC'
    end
    if ENV['BUILD_BIT'] == "64"
      cc.flags << ' -DMRB_INT64'
    end
  end
  conf.linker do |linker|
    if ENV['BUILD_BIT'] == "64"
      linker.flags = '-DMRB_INT64'
    end
  end
end

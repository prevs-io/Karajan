#!/usr/bin/env ruby
require 'httparty'
require 'json'
require 'base64'

path = File.dirname(__FILE__)

score=File.open(File.join(path, 'score.rb')).readlines.join('')

url = 'http://0.0.0.0:49082/write_score'

body = {'/' =>  Base64.encode64(score)}.to_json

puts body

puts HTTParty.post(url, :body=>body)

puts HTTParty.get('http://0.0.0.0:49080/orchestrate/')

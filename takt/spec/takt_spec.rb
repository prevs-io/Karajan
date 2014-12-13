require_relative "spec_helper"
require_relative "../takt.rb"

def app
  Takt
end

describe Takt do
  it "responds with a welcome message" do
    get '/'

    last_response.body.must_include 'Welcome to the Sinatra Template!'
  end
end

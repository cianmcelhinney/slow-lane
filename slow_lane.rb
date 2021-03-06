require "sinatra"
require "logger"
require "json"

set :server, :thin

before do
  headers "Server" => " "
end

get "/" do
  send_file "index.html"
end

get "/stream*" do
  puts "params: #{params.to_json}"

  content = params[:ct] || params[:content_type] || "text/plain"
  content_type content

  cycles = params[:c] || params[:count] || 10
  cycles = cycles.to_i
  delay = params[:d] || params[:delay] || 0.4
  delay = delay.to_f

  stream do |out|
    cycles.times do
      text = params[:t] || params[:text] || SecureRandom.hex(32)
      out << "#{text}\n"
      sleep delay if delay > 0
    end
  end
end

require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

get "/" do
  # File.read "public/template.html"
  @files = Dir.glob("public/*").map {|file| File.basename(file) }.sort
  @files.reverse! if params[:sort] == "desc"
  erb :home

  # @title = "The Adventures of Sherlock Holmes"
  # @contents = File.read("data/toc.txt")
  # @contents = File.readlines("data/toc.txt")
  # erb :home
  # erb :test
end




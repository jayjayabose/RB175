require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

before do
  @contents = File.readlines("data/toc.txt")
end

get "/" do
  @title = "The Adventures of Sherlock Holmes"
  erb :home
end

get "/show/:name" do
  params["name"]
end

get "/search" do
  @results = chapters_matching(params[:query])
  erb :search
end

get "/chapters/:number" do
  number = params["number"]
  chapter_name = @contents[number.to_i - 1]
  
  redirect "/" unless (1..@contents.size).cover? number.to_i
  
  @title = "Chapter #{number}: #{chapter_name}"
  @chapter = File.read("data/chp#{number}.txt")
  
  erb :chapter
end

not_found do
  redirect "/"
end

helpers do
  def in_paragraphs(text)
    text.split("\n\n").map.with_index do |paragraph, index|
      "<P id=paragraph#{index}>#{paragraph}</P>"
    end.join
  end

  def query_highlighted(text, query)
    text.gsub(/#{query}/, "<strong>#{query}</strong>")
  end
end


def each_chapter
  @contents.each_with_index do |name, index|
    number = index +1
    contents = File.read("data/chp#{number}.txt")
    yield number, name, contents
  end
end

def chapters_matching(query)
  results = []

  return results if !query || query.empty?

  each_chapter do |number, name, contents|
    results << {number: number, name: name, contents: contents} if contents.include?(query)
  end

  results
end

def paragraphs_matching(contents, query)
  paragraphs = contents.split("\n\n")
  results = []
  paragraphs.each_with_index do |paragraph, index|
    results << [paragraph, index] if paragraph.include? query
  end
  results
end

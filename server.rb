require 'sinatra'

require 'csv'

require 'sinatra/reloader'

require 'pry'


def pull_articles(filename)
  articles = []

  CSV.foreach(filename, headers: true) do |row|
    articles << row
  end

  articles
end


############################################
#####                                 #####
#####                                 #####
############################################
get '/' do
  @articles = pull_articles("articles.csv")
  erb :index

end

get '/submit' do

  erb :submit
end

post '/submit' do
  name = params["article_name"]
  url = params["article_url"]
  description = params["article_description"]

  File.open('articles.csv','a') do |f|
    f.puts "#{name},#{url},#{description}"
  end

  redirect '/'
end












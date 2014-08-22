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


def url_exists_in_file?(url)
  articles = pull_articles("articles.csv")

  articles.each do |article|
    if article["url"] == url
      return true
    end
  end

  false
end



def validation_results(name, url, description)
  error_messages = []
  description_test = description.gsub(" ", "")

  if name.length == 0
    error_messages << "The name field was left blank.  Please fill in the article name."
  end

  if url.length == 0
    error_messages << "The url field was left blank.  Please fill in the url field."
  end

  if url_exists_in_file?(url) == true
    error_messages << "The url that you input is already in the article database.  You can only add articles that have not already been posted."
  end

  if description_test.length == 0
    error_messages << "The description was left blank.  Please input a description"
  end

  if description_test.length > 20
    error_messages << "The description field was greater than 20 characters.  Please input a description."
  end

  error_messages
end


# def valid_name?(name)

#   if name.length == 0
#     return false
#   else
#     return true
#   end
# end

# def valid_url?(url)

#   if url.length == 0
#     return false
#   end

#   if



# end




############################################
#####                                 #####
#####                                 #####
############################################
get '/' do
  @articles = pull_articles("articles.csv")

  erb :index

end

get '/submit' do
  @error_messages = []

  erb :submit
end

post '/submit' do
  name = params["article_name"]
  url = params["article_url"]
  description = params["article_description"]
  error_messages = validation_results(name, url, description)

  if error_messages.length == 0
    File.open('articles.csv','a') do |f|
      f.puts "#{name},#{url},#{description}"
    end

    redirect '/'

  else
    @name = name
    @url  = url
    @description = description
    @error_messages = error_messages

    erb :submit
  end


end











